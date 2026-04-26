import 'package:dartz/dartz.dart';
import 'package:sgu_schedule/domain/_base/app_failure.dart';
import 'package:sgu_schedule/domain/_base/base_use_case.dart';
import 'package:sgu_schedule/domain/entities/schedule/faculty.dart';
import 'package:sgu_schedule/domain/repositories/schedule_reference_cache_repository.dart';

abstract interface class GetCachedFacultiesUseCaseInterface
    extends BaseUseCase<Unit, List<Faculty>> {}

final class GetCachedFacultiesUseCase
    implements GetCachedFacultiesUseCaseInterface {
  GetCachedFacultiesUseCase({required ScheduleReferenceCacheRepository cache})
    : _cache = cache;

  final ScheduleReferenceCacheRepository _cache;

  @override
  Future<Either<AppFailure, List<Faculty>>> call([Unit p = unit]) {
    return _cache.getFaculties();
  }
}
