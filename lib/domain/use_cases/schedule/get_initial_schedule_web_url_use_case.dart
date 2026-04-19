import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:sgu_schedule/core/sgu_schedule_constants.dart';
import 'package:sgu_schedule/domain/_base/app_failure.dart';
import 'package:sgu_schedule/domain/_base/base_use_case.dart';
import 'package:sgu_schedule/domain/repositories/schedule_path_repository.dart';
import 'package:sgu_schedule/domain/services/schedule_url_utils.dart';

abstract interface class GetInitialScheduleWebUrlUseCaseInterface
    extends BaseUseCase<Unit, String> {}

final class GetInitialScheduleWebUrlUseCase
    implements GetInitialScheduleWebUrlUseCaseInterface {
  GetInitialScheduleWebUrlUseCase({required SchedulePathRepository repository})
    : _repository = repository;

  final SchedulePathRepository _repository;

  @override
  FutureOr<Either<AppFailure, String>> call([Unit params = unit]) async {
    try {
      final path = await _repository.readSavedPath();
      if (path != null) {
        final uri = Uri.tryParse('${SguScheduleConstants.origin}$path');
        if (uri == null || !ScheduleUrlUtils.isGroupScheduleUri(uri)) {
          await _repository.clear();
          return Right(SguScheduleConstants.scheduleIndexUrl);
        }
        return Right('${SguScheduleConstants.origin}$path');
      }
      return Right(SguScheduleConstants.scheduleIndexUrl);
    } on Object catch (e) {
      return Left(
        AppFailure(
          message: 'Не удалось прочитать сохранённое расписание: $e',
          kind: AppFailureKind.storage,
        ),
      );
    }
  }
}
