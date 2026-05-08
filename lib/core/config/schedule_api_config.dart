import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;

/// Базовый URL JSON API.
///
/// **Web:** если `API_BASE_URL` не задан — берётся тот же origin, что у страницы
/// (любой домен), путь `/sgu_api`, т.е. бэк на том же хостинге рядом с фронтом.
///
/// Явный URL: `--dart-define=API_BASE_URL=https://…/sgu_api` (другой бэк, отладка).
/// [defaultValue] для не‑web, если define пустой — прежний dev‑адрес.
///
/// CORS, HTTPS, Mini App — см. комментарии в истории; при same-origin CORS к своему API не нужен.
abstract final class ScheduleApiConfig {
  static const String _apiBaseFromEnv = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static String get baseUrl {
    final env = _apiBaseFromEnv.trim();
    if (env.isNotEmpty) {
      return env;
    }
    return _sameHostSguApi();
  }

  static String _sameHostSguApi() {
    final u = Uri.base;
    return '${u.origin}/sgu_api';
  }

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
