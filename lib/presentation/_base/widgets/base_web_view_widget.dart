import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:sgu_schedule/core/utils/trace_print.dart';
import 'package:sgu_schedule/presentation/_base/enums/webview_command_enum.dart';
import 'package:sgu_schedule/presentation/_base/utils/web_view_enhancements/web_view_enhancement.dart';

/// Ошибка основной навигации (главный фрейм): таймаут, сеть, SSL и т.п.
bool _isMainFrameNavigationFailure(WebResourceErrorType? type) {
  if (type == null) {
    return false;
  }
  return type == WebResourceErrorType.UNKNOWN ||
      type == WebResourceErrorType.FAILED_SSL_HANDSHAKE ||
      type == WebResourceErrorType.TIMEOUT ||
      type == WebResourceErrorType.CANNOT_CONNECT_TO_HOST ||
      type == WebResourceErrorType.HOST_LOOKUP ||
      type == WebResourceErrorType.IO ||
      type == WebResourceErrorType.NOT_CONNECTED_TO_INTERNET ||
      type == WebResourceErrorType.NETWORK_CONNECTION_LOST ||
      type == WebResourceErrorType.SERVER_UNREACHABLE ||
      type == WebResourceErrorType.CONNECTION_ABORTED ||
      type == WebResourceErrorType.CANNOT_LOAD_FROM_NETWORK ||
      type == WebResourceErrorType.RESET ||
      type == WebResourceErrorType.SECURE_CONNECTION_FAILED ||
      type == WebResourceErrorType.RESOURCE_UNAVAILABLE ||
      type == WebResourceErrorType.BAD_SERVER_RESPONSE ||
      type == WebResourceErrorType.FILE_NOT_FOUND ||
      type == WebResourceErrorType.REDIRECT_TO_NON_EXISTENT_LOCATION;
}

/// Обёртка над [InAppWebView]: загрузка, делегирование URL, сброс, команда «назад».
/// Упрощённый вариант по мотивам `sauri_flutter/.../simple_web_view.dart`.
class BaseWebViewWidget extends StatefulWidget {
  const BaseWebViewWidget({
    super.key,
    required this.initRequest,
    this.onLoadStateChange,
    this.onWebViewCreate,
    this.onLoadStop,
    this.shouldOverrideUrl,
    this.resetWebView = false,
    this.onResetWebViewEnd,
    this.onTotalFail,
    this.commandRequest = WebViewCommandEnum.none,
    this.onPopNotAvailable,
    this.onCommandHandled,
    this.cacheEnabled = true,
    this.cacheMode = CacheMode.LOAD_DEFAULT,
    this.enhancements = const [],
    this.shouldReloadAfterInitUrlChange,
  });

  /// Если null — при смене [initRequest.url] перезагрузка, когда строки URL различаются.
  /// Иначе — перезагрузка только если колбэк вернёт true (например игнорировать смену только `#fragment`).
  final bool Function(String oldUrl, String newUrl)?
  shouldReloadAfterInitUrlChange;

  final URLRequest initRequest;
  final void Function({required bool isLoading})? onLoadStateChange;
  final void Function(InAppWebViewController controller)? onWebViewCreate;
  final void Function(InAppWebViewController controller, Uri? uri)? onLoadStop;
  final Future<bool> Function(String? url)? shouldOverrideUrl;
  final bool resetWebView;
  final VoidCallback? onResetWebViewEnd;
  final VoidCallback? onTotalFail;
  final WebViewCommandEnum commandRequest;
  final VoidCallback? onPopNotAvailable;

  /// После обработки «назад»: не-null — синхронизировать URL из WebView; null — при
  /// [onPopNotAvailable] или отсутствии контроллера, чтобы не подставлять устаревший [getUrl].
  final void Function(String? currentUrl)? onCommandHandled;
  final bool cacheEnabled;
  final CacheMode cacheMode;
  final List<WebViewEnhancement> enhancements;

  @override
  State<BaseWebViewWidget> createState() => _BaseWebViewWidgetState();
}

class _BaseWebViewWidgetState extends State<BaseWebViewWidget> {
  InAppWebViewController? _controller;
  bool _isLoading = true;
  bool _wasError = false;

  Future<String?> get _currentUrl async {
    final res = await _controller?.getUrl();
    return res?.uriValue.toString();
  }

