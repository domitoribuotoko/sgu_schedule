import 'package:dartz/dartz.dart';
import 'package:sgu_schedule/domain/_base/app_failure.dart';
import 'package:sgu_schedule/domain/entities/schedule/schedule_timetable.dart';

/// Сеть: загрузка JSON расписания с бека (см. [docs/schedule_content_api.md]).
abstract interface class ScheduleTimetableRepository {
  Future<Either<AppFailure, ScheduleTimetable>> fetchRemote(
    String schedulePath,
    String viewKey,
  );
}
