import 'package:drift/drift.dart';

import 'package:sgu_schedule/data/drift/connection/drift_connection.dart';

part 'schedule_ref_database.g.dart';

/// Одна строка (id=1) — весь снимок списка факультетов в [itemsJson].
class FacultiesCache extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();

  IntColumn get updatedAtMs => integer()();

  TextColumn get itemsJson => text()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

/// Снимок форм обучения на факультет, ключ [facultyId].
class StudyFormsCache extends Table {
  TextColumn get facultyId => text()();

  IntColumn get updatedAtMs => integer()();

  TextColumn get itemsJson => text()();

  @override
  Set<Column<Object>>? get primaryKey => {facultyId};
}

/// Снимок групп, ключ (facultyId, formId).
class GroupsCache extends Table {
  TextColumn get facultyId => text()();

  TextColumn get formId => text()();

  IntColumn get updatedAtMs => integer()();

  TextColumn get itemsJson => text()();

  @override
  Set<Column<Object>>? get primaryKey => {facultyId, formId};
}

/// JSON расписания c бека, ключ (schedulePath, viewKey).
class ScheduleTimetableCache extends Table {
  TextColumn get schedulePath => text()();

  /// `all` | `lection` | `session` — согласно [ScheduleSelectionSnapshot.viewKey].
  TextColumn get viewKey => text()();

  IntColumn get fetchedAtMs => integer()();

  IntColumn get validUntilMs => integer()();

  TextColumn get bodyJson => text()();

  @override
  Set<Column<Object>>? get primaryKey => {schedulePath, viewKey};
}

@DriftDatabase(
  tables: [FacultiesCache, StudyFormsCache, GroupsCache, ScheduleTimetableCache],
)
class ScheduleRefDatabase extends _$ScheduleRefDatabase {
  ScheduleRefDatabase() : super(openDriftConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(scheduleTimetableCache);
      }
    },
  );
}
