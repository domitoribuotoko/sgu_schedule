import 'package:sgu_schedule/domain/entities/telegram_mini_app_launch.dart';

/// Доступ к Telegram Web App SDK (initData, ready) с платформенной реализацией в data-слое.
abstract interface class TelegramMiniAppGateway {
  /// Данные запуска; вне Telegram и без бэкапа в sessionStorage — [TelegramMiniAppLaunch.none].
  TelegramMiniAppLaunch readLaunchContext();

  /// Сообщить клиенту Telegram, что интерфейс готов (скрыть placeholder загрузки).
  void notifyWebAppReady();
}
