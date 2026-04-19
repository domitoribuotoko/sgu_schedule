/// Последний выбранный путь расписания группы на сайте СГУ (`/schedule/...`).
abstract interface class SchedulePathRepository {
  Future<String?> readSavedPath();

  Future<void> savePath(String path);

  Future<void> clear();
}
