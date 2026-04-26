import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:sgu_schedule/data/drift/schedule_ref_database.dart';
import 'package:sgu_schedule/data/dto/schedule_content/schedule_content_dtos.dart';
import 'package:sgu_schedule/data/mappers/schedule_timetable_mapper.dart';
import 'package:sgu_schedule/domain/_base/app_failure.dart';
import 'package:sgu_schedule/domain/entities/schedule/schedule_timetable.dart';
import 'package:sgu_schedule/domain/repositories/schedule_timetable_cache_repository.dart';

final class ScheduleTimetableCacheRepositoryImpl
    implements ScheduleTimetableCacheRepository {
  ScheduleTimetableCacheRepositoryImpl({required ScheduleRefDatabase db})
    : _db = db;

  final ScheduleRefDatabase _db;

  @override
  Future<Either<AppFailure, ScheduleTimetableCacheEntry?>> getWithMeta(
    String schedulePath,
    String viewKey,
  ) async {
    try {
      final path = _normPath(schedulePath);
      final view = _normView(viewKey);
      final row =
          await (_db.select(_db.scheduleTimetableCache)
                ..where(
                  (t) => t.schedulePath.equals(path) & t.viewKey.equals(view),
                ))
              .getSingleOrNull();
      if (row == null) {
        return const Right(null);
      }
      final m = json.decode(row.bodyJson) as Map<String, dynamic>;
      final dto = ScheduleContentResponseDto.fromJson(m);
      return Right((
        data: ScheduleTimetableMapper.fromDto(dto),
        validUntilMs: row.validUntilMs,
        fetchedAtMs: row.fetchedAtMs,
      ));
    } on Object catch (e) {
      return Left(
        AppFailure(
          message: 'Чтение кэша расписания: $e',
          kind: AppFailureKind.storage,
        ),
      );
    }
  }

  @override
  Future<Either<AppFailure, Unit>> save(
    String schedulePath,
    String viewKey,
    ScheduleTimetable content, {
    required int fetchedAtMs,
    required int validUntilMs,
  }) async {
    try {
      final path = _normPath(schedulePath);
      final view = _normView(viewKey);
      final json = jsonEncode(ScheduleTimetableMapper.toJsonMap(content));
      await _db.into(_db.scheduleTimetableCache).insertOnConflictUpdate(
        ScheduleTimetableCacheCompanion(
          schedulePath: Value(path),
          viewKey: Value(view),
          fetchedAtMs: Value(fetchedAtMs),
          validUntilMs: Value(validUntilMs),
          bodyJson: Value(json),
        ),
      );
      return const Right(unit);
    } on Object catch (e) {
      return Left(
        AppFailure(
          message: 'Запись кэша расписания: $e',
          kind: AppFailureKind.storage,
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

  static String _normView(String v) {
    return v.isEmpty ? 'all' : v;
  }
}
