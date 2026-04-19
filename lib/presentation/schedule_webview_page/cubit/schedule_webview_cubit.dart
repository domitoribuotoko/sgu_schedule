import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:sgu_schedule/core/sgu_schedule_constants.dart';
import 'package:sgu_schedule/core/utils/trace_print.dart';
import 'package:sgu_schedule/domain/services/schedule_url_utils.dart';
import 'package:sgu_schedule/domain/use_cases/schedule/get_initial_schedule_web_url_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule/save_schedule_path_use_case.dart';
import 'package:sgu_schedule/presentation/_base/enums/webview_command_enum.dart';
import 'package:sgu_schedule/presentation/_base/mixins/cubit_extensions_mixin.dart';
import 'package:sgu_schedule/presentation/_base/services/app_link_laucher_service.dart';
import 'package:sgu_schedule/presentation/schedule_webview_page/cubit/schedule_webview_state.dart';

class ScheduleWebviewCubit extends Cubit<ScheduleWebviewState>
    with CubitExtensions<ScheduleWebviewState> {
  ScheduleWebviewCubit({
    required AppLinkLauncherInterface linkLauncher,
    required GetInitialScheduleWebUrlUseCaseInterface getInitialUrl,
    required SaveSchedulePathUseCaseInterface saveSchedulePath,
  }) : _getInitialUrl = getInitialUrl,
       _saveSchedulePath = saveSchedulePath,
       _linkLauncher = linkLauncher,
       super(
         ScheduleWebviewState(
           bootstrapComplete: false,
           webViewUrl: SguScheduleConstants.scheduleIndexUrl,
         ),
       );

  final GetInitialScheduleWebUrlUseCaseInterface _getInitialUrl;
  final SaveSchedulePathUseCaseInterface _saveSchedulePath;
  final AppLinkLauncherInterface _linkLauncher;

  void init() {
    _bootstrapFromStorage();
  }

  void _bootstrapFromStorage() async {
    final res = await _getInitialUrl.call();
    res.fold(
      (_) => _emitBootstrapUrl(SguScheduleConstants.scheduleIndexUrl),
      _emitBootstrapUrl,
    );
  }

  void _emitBootstrapUrl(String url) {
    final isGroup = url != SguScheduleConstants.scheduleIndexUrl;
    maybeEmit(
      state.copyWith(
        bootstrapComplete: true,
        webViewUrl: url,
        isLoading: true,
        hasSavedGroupSchedule: isGroup,
        savedScheduleWebUrl: isGroup ? url : '',
      ),
    );
  }

  void onWebViewLoadStateChange({required bool isLoading}) {
    if (state.isLoading != isLoading) {
      maybeEmit(state.copyWith(isLoading: isLoading));
    }
  }

  Future<bool> shouldOverrideUrlLoading(String? url) async {
    trace('oveerrid url $url');
    if (url == null || url.startsWith('about:')) {
      return true;
    }
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return true;
    }
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      return true;
    }
    if (!ScheduleUrlUtils.isSguHost(uri.host)) {
      await _linkLauncher.launchUri(uri);
      return false;
    }
    final path = ScheduleUrlUtils.normalizedSchedulePath(url);
    if (path != null) {
      final fragment = uri.fragment;
      final res = await _saveSchedulePath.call(
        SaveSchedulePathInput(path, fragment: fragment),
      );
      res.fold((_) {}, (_) {
        final savedUrl = fragment.isEmpty
            ? '${SguScheduleConstants.origin}$path'
            : '${SguScheduleConstants.origin}$path#$fragment';
        maybeEmit(
          state.copyWith(
            webViewUrl: url,
            hasSavedGroupSchedule: true,
            savedScheduleWebUrl: savedUrl,
          ),
        );
      });
    }
    return true;
  }

  void onBackTap() {
    maybeEmit(state.copyWith(webviewCommand: WebViewCommandEnum.back));
  }

  void onWebviewPopNotAvailable() {
    trace('cant back');
    if (state.webViewUrl == SguScheduleConstants.scheduleIndexUrl) {
      trace('dont reload'.red);
      return;
    }
    maybeEmit(
      state.copyWith(
        webViewUrl: SguScheduleConstants.scheduleIndexUrl,
        resetWebView: true,
        isLoading: true,
      ),
    );
  }

  void onWebViewCommandHandled(String? currentUrl) {
    trace('on command handled $currentUrl');
    if (state.webviewCommand != WebViewCommandEnum.none) {
      maybeEmit(
        state.copyWith(
          webviewCommand: WebViewCommandEnum.none,
          webViewUrl: currentUrl ?? state.webViewUrl,
        ),
      );
    }
  }

  void onLoadStop(InAppWebViewController? _, Uri? uri) {
    // if (uri == null) {
    //   return;
    // }
    // maybeEmit(state.copyWith(webViewUrl: uri.toString()));
  }

  void onResetWebViewEnd() {
    if (state.resetWebView) {
      maybeEmit(state.copyWith(resetWebView: false));
    }
  }

  void openScheduleSelection() {
    if (state.webViewUrl == SguScheduleConstants.scheduleIndexUrl) {
      return;
    }
    maybeEmit(
      state.copyWith(
        webViewUrl: SguScheduleConstants.scheduleIndexUrl,
        resetWebView: true,
        isLoading: true,
      ),
    );
  }

  void openSavedScheduleFromStorage() {
    if (!state.hasSavedGroupSchedule || state.savedScheduleWebUrl.isEmpty) {
      return;
    }
    if (ScheduleUrlUtils.sameHttpDocumentIgnoringFragment(
          state.webViewUrl,
          state.savedScheduleWebUrl,
        )) {
      return;
    }
    maybeEmit(
      state.copyWith(
        webViewUrl: state.savedScheduleWebUrl,
        // resetWebView: true,
        isLoading: true,
      ),
    );
  }
}
