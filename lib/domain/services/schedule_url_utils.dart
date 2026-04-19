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
}
