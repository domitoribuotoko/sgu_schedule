import 'package:dartz/dartz.dart';
import 'package:sgu_schedule/domain/_base/app_failure.dart';
import 'package:sgu_schedule/domain/entities/schedule/schedule_timetable.dart';

/// Строка кэша + [validUntilMs] для политики TTL.
typedef ScheduleTimetableCacheEntry = ({
  ScheduleTimetable data,
  int validUntilMs,
  int fetchedAtMs,
});

/// Кэш тела [ScheduleTimetable] (JSON с бека) в Drift.
abstract interface class ScheduleTimetableCacheRepository {
  /// Данные и метаданные; `null` если нет записи.
  Future<Either<AppFailure, ScheduleTimetableCacheEntry?>> getWithMeta(
    String schedulePath,
    String viewKey,
  );

  Future<Either<AppFailure, Unit>> save(
    String schedulePath,
    String viewKey,
    ScheduleTimetable content, {
    required int fetchedAtMs,
    required int validUntilMs,
  });
}
