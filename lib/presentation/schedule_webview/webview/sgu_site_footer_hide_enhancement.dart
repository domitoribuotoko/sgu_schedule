import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:sgu_schedule/domain/services/schedule_url_utils.dart';
import 'package:sgu_schedule/presentation/_base/widgets/webview/web_view_page_enhancement.dart';

/// Мягкое скрытие типичных зон подвала на sgu.ru; при смене вёрстки просто не сработает.
final class SguSiteFooterHideEnhancement extends WebViewPageEnhancement {
  const SguSiteFooterHideEnhancement();

  @override
  Future<void> onLoadStop(InAppWebViewController controller, WebUri? url) async {
    if (url == null || !ScheduleUrlUtils.isSguHost(url.host)) {
      return;
    }
    try {
      await controller.evaluateJavascript(
        source: r'''
(function(){try{var s=document.createElement('style');s.setAttribute('data-sgu-schedule','footer');s.innerHTML='footer,.site-footer,.page-footer,#footer,.footer-region,.region-footer{display:none!important;}';document.documentElement.appendChild(s);}catch(e){}})();
''',
      );
    } on Object catch (_) {}
  }
}
