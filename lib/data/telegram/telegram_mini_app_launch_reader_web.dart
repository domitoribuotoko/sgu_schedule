import 'dart:convert';

import 'package:sgu_schedule/domain/entities/telegram_mini_app_launch.dart';
import 'package:telegram_web_app/telegram_web_app.dart';
import 'package:web/web.dart' as web;

/// Чтение initData и sessionStorage-бэкапа (`sgu_tg_launch_query`, см. `web/index.html`).
class TelegramMiniAppLaunchReader {
  TelegramMiniAppLaunchReader();

  static const String _storageKey = 'sgu_tg_launch_query';

  TelegramMiniAppLaunch read() {
    final tg = TelegramWebApp.instance;
    final mini = tg.isSupported;

    String? raw;
    try {
      final data = tg.initData;
      if (data.raw.isNotEmpty) {
        raw = data.raw;
      }
    } catch (_) {}

    raw ??= _readBackupField('tgWebAppData');

    final unsafe = tg.initDataUnsafe;
    var userId = unsafe?.user?.id;
    var startParam =
        unsafe?.startParam ?? _readBackupField('tgWebAppStartParam');

    if (userId == null && raw != null && raw.isNotEmpty) {
      try {
        userId = TelegramInitData.fromRawString(raw).user.id;
      } catch (_) {}
    }

    final noHints = !mini &&
        (raw == null || raw.isEmpty) &&
        userId == null &&
        (startParam == null || startParam.isEmpty);
    if (noHints) {
      return TelegramMiniAppLaunch.none;
    }

    return TelegramMiniAppLaunch(
      isTelegramMiniApp: mini,
      telegramUserId: userId,
      rawInitData: raw,
      startParam: startParam,
    );
  }

  void notifyReady() {
    try {
      TelegramWebApp.instance.ready();
    } catch (_) {}
  }

  String? _readBackupField(String key) {
    try {
      final s = web.window.sessionStorage.getItem(_storageKey);
      if (s == null || s.isEmpty) {
        return null;
      }
      final dynamic decoded = jsonDecode(s);
      if (decoded is! Map) {
        return null;
      }
      final v = decoded[key];
      return v is String ? v : null;
    } catch (_) {
      return null;
    }
  }
}
