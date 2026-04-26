import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sgu_schedule/data/mappers/schedule_timetable_mapper.dart';
import 'package:sgu_schedule/data/network/sgu_schedule_api.dart';
import 'package:sgu_schedule/domain/_base/app_failure.dart';
import 'package:sgu_schedule/domain/entities/schedule/schedule_timetable.dart';
import 'package:sgu_schedule/domain/repositories/schedule_timetable_repository.dart';

final class ScheduleTimetableRepositoryImpl implements ScheduleTimetableRepository {
  ScheduleTimetableRepositoryImpl({required SguScheduleApi api}) : _api = api;

  final SguScheduleApi _api;

  @override
  Future<Either<AppFailure, ScheduleTimetable>> fetchRemote(
    String schedulePath,
    String viewKey,
  ) async {
    final path = _normPath(schedulePath);
    final view = _normView(viewKey);
    if (path.isEmpty) {
      return Left(
        AppFailure(
          message: 'Пустой путь расписания',
          kind: AppFailureKind.unknown,
        ),
      );
    }
    try {
      final dto = await _api.getScheduleContent(path, view);
      return Right(ScheduleTimetableMapper.fromDto(dto));
    } on DioException catch (e) {
      return Left(
        AppFailure(
          message: e.message ?? 'Сеть: расписание',
          kind: AppFailureKind.network,
        ),
      );
    } on Object catch (e) {
      return Left(
        AppFailure(
          message: 'Расписание: $e',
          kind: AppFailureKind.unknown,
        ),
      );
    }
  }

  static String _normPath(String p) {
    var s = p.trim();
    if (s.isEmpty) {
      return '';
    }
    return s.startsWith('/') ? s : '/$s';
  }

  static String _normView(String v) => v.isEmpty ? 'all' : v;
}
