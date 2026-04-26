import 'package:sgu_schedule/domain/entities/schedule/schedule_selection_snapshot.dart';

/// Последний выбранный путь расписания группы на сайте СГУ (`/schedule/...`).
/// Полный снимок выбора: [readSelectionSnapshot] / [saveSelectionSnapshot]; при миграции
/// с одного [schedule_last_path] запись `schedule_selection_v1` появляется лениво.
abstract interface class SchedulePathRepository {
  Future<String?> readSavedPath();

  Future<void> savePath(String path);

  Future<ScheduleSelectionSnapshot?> readSelectionSnapshot();

  Future<void> saveSelectionSnapshot(ScheduleSelectionSnapshot snapshot);

  Future<void> clear();
}
