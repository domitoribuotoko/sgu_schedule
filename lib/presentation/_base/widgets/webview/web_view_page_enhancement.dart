import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// Настройка/доработка загружаемой страницы WebView без протекания деталей
/// конкретного экрана в [InAppWebView].
abstract class WebViewPageEnhancement {
  const WebViewPageEnhancement();

  /// Скрипты до первой загрузки (можно пусто).
  List<UserScript> get initialScripts => const [];

  /// Выполнить после [InAppWebView.onLoadStop] (ошибки обрабатывает вызывающий).
  Future<void> onLoadStop(InAppWebViewController controller, WebUri? url);
}
