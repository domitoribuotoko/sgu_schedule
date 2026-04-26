import 'package:dartz/dartz.dart';
import 'package:sgu_schedule/domain/_base/app_failure.dart';
import 'package:sgu_schedule/domain/entities/schedule/faculty.dart';
import 'package:sgu_schedule/domain/entities/schedule/schedule_group.dart';
import 'package:sgu_schedule/domain/entities/schedule/study_form.dart';

/// Локальный кэш справочников (Drift + JSON).
abstract class ScheduleReferenceCacheRepository {
  Future<Either<AppFailure, List<Faculty>>> getFaculties();

  Future<Either<AppFailure, Unit>> saveFaculties(List<Faculty> items);

  Future<Either<AppFailure, int?>> readFacultiesUpdatedAtMs();

  Future<Either<AppFailure, List<StudyForm>>> getStudyForms(String facultyId);

  Future<Either<AppFailure, Unit>> saveStudyForms(
    String facultyId,
    List<StudyForm> items,
  );

  Future<Either<AppFailure, List<ScheduleGroup>>> getGroups(
    String facultyId,
    String formId,
  );

  Future<Either<AppFailure, Unit>> saveGroups(
    String facultyId,
    String formId,
    List<ScheduleGroup> items,
  );
}
