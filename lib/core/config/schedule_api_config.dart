import 'package:flutter/foundation.dart' show kDebugMode;

/// Базовый URL JSON API (бек на VPS). Смена — только здесь.
///
/// [Замечание] Flutter Web (в т.ч. Telegram Mini App) проверяет CORS. Сервер
/// обязан отвечать `Access-Control-Allow-Origin` для origin клиента, иначе
/// `Dio` выдаст сетевую ошибку (браузер обрежет ответ).
///
/// Для прод-размещения Mini App обычно нужен **HTTPS**; HTTP удобен для dev.
abstract final class ScheduleApiConfig {
  static const String baseUrl = 'http://188.253.17.93:9086';

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
