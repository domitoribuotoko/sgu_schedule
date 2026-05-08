import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:sgu_schedule/domain/_base/app_failure.dart';
import 'package:sgu_schedule/domain/_base/base_use_case.dart';
import 'package:sgu_schedule/domain/entities/schedule/schedule_selection_snapshot.dart';
import 'package:sgu_schedule/domain/repositories/telegram_schedule_binding_repository.dart';

abstract interface class SaveTelegramScheduleBindingUseCaseInterface
    extends BaseUseCase<SaveTelegramScheduleBindingParams, Unit> {}

final class SaveTelegramScheduleBindingParams {
  const SaveTelegramScheduleBindingParams({
    required this.initDataRaw,
    required this.snapshot,
  });

  final String initDataRaw;
  final ScheduleSelectionSnapshot snapshot;
}

final class SaveTelegramScheduleBindingUseCase
    implements SaveTelegramScheduleBindingUseCaseInterface {
  SaveTelegramScheduleBindingUseCase({
    required TelegramScheduleBindingRepository repository,
  }) : _repository = repository;

  final TelegramScheduleBindingRepository _repository;

  @override
  FutureOr<Either<AppFailure, Unit>> call([
    SaveTelegramScheduleBindingParams params =
        const SaveTelegramScheduleBindingParams(
      initDataRaw: '',
      snapshot: _emptySnap,
    ),
  ]) {
    return _repository.saveBinding(params.initDataRaw, params.snapshot);
  }
}

const _emptySnap = ScheduleSelectionSnapshot(path: '');
