import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// Настройка/доработка загружаемой страницы WebView без протекания деталей
/// конкретного экрана в [InAppWebView].
abstract class WebViewEnhancement {
  const WebViewEnhancement();

  /// Ранний инжект (например [UserScriptInjectionTime.AT_DOCUMENT_START]), до отрисовки.
  List<UserScript> get initialScripts => const [];

  /// Повтор после загрузки: SPA, смена DOM, случаи без поддержки document-start на WebView.
  Future<void> onLoadStop(InAppWebViewController controller, WebUri? url);
}
