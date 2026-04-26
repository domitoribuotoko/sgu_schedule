import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:sgu_schedule/data/drift/schedule_ref_database.dart';
import 'package:sgu_schedule/data/dto/schedule_reference_cache/schedule_reference_cache_dtos.dart';
import 'package:sgu_schedule/domain/_base/app_failure.dart';
import 'package:sgu_schedule/domain/entities/schedule/faculty.dart';
import 'package:sgu_schedule/domain/entities/schedule/schedule_group.dart';
import 'package:sgu_schedule/domain/entities/schedule/study_form.dart';
import 'package:sgu_schedule/domain/repositories/schedule_reference_cache_repository.dart';

class ScheduleReferenceCacheRepositoryImpl
    implements ScheduleReferenceCacheRepository {
  ScheduleReferenceCacheRepositoryImpl({required ScheduleRefDatabase db})
    : _db = db;

  final ScheduleRefDatabase _db;

  static const int _facultiesSingletonId = 1;

  @override
  Future<Either<AppFailure, List<Faculty>>> getFaculties() async {
    try {
      final row =
          await (_db.select(_db.facultiesCache)
                ..where((t) => t.id.equals(_facultiesSingletonId)))
              .getSingleOrNull();
      if (row == null) {
        return const Right(<Faculty>[]);
      }
      final payload = FacultiesCachePayloadDto.fromJson(
        jsonDecode(row.itemsJson) as Map<String, dynamic>,
      );
      return Right(
        payload.items
            .map(
              (e) => Faculty(
                id: e.id,
                name: e.name,
                kind: e.kind,
              ),
            )
            .toList(),
      );
    } on Object catch (e) {
      return Left(
        AppFailure(
          message: 'Кэш факультетов: $e',
          kind: AppFailureKind.storage,
        ),
      );
    }
  }

  @override
  Future<Either<AppFailure, Unit>> saveFaculties(List<Faculty> items) async {
    try {
      final dto = FacultiesCachePayloadDto(
        items: items
            .map(
              (e) => FacultyCacheItemDto(
                id: e.id,
                name: e.name,
                kind: e.kind,
              ),
            )
            .toList(),
      );
      final now = DateTime.now().millisecondsSinceEpoch;
      final json = jsonEncode(dto.toJson());
      await _db.into(_db.facultiesCache).insertOnConflictUpdate(
        FacultiesCacheCompanion(
          id: const Value(_facultiesSingletonId),
          updatedAtMs: Value(now),
          itemsJson: Value(json),
        ),
      );
      return const Right(unit);
    } on Object catch (e) {
      return Left(
        AppFailure(
          message: 'Запись кэша факультетов: $e',
          kind: AppFailureKind.storage,
        ),
      );
    }
  }

  @override
  Future<Either<AppFailure, int?>> readFacultiesUpdatedAtMs() async {
    try {
      final row =
          await (_db.select(_db.facultiesCache)
                ..where((t) => t.id.equals(_facultiesSingletonId)))
              .getSingleOrNull();
      return Right(row?.updatedAtMs);
    } on Object catch (e) {
      return Left(
        AppFailure(
          message: 'Кэш факультетов (время): $e',
          kind: AppFailureKind.storage,
        ),
      );
    }
  }

  @override
  Future<Either<AppFailure, List<StudyForm>>> getStudyForms(
    String facultyId,
  ) async {
    try {
      final row =
          await (_db.select(_db.studyFormsCache)
                ..where((t) => t.facultyId.equals(facultyId)))
              .getSingleOrNull();
      if (row == null) {
        return const Right(<StudyForm>[]);
      }
      final payload = StudyFormsCachePayloadDto.fromJson(
        jsonDecode(row.itemsJson) as Map<String, dynamic>,
      );
      return Right(
        payload.items
            .map(
              (e) => StudyForm(
                id: e.id,
                name: e.name,
              ),
            )
            .toList(),
      );
    } on Object catch (e) {
      return Left(
        AppFailure(
          message: 'Кэш форм: $e',
          kind: AppFailureKind.storage,
        ),
      );
    }
  }

  @override
  Future<Either<AppFailure, Unit>> saveStudyForms(
    String facultyId,
    List<StudyForm> items,
  ) async {
    try {
      final dto = StudyFormsCachePayloadDto(
        items: items
            .map(
              (e) => StudyFormCacheItemDto(
                id: e.id,
                name: e.name,
              ),
            )
            .toList(),
      );
      final now = DateTime.now().millisecondsSinceEpoch;
      final json = jsonEncode(dto.toJson());
      await _db.into(_db.studyFormsCache).insertOnConflictUpdate(
        StudyFormsCacheCompanion(
          facultyId: Value(facultyId),
          updatedAtMs: Value(now),
          itemsJson: Value(json),
        ),
      );
      return const Right(unit);
    } on Object catch (e) {
      return Left(
        AppFailure(
          message: 'Запись кэша форм: $e',
          kind: AppFailureKind.storage,
        ),
      );
    }
  }

  @override
  Future<Either<AppFailure, List<ScheduleGroup>>> getGroups(
    String facultyId,
    String formId,
  ) async {
    try {
      final row =
          await (_db.select(_db.groupsCache)
                ..where(
                  (t) =>
                      t.facultyId.equals(facultyId) & t.formId.equals(formId),
                ))
              .getSingleOrNull();
      if (row == null) {
        return const Right(<ScheduleGroup>[]);
      }
      final payload = GroupsCachePayloadDto.fromJson(
        jsonDecode(row.itemsJson) as Map<String, dynamic>,
      );
      return Right(
        payload.items
            .map(
              (e) => ScheduleGroup(
                id: e.id,
                name: e.name,
                schedulePath: e.schedulePath,
              ),
            )
            .toList(),
      );
    } on Object catch (e) {
      return Left(
        AppFailure(
          message: 'Кэш групп: $e',
          kind: AppFailureKind.storage,
        ),
      );
    }
  }

  @override
  Future<Either<AppFailure, Unit>> saveGroups(
    String facultyId,
    String formId,
    List<ScheduleGroup> items,
  ) async {
    try {
      final dto = GroupsCachePayloadDto(
        items: items
            .map(
              (e) => GroupCacheItemDto(
                id: e.id,
                name: e.name,
                schedulePath: e.schedulePath,
              ),
            )
            .toList(),
      );
      final now = DateTime.now().millisecondsSinceEpoch;
      final json = jsonEncode(dto.toJson());
      await _db.into(_db.groupsCache).insertOnConflictUpdate(
        GroupsCacheCompanion(
          facultyId: Value(facultyId),
          formId: Value(formId),
          updatedAtMs: Value(now),
          itemsJson: Value(json),
        ),
      );
      return const Right(unit);
    } on Object catch (e) {
      return Left(
        AppFailure(
          message: 'Запись кэша групп: $e',
          kind: AppFailureKind.storage,
        ),
      );
    }
  }
}
