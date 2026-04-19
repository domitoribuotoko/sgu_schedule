/// Базовый хост портала расписания СГУ.
abstract final class SguScheduleConstants {
  static const String origin = 'https://www.sgu.ru';
  static const String scheduleIndexPath = '/schedule';
  static String get scheduleIndexUrl => '$origin$scheduleIndexPath';
}
