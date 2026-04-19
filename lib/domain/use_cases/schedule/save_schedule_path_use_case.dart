import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:sgu_schedule/domain/_base/app_failure.dart';
import 'package:sgu_schedule/domain/_base/base_use_case.dart';
import 'package:sgu_schedule/domain/repositories/schedule_path_repository.dart';

final class SaveSchedulePathInput {
  const SaveSchedulePathInput(this.path, {this.fragment = ''});

  /// Нормализованный путь вида `/schedule/.../421` без `#`.
  final String path;

  /// Фрагмент без ведущего `#` (например `session`, `lection`).
  final String fragment;
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
      var normalizedPath =
          params.path.startsWith('/') ? params.path : '/${params.path}';
      var frag = params.fragment;
      if (frag.startsWith('#')) {
        frag = frag.substring(1);
      }
      final stored =
          frag.isEmpty ? normalizedPath : '$normalizedPath#$frag';
      await _repository.savePath(stored);
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
