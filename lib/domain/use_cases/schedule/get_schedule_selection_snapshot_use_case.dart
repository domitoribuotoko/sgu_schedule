import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:sgu_schedule/domain/_base/app_failure.dart';
import 'package:sgu_schedule/domain/_base/base_use_case.dart';
import 'package:sgu_schedule/domain/entities/schedule/schedule_selection_snapshot.dart';
import 'package:sgu_schedule/domain/repositories/schedule_path_repository.dart';

abstract interface class GetScheduleSelectionSnapshotUseCaseInterface
    extends BaseUseCase<Unit, ScheduleSelectionSnapshot?> {}

final class GetScheduleSelectionSnapshotUseCase
    implements GetScheduleSelectionSnapshotUseCaseInterface {
  GetScheduleSelectionSnapshotUseCase({required SchedulePathRepository repository})
    : _repository = repository;

  final SchedulePathRepository _repository;

  @override
  FutureOr<Either<AppFailure, ScheduleSelectionSnapshot?>> call([
    Unit params = unit,
  ]) async {
    try {
      return Right(await _repository.readSelectionSnapshot());
    } on Object catch (e) {
      return Left(
        AppFailure(
          message: 'Не удалось прочитать выбор: $e',
          kind: AppFailureKind.storage,
        ),
      );
    }
  }
}
