import 'package:dartz/dartz.dart';
import 'package:sgu_schedule/domain/_base/app_failure.dart';
import 'package:sgu_schedule/domain/_base/base_use_case.dart';
import 'package:sgu_schedule/domain/entities/schedule/study_form.dart';
import 'package:sgu_schedule/domain/repositories/schedule_reference_cache_repository.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/cache/cached_study_forms_params.dart';

abstract interface class GetCachedStudyFormsUseCaseInterface
    extends BaseUseCase<CachedStudyFormsParams, List<StudyForm>> {}

final class GetCachedStudyFormsUseCase
    implements GetCachedStudyFormsUseCaseInterface {
  GetCachedStudyFormsUseCase({required ScheduleReferenceCacheRepository cache})
    : _cache = cache;

  final ScheduleReferenceCacheRepository _cache;

  @override
  Future<Either<AppFailure, List<StudyForm>>> call([
    CachedStudyFormsParams params = const CachedStudyFormsParams(),
  ]) {
    if (params.facultyId.isEmpty) {
      return Future.value(
        const Left<AppFailure, List<StudyForm>>(
          AppFailure(
            message: 'GetCachedStudyForms: не задан facultyId',
            kind: AppFailureKind.unknown,
          ),
        ),
      );
    }
    return _cache.getStudyForms(params.facultyId);
  }
}