  /// После `loadUrl`/`clearHistory` Chromium может вызвать `onLoadStop` до `onLoadStart`
  /// нового цикла — не снимаем лоадер, пока не увидели `onLoadStart`.
  bool _awaitingLoadStartAfterProgrammaticLoad = false;

  /// После [loadUrl] из [_resetWebViewLocal]: [clearHistory] нужно вызывать когда новая
  /// страница уже в коммите, иначе в стеке остаётся предыдущий документ и [canGoBack] true.
  bool _clearHistoryAfterNextCommittedLoadStop = false;

  @override
  void didUpdateWidget(covariant BaseWebViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldU = oldWidget.initRequest.url?.toString() ?? '';
    final newU = widget.initRequest.url?.toString() ?? '';
    if (newU.isNotEmpty && _shouldReloadForInitUrlChange(oldU, newU)) {
      _reloadInitRequestAfterUrlChange();
    }
    if (widget.resetWebView && widget.resetWebView != oldWidget.resetWebView) {
      _resetWebViewLocal();
    }
    if (widget.commandRequest != oldWidget.commandRequest) {
      if (widget.commandRequest.isBack) {
        _tryGoBack();
      }
      if (widget.commandRequest.isClear) {
        _controller?.clearHistory();
        widget.onCommandHandled?.call(null);
      }
    }
  }

  bool _shouldReloadForInitUrlChange(String oldUrl, String newUrl) {
    final custom = widget.shouldReloadAfterInitUrlChange;
    if (custom != null) {
      return custom(oldUrl, newUrl);
    }
    return oldUrl != newUrl;
  }

