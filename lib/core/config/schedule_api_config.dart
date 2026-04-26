import 'package:flutter/foundation.dart' show kDebugMode;

/// Базовый URL JSON API. Задаётся при сборке: `--dart-define=API_BASE_URL=...`
/// (пример: `https://ваш-домен.ru/sgu_api` для выкладки в подпапку).
/// [defaultValue] — прежний dev-адрес, если define не задан. Для Web в проде
/// укажите полный `https://…` к этому API (тот же origin, что и фронт, либо
/// другой — тогда CORS на сервере).
///
/// [Замечание] Flutter Web (в т.ч. Telegram Mini App) проверяет CORS. Сервер
/// обязан отвечать `Access-Control-Allow-Origin` для origin клиента, иначе
/// `Dio` выдаст сетевую ошибку (браузер обрежет ответ).
///
/// Для прод-размещения Mini App обычно нужен **HTTPS**; HTTP удобен для dev.
abstract final class ScheduleApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://188.253.17.93:9086',
  );

  /// Ответы API подменяются моками из [assets/mocks/schedule/] (Dio-интерцептор).
  /// Явно: `--dart-define=SCHEDULE_API_MOCK=true` или `=false`. Если define не
  /// задан: в `kDebugMode` моки **включены**, в release — **выключены**.
  static bool get useAssetMocks {
    const s = String.fromEnvironment('SCHEDULE_API_MOCK', defaultValue: '');
    if (s == 'true') {
      return true;
    }
    if (s == 'false') {
      return false;
    }
    return kDebugMode;
  }
}
