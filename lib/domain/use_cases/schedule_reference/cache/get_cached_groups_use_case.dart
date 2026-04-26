import 'package:dartz/dartz.dart';
import 'package:sgu_schedule/domain/_base/app_failure.dart';
import 'package:sgu_schedule/domain/_base/base_use_case.dart';
import 'package:sgu_schedule/domain/entities/schedule/schedule_group.dart';
import 'package:sgu_schedule/domain/repositories/schedule_reference_cache_repository.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/cache/cached_groups_params.dart';

abstract interface class GetCachedGroupsUseCaseInterface
    extends BaseUseCase<CachedGroupsParams, List<ScheduleGroup>> {}

final class GetCachedGroupsUseCase implements GetCachedGroupsUseCaseInterface {
  GetCachedGroupsUseCase({required ScheduleReferenceCacheRepository cache})
    : _cache = cache;

  final ScheduleReferenceCacheRepository _cache;

  @override
  Future<Either<AppFailure, List<ScheduleGroup>>> call([
    CachedGroupsParams params = const CachedGroupsParams(),
  ]) {
    if (params.facultyId.isEmpty || params.formId.isEmpty) {
      return Future.value(
        const Left<AppFailure, List<ScheduleGroup>>(
          AppFailure(
            message: 'GetCachedGroups: не заданы facultyId / formId',
            kind: AppFailureKind.unknown,
          ),
        ),
      );
    }
    return _cache.getGroups(params.facultyId, params.formId);
  }
}
