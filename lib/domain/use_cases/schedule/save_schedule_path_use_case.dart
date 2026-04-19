import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:sgu_schedule/domain/_base/app_failure.dart';
import 'package:sgu_schedule/domain/_base/base_use_case.dart';
import 'package:sgu_schedule/domain/repositories/schedule_path_repository.dart';

final class SaveSchedulePathInput {
  const SaveSchedulePathInput(this.path);

  final String path;
}

abstract interface class SaveSchedulePathUseCaseInterface
    extends BaseUseCase<SaveSchedulePathInput, Unit> {}

/// Сохраняет уже нормализованный путь без проверки URL WebView.
final class SaveSchedulePathUseCase implements SaveSchedulePathUseCaseInterface {
  SaveSchedulePathUseCase({required SchedulePathRepository repository})
    : _repository = repository;

  final SchedulePathRepository _repository;

  @override
  FutureOr<Either<AppFailure, Unit>> call([
    SaveSchedulePathInput params = const SaveSchedulePathInput(''),
  ]) async {
    if (params.path.isEmpty) {
      return const Right(unit);
    }
    try {
      await _repository.savePath(params.path);
      return const Right(unit);
    } on Object catch (e) {
      return Left(
        AppFailure(
          message: 'Не удалось сохранить путь: $e',
          kind: AppFailureKind.storage,
        ),
      );
    }
  }
}
