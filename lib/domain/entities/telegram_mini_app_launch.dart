/// Снимок контекста запуска Telegram Mini App (без валидации подписи на сервере).
class TelegramMiniAppLaunch {
  const TelegramMiniAppLaunch({
    required this.isTelegramMiniApp,
    this.telegramUserId,
    this.rawInitData,
    this.startParam,
  });

  /// Открыто внутри клиента Telegram ([TelegramWebApp.isSupported]).
  final bool isTelegramMiniApp;

  /// Id пользователя из initData / initDataUnsafe при наличии.
  final int? telegramUserId;

  /// Сырая строка initData для проверки на бэкенде.
  final String? rawInitData;

  /// start_param / tgWebAppStartParam.
  final String? startParam;

  static const TelegramMiniAppLaunch none = TelegramMiniAppLaunch(
    isTelegramMiniApp: false,
  );
}