  void _reloadInitRequestAfterUrlChange() async {
    trace('reload request after url change ${widget.initRequest}');
    if (widget.initRequest.url?.uriValue.toString() == await _currentUrl) {
      trace('dont reload cause already here');
      return;
    }
    void load(InAppWebViewController? c) {
      if (!mounted || c == null) {
        return;
      }
      if (_wasError) {
        setState(() => _wasError = false);
      }
      _loadingCallback(true, programmaticLoad: true);
      c.loadUrl(urlRequest: widget.initRequest);
    }

    if (_controller != null) {
      load(_controller);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        load(_controller);
      });
    }
  }

  Future<void> _tryGoBack() async {
    if (_controller == null) {
      widget.onPopNotAvailable?.call();
      // Не подставляем getUrl: контроллера нет, URL из WebView недостоверен.
      widget.onCommandHandled?.call(null);
      return;
    }
    final can = await _controller!.canGoBack();
    if (can) {
      await _controller!.goBack();
      widget.onCommandHandled?.call(await _currentUrl);
      return;
    }
    widget.onPopNotAvailable?.call();
    // После onPopNotAvailable кубит уже выставил целевой URL (напр. индекс), а getUrl()
    // ещё отдаёт старую страницу — не перезаписывать webViewUrl.
    widget.onCommandHandled?.call(null);
  }

  Future<void> _resetWebViewLocal() async {
    _loadingCallback(true, programmaticLoad: true);
    _clearHistoryAfterNextCommittedLoadStop = true;
    await _controller?.loadUrl(urlRequest: widget.initRequest);
    widget.onResetWebViewEnd?.call();
  }

  void _loadingCallback(bool isLoading, {bool programmaticLoad = false}) {
    if (isLoading && programmaticLoad) {
      _awaitingLoadStartAfterProgrammaticLoad = true;
    }
    if (!isLoading) {
      _awaitingLoadStartAfterProgrammaticLoad = false;
    }
    if (_isLoading != isLoading) {
      setState(() => _isLoading = isLoading);
    }
    widget.onLoadStateChange?.call(isLoading: isLoading);
  }

  void _onLoadStart(InAppWebViewController controller, WebUri? url) {
    if (_awaitingLoadStartAfterProgrammaticLoad) {
      _awaitingLoadStartAfterProgrammaticLoad = false;
    }
  }

  void _onWebViewCreated(InAppWebViewController controller) {
    _controller = controller;
    widget.onWebViewCreate?.call(controller);
  }

  Future<void> _onLoadStop(
    InAppWebViewController controller,
    WebUri? uri,
  ) async {
    if (_awaitingLoadStartAfterProgrammaticLoad) {
      return;
    }
    if (_clearHistoryAfterNextCommittedLoadStop) {
      _clearHistoryAfterNextCommittedLoadStop = false;
      try {
        await controller.clearHistory();
      } on Object catch (_) {}
    }
    _loadingCallback(false);
    widget.onLoadStop?.call(controller, uri);
    for (final e in widget.enhancements) {
      try {
        await e.onLoadStop(controller, uri);
      } on Object catch (_) {}
    }
  }

  void _onReceivedError(
    InAppWebViewController controller,
    WebResourceRequest request,
    WebResourceError error,
  ) {
    if (!(request.isForMainFrame ?? false)) {
      return;
    }
    if (!_isMainFrameNavigationFailure(error.type)) {
      return;
    }
    _clearHistoryAfterNextCommittedLoadStop = false;
    if (mounted) {
      setState(() => _wasError = true);
    }
    _loadingCallback(false);
    widget.onTotalFail?.call();
  }

  void _onReceivedHttpError(
    InAppWebViewController controller,
    WebResourceRequest request,
    WebResourceResponse errorResponse,
  ) {
    final statusCode = errorResponse.statusCode;
    if (statusCode == null) {
      return;
    }
    final isMainFrame = request.isForMainFrame ?? false;
    if (!isMainFrame || statusCode < 400) {
      return;
    }
    _clearHistoryAfterNextCommittedLoadStop = false;
    if (mounted) {
      setState(() => _wasError = true);
    }
    _loadingCallback(false);
    widget.onTotalFail?.call();
  }

  Future<ServerTrustAuthResponse?> _onReceivedServerTrustAuthRequest(
    InAppWebViewController controller,
    URLAuthenticationChallenge challenge,
  ) async {
    _clearHistoryAfterNextCommittedLoadStop = false;
    if (mounted) {
      setState(() => _wasError = true);
    }
    _loadingCallback(false);
    widget.onTotalFail?.call();
    return ServerTrustAuthResponse(
      action: ServerTrustAuthResponseAction.CANCEL,
    );
  }

  Future<NavigationActionPolicy?> _shouldOverrideUrlLoading(
    InAppWebViewController controller,
    NavigationAction navigationAction,
  ) async {
    final url = navigationAction.request.url?.toString();

    if (url?.startsWith('about:') == true) {
      return NavigationActionPolicy.ALLOW;
    }

    final shouldAllow = await _resolveShouldAllowUrl(url);
    if (shouldAllow) {
      // Не помечаем как programmatic: при первой загрузке вызывается и здесь,
      // иначе onLoadStop до onLoadStart игнорируется и лоадер не снимается.
      _loadingCallback(true);
    }
    return shouldAllow
        ? NavigationActionPolicy.ALLOW
        : NavigationActionPolicy.CANCEL;
  }

  Future<bool> _resolveShouldAllowUrl(String? url) async {
    if (widget.shouldOverrideUrl != null) {
      return widget.shouldOverrideUrl!(url);
    }
    return true;
  }

  void _reloadWebView() {
    if (_wasError) {
      setState(() => _wasError = false);
    }
    _loadingCallback(true, programmaticLoad: true);
    _controller?.loadUrl(urlRequest: widget.initRequest);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: _wasError || _isLoading ? 0 : 1,
          child: _buildWebView(),
        ),
        if (_wasError) _buildErrorWidget(context),
      ],
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Ошибка загрузки',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _reloadWebView,
            child: const Text('Перезагрузить'),
          ),
        ],
      ),
    );
  }

  Widget _buildWebView() {
    final initialScripts = widget.enhancements
        .expand((e) => e.initialScripts)
        .toList();
    return InAppWebView(
      initialUrlRequest: widget.initRequest,
      initialUserScripts: initialScripts.isEmpty
          ? null
          : UnmodifiableListView(initialScripts),
      initialSettings: InAppWebViewSettings(
        preferredContentMode: UserPreferredContentMode.MOBILE,
        transparentBackground: true,
        useShouldOverrideUrlLoading: true,
        cacheEnabled: widget.cacheEnabled,
        cacheMode: widget.cacheMode,
      ),
      onWebViewCreated: _onWebViewCreated,
      onLoadStart: _onLoadStart,
      onReceivedError: _onReceivedError,
      onReceivedHttpError: _onReceivedHttpError,
      onReceivedServerTrustAuthRequest: _onReceivedServerTrustAuthRequest,
      onLoadStop: _onLoadStop,
      shouldOverrideUrlLoading: _shouldOverrideUrlLoading,
    );
  }
}
