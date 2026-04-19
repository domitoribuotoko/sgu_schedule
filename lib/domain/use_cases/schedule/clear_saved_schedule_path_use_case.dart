import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:sgu_schedule/domain/_base/app_failure.dart';
import 'package:sgu_schedule/domain/_base/base_use_case.dart';
import 'package:sgu_schedule/domain/repositories/schedule_path_repository.dart';

abstract interface class ClearSavedSchedulePathUseCaseInterface
    extends BaseUseCase<Unit, Unit> {}

final class ClearSavedSchedulePathUseCase
    implements ClearSavedSchedulePathUseCaseInterface {
  ClearSavedSchedulePathUseCase({required SchedulePathRepository repository})
    : _repository = repository;

  final SchedulePathRepository _repository;

  @override
  FutureOr<Either<AppFailure, Unit>> call([Unit params = unit]) async {
    try {
      await _repository.clear();
      return const Right(unit);
    } on Object catch (e) {
      return Left(
        AppFailure(
          message: 'Не удалось сбросить сохранённое расписание: $e',
          kind: AppFailureKind.storage,
        ),
      );
    }
  }
}
