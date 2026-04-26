import 'package:dartz/dartz.dart';
import 'package:sgu_schedule/domain/_base/app_failure.dart';
import 'package:sgu_schedule/domain/_base/base_use_case.dart';
import 'package:sgu_schedule/domain/entities/schedule/faculty.dart';
import 'package:sgu_schedule/domain/repositories/schedule_reference_cache_repository.dart';

class SaveFacultiesToCacheParams {
  const SaveFacultiesToCacheParams({this.items = const <Faculty>[]});

  final List<Faculty> items;
}

abstract interface class SaveFacultiesToCacheUseCaseInterface
    extends BaseUseCase<SaveFacultiesToCacheParams, Unit> {}

final class SaveFacultiesToCacheUseCase
    implements SaveFacultiesToCacheUseCaseInterface {
  SaveFacultiesToCacheUseCase({required ScheduleReferenceCacheRepository cache})
    : _cache = cache;

  final ScheduleReferenceCacheRepository _cache;

  @override
  Future<Either<AppFailure, Unit>> call([
    SaveFacultiesToCacheParams params = const SaveFacultiesToCacheParams(),
  ]) {
    return _cache.saveFaculties(params.items);
  }
}
