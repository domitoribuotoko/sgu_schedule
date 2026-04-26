import 'package:dartz/dartz.dart';
import 'package:sgu_schedule/domain/_base/app_failure.dart';
import 'package:sgu_schedule/domain/_base/base_use_case.dart';
import 'package:sgu_schedule/domain/repositories/schedule_reference_cache_repository.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/cache/cached_study_forms_params.dart';

abstract interface class SaveStudyFormsToCacheUseCaseInterface
    extends BaseUseCase<SaveStudyFormsToCacheParams, Unit> {}

final class SaveStudyFormsToCacheUseCase
    implements SaveStudyFormsToCacheUseCaseInterface {
  SaveStudyFormsToCacheUseCase({required ScheduleReferenceCacheRepository cache})
    : _cache = cache;

  final ScheduleReferenceCacheRepository _cache;

  @override
  Future<Either<AppFailure, Unit>> call([
    SaveStudyFormsToCacheParams params = const SaveStudyFormsToCacheParams(),
  ]) {
    if (params.facultyId.isEmpty) {
      return Future.value(
        const Left<AppFailure, Unit>(
          AppFailure(
            message: 'SaveStudyFormsToCache: не задан facultyId',
            kind: AppFailureKind.unknown,
          ),
        ),
      );
    }
    return _cache.saveStudyForms(params.facultyId, params.items);
  }
}
