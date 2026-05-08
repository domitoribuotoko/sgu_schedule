import 'package:sgu_schedule/domain/entities/telegram_mini_app_launch.dart';

/// Заглушка вне `dart:html` / не-web: без Telegram SDK.
class TelegramMiniAppLaunchReader {
  TelegramMiniAppLaunchReader();

  TelegramMiniAppLaunch read() => TelegramMiniAppLaunch.none;

  void notifyReady() {}
}
