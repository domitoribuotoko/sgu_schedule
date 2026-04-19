import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:sgu_schedule/domain/services/schedule_url_utils.dart';
import 'package:sgu_schedule/presentation/_base/utils/web_view_enhancements/web_view_enhancement.dart';
import 'package:sgu_schedule/presentation/_base/utils/web_view_enhancements/sgu_site_enc/sgu_site_chrome_hide_scripts.dart';

/// Мягкое скрытие типичных зон подвала на sgu.ru; при смене вёрстки просто не сработает.
final class SguSiteFooterHideEnhancement extends WebViewEnhancement {
  const SguSiteFooterHideEnhancement();

  static final UserScript _atDocumentStart = UserScript(
    groupName: 'sgu_schedule_footer_hide',
    source: SguSiteChromeHideScripts.footer,
    injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
  );

  @override
  List<UserScript> get initialScripts => [_atDocumentStart];

  @override
  Future<void> onLoadStop(InAppWebViewController controller, WebUri? url) async {
    if (url == null || !ScheduleUrlUtils.isSguHost(url.host)) {
      return;
    }
    try {
      await controller.evaluateJavascript(source: SguSiteChromeHideScripts.footer);
    } on Object catch (_) {}
  }
}
