import 'package:dartz/dartz.dart';
import 'package:sgu_schedule/domain/_base/app_failure.dart';
import 'package:sgu_schedule/domain/_base/base_use_case.dart';
import 'package:sgu_schedule/domain/repositories/schedule_reference_cache_repository.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/cache/cached_groups_params.dart';

abstract interface class SaveGroupsToCacheUseCaseInterface
    extends BaseUseCase<SaveGroupsToCacheParams, Unit> {}

final class SaveGroupsToCacheUseCase
    implements SaveGroupsToCacheUseCaseInterface {
  SaveGroupsToCacheUseCase({required ScheduleReferenceCacheRepository cache})
    : _cache = cache;

  final ScheduleReferenceCacheRepository _cache;

  @override
  Future<Either<AppFailure, Unit>> call([
    SaveGroupsToCacheParams params = const SaveGroupsToCacheParams(),
  ]) {
    if (params.facultyId.isEmpty || params.formId.isEmpty) {
      return Future.value(
        const Left<AppFailure, Unit>(
          AppFailure(
            message: 'SaveGroupsToCache: не заданы facultyId / formId',
            kind: AppFailureKind.unknown,
          ),
        ),
      );
    }
    return _cache.saveGroups(params.facultyId, params.formId, params.items);
  }
}
