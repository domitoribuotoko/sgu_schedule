import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sgu_schedule/data/network/sgu_schedule_api.dart';
import 'package:sgu_schedule/domain/_base/app_failure.dart';
import 'package:sgu_schedule/domain/entities/schedule/faculty.dart';
import 'package:sgu_schedule/domain/entities/schedule/schedule_group.dart';
import 'package:sgu_schedule/domain/entities/schedule/study_form.dart';
import 'package:sgu_schedule/domain/repositories/schedule_reference_repository.dart';

class ScheduleReferenceRepositoryImpl implements ScheduleReferenceRepository {
  ScheduleReferenceRepositoryImpl({required SguScheduleApi api}) : _api = api;

  final SguScheduleApi _api;

  @override
  Future<Either<AppFailure, List<Faculty>>> getFaculties() async {
    return _map(() async {
      final r = await _api.getFaculties();
      return r.items
          .map(
            (e) => Faculty(
              id: e.id,
              name: e.name,
              kind: e.kind,
            ),
          )
          .toList();
    });
  }

  @override
  Future<Either<AppFailure, List<ScheduleGroup>>> getGroups({
    required String facultyId,
    required String formId,
  }) async {
    return _map(() async {
      final r = await _api.getGroups(facultyId, formId);
      return r.items
          .map(
            (e) => ScheduleGroup(
              id: e.id,
              name: e.name,
              schedulePath: e.schedulePath,
            ),
          )
          .toList();
    });
  }

  @override
  Future<Either<AppFailure, List<StudyForm>>> getStudyForms(
    String facultyId,
  ) async {
    return _map(() async {
      final r = await _api.getStudyForms(facultyId);
      return r.items
          .map(
            (e) => StudyForm(
              id: e.id,
              name: e.name,
            ),
          )
          .toList();
    });
  }

  Future<Either<AppFailure, T>> _map<T>(Future<T> Function() f) async {
    try {
      return Right(await f());
    } on DioException catch (e) {
      final msg = e.message ?? e.response?.data?.toString() ?? 'DioException';
      return Left(
        AppFailure(
          message: 'Сеть: $msg',
          kind: AppFailureKind.network,
        ),
      );
    } on Object catch (e) {
      return Left(
        AppFailure(
          message: 'Справочник расписания: $e',
          kind: AppFailureKind.unknown,
        ),
      );
    }
  }
}
