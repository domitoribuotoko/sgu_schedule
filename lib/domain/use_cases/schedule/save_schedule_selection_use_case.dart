import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:sgu_schedule/domain/_base/app_failure.dart';
import 'package:sgu_schedule/domain/_base/base_use_case.dart';
import 'package:sgu_schedule/domain/entities/schedule/schedule_group.dart';
import 'package:sgu_schedule/domain/entities/schedule/schedule_selection_snapshot.dart';
import 'package:sgu_schedule/domain/repositories/schedule_path_repository.dart';

/// Вход: выбранные идентификаторы и группа. Сохраняет [ScheduleSelectionSnapshot] в префс
/// (и дублирует путь в [schedule_last_path] для WebView / обратной совместимости).
class SaveScheduleSelectionInput {
  const SaveScheduleSelectionInput({
    required this.facultyId,
    required this.formId,
    required this.group,
    this.fragment = '',
  });

  final String facultyId;
  final String formId;
  final ScheduleGroup group;
  final String fragment;
}

abstract interface class SaveScheduleSelectionUseCaseInterface
    extends BaseUseCase<SaveScheduleSelectionInput, Unit> {}

final class SaveScheduleSelectionUseCase
    implements SaveScheduleSelectionUseCaseInterface {
  SaveScheduleSelectionUseCase({required SchedulePathRepository repository})
    : _repository = repository;

  final SchedulePathRepository _repository;

  @override
  FutureOr<Either<AppFailure, Unit>> call([
    SaveScheduleSelectionInput params = const SaveScheduleSelectionInput(
      facultyId: '',
      formId: '',
      group: _emptyGroup,
    ),
  ]) async {
    if (params.group.schedulePath.isEmpty) {
      return const Right(unit);
    }
    var path = params.group.schedulePath;
    path = path.startsWith('/') ? path : '/$path';
    var frag = params.fragment;
    if (frag.startsWith('#')) {
      frag = frag.substring(1);
    }
    try {
      final snap = ScheduleSelectionSnapshot(
        facultyId: params.facultyId,
        formId: params.formId,
        groupId: params.group.id,
        groupName: params.group.name,
        path: path,
        fragment: frag,
      );
      await _repository.saveSelectionSnapshot(snap);
      return const Right(unit);
    } on Object catch (e) {
      return Left(
        AppFailure(
          message: 'Не удалось сохранить выбор: $e',
          kind: AppFailureKind.storage,
        ),
      );
    }
  }
}

const _emptyGroup = ScheduleGroup(id: '', name: '', schedulePath: '');
