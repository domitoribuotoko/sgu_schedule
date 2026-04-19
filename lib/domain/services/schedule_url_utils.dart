/// Утилиты для распознавания URL страницы расписания конкретной группы
/// вида `/schedule/{факультет}/{форма}/{номер}` на `sgu.ru` / `www.sgu.ru`.
abstract final class ScheduleUrlUtils {
  static bool isSguHost(String? host) {
    if (host == null || host.isEmpty) {
      return false;
    }
    return host == 'sgu.ru' || host == 'www.sgu.ru';
  }

  static bool isGroupScheduleUri(Uri uri) {
    if (!isSguHost(uri.host)) {
      return false;
    }
    final segments = uri.pathSegments;
    if (segments.length != 4) {
      return false;
    }
    if (segments[0] != 'schedule') {
      return false;
    }
    if (segments[1] == 'teacher') {
      return false;
    }
    final group = segments[3];
    return RegExp(r'^\d+$').hasMatch(group);
  }

  static bool isGroupScheduleUrlString(String? url) {
    if (url == null || url.isEmpty) {
      return false;
    }
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return false;
    }
    return isGroupScheduleUri(uri);
  }

  static String? normalizedSchedulePath(String? url) {
    if (url == null || url.isEmpty) {
      return null;
    }
    if (!isGroupScheduleUrlString(url)) {
      return null;
    }
    final uri = Uri.parse(url);
    var path = uri.path;
    if (!path.startsWith('/')) {
      path = '/$path';
    }
    if (path.length > 1 && path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }
    return path;
  }

  /// Сравнение «тот же HTTP(S)-ресурс» без учёта фрагмента (`#session` и т.д.).
  static bool sameHttpDocumentIgnoringFragment(String a, String b) {
    final ua = Uri.tryParse(a);
    final ub = Uri.tryParse(b);
    if (ua == null || ub == null) {
      return a == b;
    }
    if (ua.scheme.toLowerCase() != ub.scheme.toLowerCase()) {
      return false;
    }
    if (ua.host.toLowerCase() != ub.host.toLowerCase()) {
      return false;
    }
    if (ua.hasPort != ub.hasPort) {
      return false;
    }
    if (ua.hasPort && ua.port != ub.port) {
      return false;
    }
    if (_normalizedPathForCompare(ua.path) !=
        _normalizedPathForCompare(ub.path)) {
      return false;
    }
    return ua.query == ub.query;
  }

  static String _normalizedPathForCompare(String path) {
    var p = path;
    if (!p.startsWith('/')) {
      p = '/$p';
    }
    if (p.length > 1 && p.endsWith('/')) {
      p = p.substring(0, p.length - 1);
    }
    return p;
  }
}
