import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:sgu_schedule/domain/_base/app_failure.dart';
import 'package:sgu_schedule/domain/_base/base_use_case.dart';
import 'package:sgu_schedule/domain/entities/schedule/schedule_selection_snapshot.dart';
import 'package:sgu_schedule/domain/repositories/telegram_schedule_binding_repository.dart';

abstract interface class GetTelegramScheduleBindingUseCaseInterface
    extends BaseUseCase<GetTelegramScheduleBindingParams,
        ScheduleSelectionSnapshot?> {}

final class GetTelegramScheduleBindingParams {
  const GetTelegramScheduleBindingParams({required this.initDataRaw});

  final String initDataRaw;
}

final class GetTelegramScheduleBindingUseCase
    implements GetTelegramScheduleBindingUseCaseInterface {
  GetTelegramScheduleBindingUseCase({
    required TelegramScheduleBindingRepository repository,
  }) : _repository = repository;

  final TelegramScheduleBindingRepository _repository;

  @override
  FutureOr<Either<AppFailure, ScheduleSelectionSnapshot?>> call([
    GetTelegramScheduleBindingParams params =
        const GetTelegramScheduleBindingParams(initDataRaw: ''),
  ]) {
    return _repository.getBinding(params.initDataRaw);
  }
}
