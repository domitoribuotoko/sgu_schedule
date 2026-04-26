import 'package:dartz/dartz.dart';
import 'package:sgu_schedule/domain/_base/app_failure.dart';
import 'package:sgu_schedule/domain/_base/base_use_case.dart';
import 'package:sgu_schedule/domain/entities/schedule/study_form.dart';
import 'package:sgu_schedule/domain/repositories/schedule_reference_repository.dart';

class LoadStudyFormsParams {
  const LoadStudyFormsParams({this.facultyId = ''});

  final String facultyId;
}

abstract interface class LoadStudyFormsUseCaseInterface
    extends BaseUseCase<LoadStudyFormsParams, List<StudyForm>> {}

final class LoadStudyFormsUseCase implements LoadStudyFormsUseCaseInterface {
  LoadStudyFormsUseCase({required ScheduleReferenceRepository repository})
    : _repository = repository;

  final ScheduleReferenceRepository _repository;

  @override
  Future<Either<AppFailure, List<StudyForm>>> call([
    LoadStudyFormsParams params = const LoadStudyFormsParams(),
  ]) {
    if (params.facultyId.isEmpty) {
      return Future.value(
        const Left<AppFailure, List<StudyForm>>(
          AppFailure(
            message: 'LoadStudyForms: не задан facultyId',
            kind: AppFailureKind.unknown,
          ),
        ),
      );
    }
    return _repository.getStudyForms(params.facultyId);
  }
}
