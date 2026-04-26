import 'package:dartz/dartz.dart';
import 'package:sgu_schedule/domain/_base/app_failure.dart';
import 'package:sgu_schedule/domain/entities/schedule/faculty.dart';
import 'package:sgu_schedule/domain/entities/schedule/schedule_group.dart';
import 'package:sgu_schedule/domain/entities/schedule/study_form.dart';

/// Справочники расписания с бэка (факультеты, формы, группы).
abstract class ScheduleReferenceRepository {
  Future<Either<AppFailure, List<Faculty>>> getFaculties();

  Future<Either<AppFailure, List<StudyForm>>> getStudyForms(String facultyId);

  Future<Either<AppFailure, List<ScheduleGroup>>> getGroups({
    required String facultyId,
    required String formId,
  });
}
