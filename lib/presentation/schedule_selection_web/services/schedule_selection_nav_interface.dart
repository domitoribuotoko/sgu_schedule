import 'package:sgu_schedule/domain/entities/schedule/schedule_group.dart';

/// Навигация после выбора группы (веб).
abstract interface class ScheduleSelectionNav {
  void goToSchedule(ScheduleGroup group);
}
