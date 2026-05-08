import 'package:dartz/dartz.dart';
import 'package:sgu_schedule/domain/_base/app_failure.dart';
import 'package:sgu_schedule/domain/entities/schedule/schedule_selection_snapshot.dart';

abstract interface class TelegramScheduleBindingRepository {
  /// Снимок с сервера или `null` (нет сохранения / невалидный initData / 401).
  Future<Either<AppFailure, ScheduleSelectionSnapshot?>> getBinding(
    String initDataRaw,
  );

  Future<Either<AppFailure, Unit>> saveBinding(
    String initDataRaw,
    ScheduleSelectionSnapshot snapshot,
  );
}
