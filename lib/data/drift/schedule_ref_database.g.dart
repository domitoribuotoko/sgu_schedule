// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_ref_database.dart';

// ignore_for_file: type=lint
class $FacultiesCacheTable extends FacultiesCache
    with TableInfo<$FacultiesCacheTable, FacultiesCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FacultiesCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _updatedAtMsMeta = const VerificationMeta(
    'updatedAtMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtMs = GeneratedColumn<int>(
    'updated_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemsJsonMeta = const VerificationMeta(
    'itemsJson',
  );
  @override
  late final GeneratedColumn<String> itemsJson = GeneratedColumn<String>(
    'items_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, updatedAtMs, itemsJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'faculties_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<FacultiesCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('updated_at_ms')) {
      context.handle(
        _updatedAtMsMeta,
        updatedAtMs.isAcceptableOrUnknown(
          data['updated_at_ms']!,
          _updatedAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMsMeta);
    }
    if (data.containsKey('items_json')) {
      context.handle(
        _itemsJsonMeta,
        itemsJson.isAcceptableOrUnknown(data['items_json']!, _itemsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_itemsJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FacultiesCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FacultiesCacheData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      updatedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_ms'],
      )!,
      itemsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}items_json'],
      )!,
    );
  }

  @override
  $FacultiesCacheTable createAlias(String alias) {
    return $FacultiesCacheTable(attachedDatabase, alias);
  }
}

class FacultiesCacheData extends DataClass
    implements Insertable<FacultiesCacheData> {
  final int id;
  final int updatedAtMs;
  final String itemsJson;
  const FacultiesCacheData({
    required this.id,
    required this.updatedAtMs,
    required this.itemsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['updated_at_ms'] = Variable<int>(updatedAtMs);
    map['items_json'] = Variable<String>(itemsJson);
    return map;
  }

  FacultiesCacheCompanion toCompanion(bool nullToAbsent) {
    return FacultiesCacheCompanion(
      id: Value(id),
      updatedAtMs: Value(updatedAtMs),
      itemsJson: Value(itemsJson),
    );
  }

  factory FacultiesCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FacultiesCacheData(
      id: serializer.fromJson<int>(json['id']),
      updatedAtMs: serializer.fromJson<int>(json['updatedAtMs']),
      itemsJson: serializer.fromJson<String>(json['itemsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'updatedAtMs': serializer.toJson<int>(updatedAtMs),
      'itemsJson': serializer.toJson<String>(itemsJson),
    };
  }

  FacultiesCacheData copyWith({int? id, int? updatedAtMs, String? itemsJson}) =>
      FacultiesCacheData(
        id: id ?? this.id,
        updatedAtMs: updatedAtMs ?? this.updatedAtMs,
        itemsJson: itemsJson ?? this.itemsJson,
      );
  FacultiesCacheData copyWithCompanion(FacultiesCacheCompanion data) {
    return FacultiesCacheData(
      id: data.id.present ? data.id.value : this.id,
      updatedAtMs: data.updatedAtMs.present
          ? data.updatedAtMs.value
          : this.updatedAtMs,
      itemsJson: data.itemsJson.present ? data.itemsJson.value : this.itemsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FacultiesCacheData(')
          ..write('id: $id, ')
          ..write('updatedAtMs: $updatedAtMs, ')
          ..write('itemsJson: $itemsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, updatedAtMs, itemsJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FacultiesCacheData &&
          other.id == this.id &&
          other.updatedAtMs == this.updatedAtMs &&
          other.itemsJson == this.itemsJson);
}

class FacultiesCacheCompanion extends UpdateCompanion<FacultiesCacheData> {
  final Value<int> id;
  final Value<int> updatedAtMs;
  final Value<String> itemsJson;
  const FacultiesCacheCompanion({
    this.id = const Value.absent(),
    this.updatedAtMs = const Value.absent(),
    this.itemsJson = const Value.absent(),
  });
  FacultiesCacheCompanion.insert({
    this.id = const Value.absent(),
    required int updatedAtMs,
    required String itemsJson,
  }) : updatedAtMs = Value(updatedAtMs),
       itemsJson = Value(itemsJson);
  static Insertable<FacultiesCacheData> custom({
    Expression<int>? id,
    Expression<int>? updatedAtMs,
    Expression<String>? itemsJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAtMs != null) 'updated_at_ms': updatedAtMs,
      if (itemsJson != null) 'items_json': itemsJson,
    });
  }

  FacultiesCacheCompanion copyWith({
    Value<int>? id,
    Value<int>? updatedAtMs,
    Value<String>? itemsJson,
  }) {
    return FacultiesCacheCompanion(
      id: id ?? this.id,
      updatedAtMs: updatedAtMs ?? this.updatedAtMs,
      itemsJson: itemsJson ?? this.itemsJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (updatedAtMs.present) {
      map['updated_at_ms'] = Variable<int>(updatedAtMs.value);
    }
    if (itemsJson.present) {
      map['items_json'] = Variable<String>(itemsJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FacultiesCacheCompanion(')
          ..write('id: $id, ')
          ..write('updatedAtMs: $updatedAtMs, ')
          ..write('itemsJson: $itemsJson')
          ..write(')'))
        .toString();
  }
}

class $StudyFormsCacheTable extends StudyFormsCache
    with TableInfo<$StudyFormsCacheTable, StudyFormsCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudyFormsCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _facultyIdMeta = const VerificationMeta(
    'facultyId',
  );
  @override
  late final GeneratedColumn<String> facultyId = GeneratedColumn<String>(
    'faculty_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMsMeta = const VerificationMeta(
    'updatedAtMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtMs = GeneratedColumn<int>(
    'updated_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemsJsonMeta = const VerificationMeta(
    'itemsJson',
  );
  @override
  late final GeneratedColumn<String> itemsJson = GeneratedColumn<String>(
    'items_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [facultyId, updatedAtMs, itemsJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_forms_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudyFormsCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('faculty_id')) {
      context.handle(
        _facultyIdMeta,
        facultyId.isAcceptableOrUnknown(data['faculty_id']!, _facultyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_facultyIdMeta);
    }
    if (data.containsKey('updated_at_ms')) {
      context.handle(
        _updatedAtMsMeta,
        updatedAtMs.isAcceptableOrUnknown(
          data['updated_at_ms']!,
          _updatedAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMsMeta);
    }
    if (data.containsKey('items_json')) {
      context.handle(
        _itemsJsonMeta,
        itemsJson.isAcceptableOrUnknown(data['items_json']!, _itemsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_itemsJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {facultyId};
  @override
  StudyFormsCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudyFormsCacheData(
      facultyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}faculty_id'],
      )!,
      updatedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_ms'],
      )!,
      itemsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}items_json'],
      )!,
    );
  }

  @override
  $StudyFormsCacheTable createAlias(String alias) {
    return $StudyFormsCacheTable(attachedDatabase, alias);
  }
}

class StudyFormsCacheData extends DataClass
    implements Insertable<StudyFormsCacheData> {
  final String facultyId;
  final int updatedAtMs;
  final String itemsJson;
  const StudyFormsCacheData({
    required this.facultyId,
    required this.updatedAtMs,
    required this.itemsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['faculty_id'] = Variable<String>(facultyId);
    map['updated_at_ms'] = Variable<int>(updatedAtMs);
    map['items_json'] = Variable<String>(itemsJson);
    return map;
  }

  StudyFormsCacheCompanion toCompanion(bool nullToAbsent) {
    return StudyFormsCacheCompanion(
      facultyId: Value(facultyId),
      updatedAtMs: Value(updatedAtMs),
      itemsJson: Value(itemsJson),
    );
  }

  factory StudyFormsCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudyFormsCacheData(
      facultyId: serializer.fromJson<String>(json['facultyId']),
      updatedAtMs: serializer.fromJson<int>(json['updatedAtMs']),
      itemsJson: serializer.fromJson<String>(json['itemsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'facultyId': serializer.toJson<String>(facultyId),
      'updatedAtMs': serializer.toJson<int>(updatedAtMs),
      'itemsJson': serializer.toJson<String>(itemsJson),
    };
  }

  StudyFormsCacheData copyWith({
    String? facultyId,
    int? updatedAtMs,
    String? itemsJson,
  }) => StudyFormsCacheData(
    facultyId: facultyId ?? this.facultyId,
    updatedAtMs: updatedAtMs ?? this.updatedAtMs,
    itemsJson: itemsJson ?? this.itemsJson,
  );
  StudyFormsCacheData copyWithCompanion(StudyFormsCacheCompanion data) {
    return StudyFormsCacheData(
      facultyId: data.facultyId.present ? data.facultyId.value : this.facultyId,
      updatedAtMs: data.updatedAtMs.present
          ? data.updatedAtMs.value
          : this.updatedAtMs,
      itemsJson: data.itemsJson.present ? data.itemsJson.value : this.itemsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudyFormsCacheData(')
          ..write('facultyId: $facultyId, ')
          ..write('updatedAtMs: $updatedAtMs, ')
          ..write('itemsJson: $itemsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(facultyId, updatedAtMs, itemsJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudyFormsCacheData &&
          other.facultyId == this.facultyId &&
          other.updatedAtMs == this.updatedAtMs &&
          other.itemsJson == this.itemsJson);
}

class StudyFormsCacheCompanion extends UpdateCompanion<StudyFormsCacheData> {
  final Value<String> facultyId;
  final Value<int> updatedAtMs;
  final Value<String> itemsJson;
  final Value<int> rowid;
  const StudyFormsCacheCompanion({
    this.facultyId = const Value.absent(),
    this.updatedAtMs = const Value.absent(),
    this.itemsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudyFormsCacheCompanion.insert({
    required String facultyId,
    required int updatedAtMs,
    required String itemsJson,
    this.rowid = const Value.absent(),
  }) : facultyId = Value(facultyId),
       updatedAtMs = Value(updatedAtMs),
       itemsJson = Value(itemsJson);
  static Insertable<StudyFormsCacheData> custom({
    Expression<String>? facultyId,
    Expression<int>? updatedAtMs,
    Expression<String>? itemsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (facultyId != null) 'faculty_id': facultyId,
      if (updatedAtMs != null) 'updated_at_ms': updatedAtMs,
      if (itemsJson != null) 'items_json': itemsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudyFormsCacheCompanion copyWith({
    Value<String>? facultyId,
    Value<int>? updatedAtMs,
    Value<String>? itemsJson,
    Value<int>? rowid,
  }) {
    return StudyFormsCacheCompanion(
      facultyId: facultyId ?? this.facultyId,
      updatedAtMs: updatedAtMs ?? this.updatedAtMs,
      itemsJson: itemsJson ?? this.itemsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (facultyId.present) {
      map['faculty_id'] = Variable<String>(facultyId.value);
    }
    if (updatedAtMs.present) {
      map['updated_at_ms'] = Variable<int>(updatedAtMs.value);
    }
    if (itemsJson.present) {
      map['items_json'] = Variable<String>(itemsJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudyFormsCacheCompanion(')
          ..write('facultyId: $facultyId, ')
          ..write('updatedAtMs: $updatedAtMs, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GroupsCacheTable extends GroupsCache
    with TableInfo<$GroupsCacheTable, GroupsCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupsCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _facultyIdMeta = const VerificationMeta(
    'facultyId',
  );
  @override
  late final GeneratedColumn<String> facultyId = GeneratedColumn<String>(
    'faculty_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formIdMeta = const VerificationMeta('formId');
  @override
  late final GeneratedColumn<String> formId = GeneratedColumn<String>(
    'form_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMsMeta = const VerificationMeta(
    'updatedAtMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtMs = GeneratedColumn<int>(
    'updated_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemsJsonMeta = const VerificationMeta(
    'itemsJson',
  );
  @override
  late final GeneratedColumn<String> itemsJson = GeneratedColumn<String>(
    'items_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    facultyId,
    formId,
    updatedAtMs,
    itemsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'groups_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<GroupsCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('faculty_id')) {
      context.handle(
        _facultyIdMeta,
        facultyId.isAcceptableOrUnknown(data['faculty_id']!, _facultyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_facultyIdMeta);
    }
    if (data.containsKey('form_id')) {
      context.handle(
        _formIdMeta,
        formId.isAcceptableOrUnknown(data['form_id']!, _formIdMeta),
      );
    } else if (isInserting) {
      context.missing(_formIdMeta);
    }
    if (data.containsKey('updated_at_ms')) {
      context.handle(
        _updatedAtMsMeta,
        updatedAtMs.isAcceptableOrUnknown(
          data['updated_at_ms']!,
          _updatedAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMsMeta);
    }
    if (data.containsKey('items_json')) {
      context.handle(
        _itemsJsonMeta,
        itemsJson.isAcceptableOrUnknown(data['items_json']!, _itemsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_itemsJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {facultyId, formId};
  @override
  GroupsCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupsCacheData(
      facultyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}faculty_id'],
      )!,
      formId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}form_id'],
      )!,
      updatedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_ms'],
      )!,
      itemsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}items_json'],
      )!,
    );
  }

  @override
  $GroupsCacheTable createAlias(String alias) {
    return $GroupsCacheTable(attachedDatabase, alias);
  }
}

class GroupsCacheData extends DataClass implements Insertable<GroupsCacheData> {
  final String facultyId;
  final String formId;
  final int updatedAtMs;
  final String itemsJson;
  const GroupsCacheData({
    required this.facultyId,
    required this.formId,
    required this.updatedAtMs,
    required this.itemsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['faculty_id'] = Variable<String>(facultyId);
    map['form_id'] = Variable<String>(formId);
    map['updated_at_ms'] = Variable<int>(updatedAtMs);
    map['items_json'] = Variable<String>(itemsJson);
    return map;
  }

  GroupsCacheCompanion toCompanion(bool nullToAbsent) {
    return GroupsCacheCompanion(
      facultyId: Value(facultyId),
      formId: Value(formId),
      updatedAtMs: Value(updatedAtMs),
      itemsJson: Value(itemsJson),
    );
  }

  factory GroupsCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupsCacheData(
      facultyId: serializer.fromJson<String>(json['facultyId']),
      formId: serializer.fromJson<String>(json['formId']),
      updatedAtMs: serializer.fromJson<int>(json['updatedAtMs']),
      itemsJson: serializer.fromJson<String>(json['itemsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'facultyId': serializer.toJson<String>(facultyId),
      'formId': serializer.toJson<String>(formId),
      'updatedAtMs': serializer.toJson<int>(updatedAtMs),
      'itemsJson': serializer.toJson<String>(itemsJson),
    };
  }

  GroupsCacheData copyWith({
    String? facultyId,
    String? formId,
    int? updatedAtMs,
    String? itemsJson,
  }) => GroupsCacheData(
    facultyId: facultyId ?? this.facultyId,
    formId: formId ?? this.formId,
    updatedAtMs: updatedAtMs ?? this.updatedAtMs,
    itemsJson: itemsJson ?? this.itemsJson,
  );
  GroupsCacheData copyWithCompanion(GroupsCacheCompanion data) {
    return GroupsCacheData(
      facultyId: data.facultyId.present ? data.facultyId.value : this.facultyId,
      formId: data.formId.present ? data.formId.value : this.formId,
      updatedAtMs: data.updatedAtMs.present
          ? data.updatedAtMs.value
          : this.updatedAtMs,
      itemsJson: data.itemsJson.present ? data.itemsJson.value : this.itemsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupsCacheData(')
          ..write('facultyId: $facultyId, ')
          ..write('formId: $formId, ')
          ..write('updatedAtMs: $updatedAtMs, ')
          ..write('itemsJson: $itemsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(facultyId, formId, updatedAtMs, itemsJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupsCacheData &&
          other.facultyId == this.facultyId &&
          other.formId == this.formId &&
          other.updatedAtMs == this.updatedAtMs &&
          other.itemsJson == this.itemsJson);
}

class GroupsCacheCompanion extends UpdateCompanion<GroupsCacheData> {
  final Value<String> facultyId;
  final Value<String> formId;
  final Value<int> updatedAtMs;
  final Value<String> itemsJson;
  final Value<int> rowid;
  const GroupsCacheCompanion({
    this.facultyId = const Value.absent(),
    this.formId = const Value.absent(),
    this.updatedAtMs = const Value.absent(),
    this.itemsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupsCacheCompanion.insert({
    required String facultyId,
    required String formId,
    required int updatedAtMs,
    required String itemsJson,
    this.rowid = const Value.absent(),
  }) : facultyId = Value(facultyId),
       formId = Value(formId),
       updatedAtMs = Value(updatedAtMs),
       itemsJson = Value(itemsJson);
  static Insertable<GroupsCacheData> custom({
    Expression<String>? facultyId,
    Expression<String>? formId,
    Expression<int>? updatedAtMs,
    Expression<String>? itemsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (facultyId != null) 'faculty_id': facultyId,
      if (formId != null) 'form_id': formId,
      if (updatedAtMs != null) 'updated_at_ms': updatedAtMs,
      if (itemsJson != null) 'items_json': itemsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupsCacheCompanion copyWith({
    Value<String>? facultyId,
    Value<String>? formId,
    Value<int>? updatedAtMs,
    Value<String>? itemsJson,
    Value<int>? rowid,
  }) {
    return GroupsCacheCompanion(
      facultyId: facultyId ?? this.facultyId,
      formId: formId ?? this.formId,
      updatedAtMs: updatedAtMs ?? this.updatedAtMs,
      itemsJson: itemsJson ?? this.itemsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (facultyId.present) {
      map['faculty_id'] = Variable<String>(facultyId.value);
    }
    if (formId.present) {
      map['form_id'] = Variable<String>(formId.value);
    }
    if (updatedAtMs.present) {
      map['updated_at_ms'] = Variable<int>(updatedAtMs.value);
    }
    if (itemsJson.present) {
      map['items_json'] = Variable<String>(itemsJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupsCacheCompanion(')
          ..write('facultyId: $facultyId, ')
          ..write('formId: $formId, ')
          ..write('updatedAtMs: $updatedAtMs, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScheduleTimetableCacheTable extends ScheduleTimetableCache
    with TableInfo<$ScheduleTimetableCacheTable, ScheduleTimetableCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduleTimetableCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _schedulePathMeta = const VerificationMeta(
    'schedulePath',
  );
  @override
  late final GeneratedColumn<String> schedulePath = GeneratedColumn<String>(
    'schedule_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _viewKeyMeta = const VerificationMeta(
    'viewKey',
  );
  @override
  late final GeneratedColumn<String> viewKey = GeneratedColumn<String>(
    'view_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fetchedAtMsMeta = const VerificationMeta(
    'fetchedAtMs',
  );
  @override
  late final GeneratedColumn<int> fetchedAtMs = GeneratedColumn<int>(
    'fetched_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _validUntilMsMeta = const VerificationMeta(
    'validUntilMs',
  );
  @override
  late final GeneratedColumn<int> validUntilMs = GeneratedColumn<int>(
    'valid_until_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyJsonMeta = const VerificationMeta(
    'bodyJson',
  );
  @override
  late final GeneratedColumn<String> bodyJson = GeneratedColumn<String>(
    'body_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    schedulePath,
    viewKey,
    fetchedAtMs,
    validUntilMs,
    bodyJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schedule_timetable_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScheduleTimetableCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('schedule_path')) {
      context.handle(
        _schedulePathMeta,
        schedulePath.isAcceptableOrUnknown(
          data['schedule_path']!,
          _schedulePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_schedulePathMeta);
    }
    if (data.containsKey('view_key')) {
      context.handle(
        _viewKeyMeta,
        viewKey.isAcceptableOrUnknown(data['view_key']!, _viewKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_viewKeyMeta);
    }
    if (data.containsKey('fetched_at_ms')) {
      context.handle(
        _fetchedAtMsMeta,
        fetchedAtMs.isAcceptableOrUnknown(
          data['fetched_at_ms']!,
          _fetchedAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMsMeta);
    }
    if (data.containsKey('valid_until_ms')) {
      context.handle(
        _validUntilMsMeta,
        validUntilMs.isAcceptableOrUnknown(
          data['valid_until_ms']!,
          _validUntilMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_validUntilMsMeta);
    }
    if (data.containsKey('body_json')) {
      context.handle(
        _bodyJsonMeta,
        bodyJson.isAcceptableOrUnknown(data['body_json']!, _bodyJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {schedulePath, viewKey};
  @override
  ScheduleTimetableCacheData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduleTimetableCacheData(
      schedulePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schedule_path'],
      )!,
      viewKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}view_key'],
      )!,
      fetchedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fetched_at_ms'],
      )!,
      validUntilMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}valid_until_ms'],
      )!,
      bodyJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body_json'],
      )!,
    );
  }

  @override
  $ScheduleTimetableCacheTable createAlias(String alias) {
    return $ScheduleTimetableCacheTable(attachedDatabase, alias);
  }
}

class ScheduleTimetableCacheData extends DataClass
    implements Insertable<ScheduleTimetableCacheData> {
  final String schedulePath;

  /// `all` | `lection` | `session` — согласно [ScheduleSelectionSnapshot.viewKey].
  final String viewKey;
  final int fetchedAtMs;
  final int validUntilMs;
  final String bodyJson;
  const ScheduleTimetableCacheData({
    required this.schedulePath,
    required this.viewKey,
    required this.fetchedAtMs,
    required this.validUntilMs,
    required this.bodyJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['schedule_path'] = Variable<String>(schedulePath);
    map['view_key'] = Variable<String>(viewKey);
    map['fetched_at_ms'] = Variable<int>(fetchedAtMs);
    map['valid_until_ms'] = Variable<int>(validUntilMs);
    map['body_json'] = Variable<String>(bodyJson);
    return map;
  }

  ScheduleTimetableCacheCompanion toCompanion(bool nullToAbsent) {
    return ScheduleTimetableCacheCompanion(
      schedulePath: Value(schedulePath),
      viewKey: Value(viewKey),
      fetchedAtMs: Value(fetchedAtMs),
      validUntilMs: Value(validUntilMs),
      bodyJson: Value(bodyJson),
    );
  }

  factory ScheduleTimetableCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduleTimetableCacheData(
      schedulePath: serializer.fromJson<String>(json['schedulePath']),
      viewKey: serializer.fromJson<String>(json['viewKey']),
      fetchedAtMs: serializer.fromJson<int>(json['fetchedAtMs']),
      validUntilMs: serializer.fromJson<int>(json['validUntilMs']),
      bodyJson: serializer.fromJson<String>(json['bodyJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'schedulePath': serializer.toJson<String>(schedulePath),
      'viewKey': serializer.toJson<String>(viewKey),
      'fetchedAtMs': serializer.toJson<int>(fetchedAtMs),
      'validUntilMs': serializer.toJson<int>(validUntilMs),
      'bodyJson': serializer.toJson<String>(bodyJson),
    };
  }

  ScheduleTimetableCacheData copyWith({
    String? schedulePath,
    String? viewKey,
    int? fetchedAtMs,
    int? validUntilMs,
    String? bodyJson,
  }) => ScheduleTimetableCacheData(
    schedulePath: schedulePath ?? this.schedulePath,
    viewKey: viewKey ?? this.viewKey,
    fetchedAtMs: fetchedAtMs ?? this.fetchedAtMs,
    validUntilMs: validUntilMs ?? this.validUntilMs,
    bodyJson: bodyJson ?? this.bodyJson,
  );
  ScheduleTimetableCacheData copyWithCompanion(
    ScheduleTimetableCacheCompanion data,
  ) {
    return ScheduleTimetableCacheData(
      schedulePath: data.schedulePath.present
          ? data.schedulePath.value
          : this.schedulePath,
      viewKey: data.viewKey.present ? data.viewKey.value : this.viewKey,
      fetchedAtMs: data.fetchedAtMs.present
          ? data.fetchedAtMs.value
          : this.fetchedAtMs,
      validUntilMs: data.validUntilMs.present
          ? data.validUntilMs.value
          : this.validUntilMs,
      bodyJson: data.bodyJson.present ? data.bodyJson.value : this.bodyJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleTimetableCacheData(')
          ..write('schedulePath: $schedulePath, ')
          ..write('viewKey: $viewKey, ')
          ..write('fetchedAtMs: $fetchedAtMs, ')
          ..write('validUntilMs: $validUntilMs, ')
          ..write('bodyJson: $bodyJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(schedulePath, viewKey, fetchedAtMs, validUntilMs, bodyJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduleTimetableCacheData &&
          other.schedulePath == this.schedulePath &&
          other.viewKey == this.viewKey &&
          other.fetchedAtMs == this.fetchedAtMs &&
          other.validUntilMs == this.validUntilMs &&
          other.bodyJson == this.bodyJson);
}

class ScheduleTimetableCacheCompanion
    extends UpdateCompanion<ScheduleTimetableCacheData> {
  final Value<String> schedulePath;
  final Value<String> viewKey;
  final Value<int> fetchedAtMs;
  final Value<int> validUntilMs;
  final Value<String> bodyJson;
  final Value<int> rowid;
  const ScheduleTimetableCacheCompanion({
    this.schedulePath = const Value.absent(),
    this.viewKey = const Value.absent(),
    this.fetchedAtMs = const Value.absent(),
    this.validUntilMs = const Value.absent(),
    this.bodyJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScheduleTimetableCacheCompanion.insert({
    required String schedulePath,
    required String viewKey,
    required int fetchedAtMs,
    required int validUntilMs,
    required String bodyJson,
    this.rowid = const Value.absent(),
  }) : schedulePath = Value(schedulePath),
       viewKey = Value(viewKey),
       fetchedAtMs = Value(fetchedAtMs),
       validUntilMs = Value(validUntilMs),
       bodyJson = Value(bodyJson);
  static Insertable<ScheduleTimetableCacheData> custom({
    Expression<String>? schedulePath,
    Expression<String>? viewKey,
    Expression<int>? fetchedAtMs,
    Expression<int>? validUntilMs,
    Expression<String>? bodyJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (schedulePath != null) 'schedule_path': schedulePath,
      if (viewKey != null) 'view_key': viewKey,
      if (fetchedAtMs != null) 'fetched_at_ms': fetchedAtMs,
      if (validUntilMs != null) 'valid_until_ms': validUntilMs,
      if (bodyJson != null) 'body_json': bodyJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScheduleTimetableCacheCompanion copyWith({
    Value<String>? schedulePath,
    Value<String>? viewKey,
    Value<int>? fetchedAtMs,
    Value<int>? validUntilMs,
    Value<String>? bodyJson,
    Value<int>? rowid,
  }) {
    return ScheduleTimetableCacheCompanion(
      schedulePath: schedulePath ?? this.schedulePath,
      viewKey: viewKey ?? this.viewKey,
      fetchedAtMs: fetchedAtMs ?? this.fetchedAtMs,
      validUntilMs: validUntilMs ?? this.validUntilMs,
      bodyJson: bodyJson ?? this.bodyJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (schedulePath.present) {
      map['schedule_path'] = Variable<String>(schedulePath.value);
    }
    if (viewKey.present) {
      map['view_key'] = Variable<String>(viewKey.value);
    }
    if (fetchedAtMs.present) {
      map['fetched_at_ms'] = Variable<int>(fetchedAtMs.value);
    }
    if (validUntilMs.present) {
      map['valid_until_ms'] = Variable<int>(validUntilMs.value);
    }
    if (bodyJson.present) {
      map['body_json'] = Variable<String>(bodyJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleTimetableCacheCompanion(')
          ..write('schedulePath: $schedulePath, ')
          ..write('viewKey: $viewKey, ')
          ..write('fetchedAtMs: $fetchedAtMs, ')
          ..write('validUntilMs: $validUntilMs, ')
          ..write('bodyJson: $bodyJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$ScheduleRefDatabase extends GeneratedDatabase {
  _$ScheduleRefDatabase(QueryExecutor e) : super(e);
  $ScheduleRefDatabaseManager get managers => $ScheduleRefDatabaseManager(this);
  late final $FacultiesCacheTable facultiesCache = $FacultiesCacheTable(this);
  late final $StudyFormsCacheTable studyFormsCache = $StudyFormsCacheTable(
    this,
  );
  late final $GroupsCacheTable groupsCache = $GroupsCacheTable(this);
  late final $ScheduleTimetableCacheTable scheduleTimetableCache =
      $ScheduleTimetableCacheTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    facultiesCache,
    studyFormsCache,
    groupsCache,
    scheduleTimetableCache,
  ];
}

typedef $$FacultiesCacheTableCreateCompanionBuilder =
    FacultiesCacheCompanion Function({
      Value<int> id,
      required int updatedAtMs,
      required String itemsJson,
    });
typedef $$FacultiesCacheTableUpdateCompanionBuilder =
    FacultiesCacheCompanion Function({
      Value<int> id,
      Value<int> updatedAtMs,
      Value<String> itemsJson,
    });

class $$FacultiesCacheTableFilterComposer
    extends Composer<_$ScheduleRefDatabase, $FacultiesCacheTable> {
  $$FacultiesCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemsJson => $composableBuilder(
    column: $table.itemsJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FacultiesCacheTableOrderingComposer
    extends Composer<_$ScheduleRefDatabase, $FacultiesCacheTable> {
  $$FacultiesCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemsJson => $composableBuilder(
    column: $table.itemsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FacultiesCacheTableAnnotationComposer
    extends Composer<_$ScheduleRefDatabase, $FacultiesCacheTable> {
  $$FacultiesCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get itemsJson =>
      $composableBuilder(column: $table.itemsJson, builder: (column) => column);
}

class $$FacultiesCacheTableTableManager
    extends
        RootTableManager<
          _$ScheduleRefDatabase,
          $FacultiesCacheTable,
          FacultiesCacheData,
          $$FacultiesCacheTableFilterComposer,
          $$FacultiesCacheTableOrderingComposer,
          $$FacultiesCacheTableAnnotationComposer,
          $$FacultiesCacheTableCreateCompanionBuilder,
          $$FacultiesCacheTableUpdateCompanionBuilder,
          (
            FacultiesCacheData,
            BaseReferences<
              _$ScheduleRefDatabase,
              $FacultiesCacheTable,
              FacultiesCacheData
            >,
          ),
          FacultiesCacheData,
          PrefetchHooks Function()
        > {
  $$FacultiesCacheTableTableManager(
    _$ScheduleRefDatabase db,
    $FacultiesCacheTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FacultiesCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FacultiesCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FacultiesCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> updatedAtMs = const Value.absent(),
                Value<String> itemsJson = const Value.absent(),
              }) => FacultiesCacheCompanion(
                id: id,
                updatedAtMs: updatedAtMs,
                itemsJson: itemsJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int updatedAtMs,
                required String itemsJson,
              }) => FacultiesCacheCompanion.insert(
                id: id,
                updatedAtMs: updatedAtMs,
                itemsJson: itemsJson,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FacultiesCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$ScheduleRefDatabase,
      $FacultiesCacheTable,
      FacultiesCacheData,
      $$FacultiesCacheTableFilterComposer,
      $$FacultiesCacheTableOrderingComposer,
      $$FacultiesCacheTableAnnotationComposer,
      $$FacultiesCacheTableCreateCompanionBuilder,
      $$FacultiesCacheTableUpdateCompanionBuilder,
      (
        FacultiesCacheData,
        BaseReferences<
          _$ScheduleRefDatabase,
          $FacultiesCacheTable,
          FacultiesCacheData
        >,
      ),
      FacultiesCacheData,
      PrefetchHooks Function()
    >;
typedef $$StudyFormsCacheTableCreateCompanionBuilder =
    StudyFormsCacheCompanion Function({
      required String facultyId,
      required int updatedAtMs,
      required String itemsJson,
      Value<int> rowid,
    });
typedef $$StudyFormsCacheTableUpdateCompanionBuilder =
    StudyFormsCacheCompanion Function({
      Value<String> facultyId,
      Value<int> updatedAtMs,
      Value<String> itemsJson,
      Value<int> rowid,
    });

class $$StudyFormsCacheTableFilterComposer
    extends Composer<_$ScheduleRefDatabase, $StudyFormsCacheTable> {
  $$StudyFormsCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get facultyId => $composableBuilder(
    column: $table.facultyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemsJson => $composableBuilder(
    column: $table.itemsJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StudyFormsCacheTableOrderingComposer
    extends Composer<_$ScheduleRefDatabase, $StudyFormsCacheTable> {
  $$StudyFormsCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get facultyId => $composableBuilder(
    column: $table.facultyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemsJson => $composableBuilder(
    column: $table.itemsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StudyFormsCacheTableAnnotationComposer
    extends Composer<_$ScheduleRefDatabase, $StudyFormsCacheTable> {
  $$StudyFormsCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get facultyId =>
      $composableBuilder(column: $table.facultyId, builder: (column) => column);

  GeneratedColumn<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get itemsJson =>
      $composableBuilder(column: $table.itemsJson, builder: (column) => column);
}

class $$StudyFormsCacheTableTableManager
    extends
        RootTableManager<
          _$ScheduleRefDatabase,
          $StudyFormsCacheTable,
          StudyFormsCacheData,
          $$StudyFormsCacheTableFilterComposer,
          $$StudyFormsCacheTableOrderingComposer,
          $$StudyFormsCacheTableAnnotationComposer,
          $$StudyFormsCacheTableCreateCompanionBuilder,
          $$StudyFormsCacheTableUpdateCompanionBuilder,
          (
            StudyFormsCacheData,
            BaseReferences<
              _$ScheduleRefDatabase,
              $StudyFormsCacheTable,
              StudyFormsCacheData
            >,
          ),
          StudyFormsCacheData,
          PrefetchHooks Function()
        > {
  $$StudyFormsCacheTableTableManager(
    _$ScheduleRefDatabase db,
    $StudyFormsCacheTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudyFormsCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudyFormsCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudyFormsCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> facultyId = const Value.absent(),
                Value<int> updatedAtMs = const Value.absent(),
                Value<String> itemsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyFormsCacheCompanion(
                facultyId: facultyId,
                updatedAtMs: updatedAtMs,
                itemsJson: itemsJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String facultyId,
                required int updatedAtMs,
                required String itemsJson,
                Value<int> rowid = const Value.absent(),
              }) => StudyFormsCacheCompanion.insert(
                facultyId: facultyId,
                updatedAtMs: updatedAtMs,
                itemsJson: itemsJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StudyFormsCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$ScheduleRefDatabase,
      $StudyFormsCacheTable,
      StudyFormsCacheData,
      $$StudyFormsCacheTableFilterComposer,
      $$StudyFormsCacheTableOrderingComposer,
      $$StudyFormsCacheTableAnnotationComposer,
      $$StudyFormsCacheTableCreateCompanionBuilder,
      $$StudyFormsCacheTableUpdateCompanionBuilder,
      (
        StudyFormsCacheData,
        BaseReferences<
          _$ScheduleRefDatabase,
          $StudyFormsCacheTable,
          StudyFormsCacheData
        >,
      ),
      StudyFormsCacheData,
      PrefetchHooks Function()
    >;
typedef $$GroupsCacheTableCreateCompanionBuilder =
    GroupsCacheCompanion Function({
      required String facultyId,
      required String formId,
      required int updatedAtMs,
      required String itemsJson,
      Value<int> rowid,
    });
typedef $$GroupsCacheTableUpdateCompanionBuilder =
    GroupsCacheCompanion Function({
      Value<String> facultyId,
      Value<String> formId,
      Value<int> updatedAtMs,
      Value<String> itemsJson,
      Value<int> rowid,
    });

class $$GroupsCacheTableFilterComposer
    extends Composer<_$ScheduleRefDatabase, $GroupsCacheTable> {
  $$GroupsCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get facultyId => $composableBuilder(
    column: $table.facultyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get formId => $composableBuilder(
    column: $table.formId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemsJson => $composableBuilder(
    column: $table.itemsJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GroupsCacheTableOrderingComposer
    extends Composer<_$ScheduleRefDatabase, $GroupsCacheTable> {
  $$GroupsCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get facultyId => $composableBuilder(
    column: $table.facultyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get formId => $composableBuilder(
    column: $table.formId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemsJson => $composableBuilder(
    column: $table.itemsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GroupsCacheTableAnnotationComposer
    extends Composer<_$ScheduleRefDatabase, $GroupsCacheTable> {
  $$GroupsCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get facultyId =>
      $composableBuilder(column: $table.facultyId, builder: (column) => column);

  GeneratedColumn<String> get formId =>
      $composableBuilder(column: $table.formId, builder: (column) => column);

  GeneratedColumn<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get itemsJson =>
      $composableBuilder(column: $table.itemsJson, builder: (column) => column);
}

class $$GroupsCacheTableTableManager
    extends
        RootTableManager<
          _$ScheduleRefDatabase,
          $GroupsCacheTable,
          GroupsCacheData,
          $$GroupsCacheTableFilterComposer,
          $$GroupsCacheTableOrderingComposer,
          $$GroupsCacheTableAnnotationComposer,
          $$GroupsCacheTableCreateCompanionBuilder,
          $$GroupsCacheTableUpdateCompanionBuilder,
          (
            GroupsCacheData,
            BaseReferences<
              _$ScheduleRefDatabase,
              $GroupsCacheTable,
              GroupsCacheData
            >,
          ),
          GroupsCacheData,
          PrefetchHooks Function()
        > {
  $$GroupsCacheTableTableManager(
    _$ScheduleRefDatabase db,
    $GroupsCacheTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupsCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupsCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupsCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> facultyId = const Value.absent(),
                Value<String> formId = const Value.absent(),
                Value<int> updatedAtMs = const Value.absent(),
                Value<String> itemsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupsCacheCompanion(
                facultyId: facultyId,
                formId: formId,
                updatedAtMs: updatedAtMs,
                itemsJson: itemsJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String facultyId,
                required String formId,
                required int updatedAtMs,
                required String itemsJson,
                Value<int> rowid = const Value.absent(),
              }) => GroupsCacheCompanion.insert(
                facultyId: facultyId,
                formId: formId,
                updatedAtMs: updatedAtMs,
                itemsJson: itemsJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GroupsCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$ScheduleRefDatabase,
      $GroupsCacheTable,
      GroupsCacheData,
      $$GroupsCacheTableFilterComposer,
      $$GroupsCacheTableOrderingComposer,
      $$GroupsCacheTableAnnotationComposer,
      $$GroupsCacheTableCreateCompanionBuilder,
      $$GroupsCacheTableUpdateCompanionBuilder,
      (
        GroupsCacheData,
        BaseReferences<
          _$ScheduleRefDatabase,
          $GroupsCacheTable,
          GroupsCacheData
        >,
      ),
      GroupsCacheData,
      PrefetchHooks Function()
    >;
typedef $$ScheduleTimetableCacheTableCreateCompanionBuilder =
    ScheduleTimetableCacheCompanion Function({
      required String schedulePath,
      required String viewKey,
      required int fetchedAtMs,
      required int validUntilMs,
      required String bodyJson,
      Value<int> rowid,
    });
typedef $$ScheduleTimetableCacheTableUpdateCompanionBuilder =
    ScheduleTimetableCacheCompanion Function({
      Value<String> schedulePath,
      Value<String> viewKey,
      Value<int> fetchedAtMs,
      Value<int> validUntilMs,
      Value<String> bodyJson,
      Value<int> rowid,
    });

class $$ScheduleTimetableCacheTableFilterComposer
    extends Composer<_$ScheduleRefDatabase, $ScheduleTimetableCacheTable> {
  $$ScheduleTimetableCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get schedulePath => $composableBuilder(
    column: $table.schedulePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get viewKey => $composableBuilder(
    column: $table.viewKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fetchedAtMs => $composableBuilder(
    column: $table.fetchedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get validUntilMs => $composableBuilder(
    column: $table.validUntilMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bodyJson => $composableBuilder(
    column: $table.bodyJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ScheduleTimetableCacheTableOrderingComposer
    extends Composer<_$ScheduleRefDatabase, $ScheduleTimetableCacheTable> {
  $$ScheduleTimetableCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get schedulePath => $composableBuilder(
    column: $table.schedulePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get viewKey => $composableBuilder(
    column: $table.viewKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fetchedAtMs => $composableBuilder(
    column: $table.fetchedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get validUntilMs => $composableBuilder(
    column: $table.validUntilMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bodyJson => $composableBuilder(
    column: $table.bodyJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ScheduleTimetableCacheTableAnnotationComposer
    extends Composer<_$ScheduleRefDatabase, $ScheduleTimetableCacheTable> {
  $$ScheduleTimetableCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get schedulePath => $composableBuilder(
    column: $table.schedulePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get viewKey =>
      $composableBuilder(column: $table.viewKey, builder: (column) => column);

  GeneratedColumn<int> get fetchedAtMs => $composableBuilder(
    column: $table.fetchedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get validUntilMs => $composableBuilder(
    column: $table.validUntilMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bodyJson =>
      $composableBuilder(column: $table.bodyJson, builder: (column) => column);
}

class $$ScheduleTimetableCacheTableTableManager
    extends
        RootTableManager<
          _$ScheduleRefDatabase,
          $ScheduleTimetableCacheTable,
          ScheduleTimetableCacheData,
          $$ScheduleTimetableCacheTableFilterComposer,
          $$ScheduleTimetableCacheTableOrderingComposer,
          $$ScheduleTimetableCacheTableAnnotationComposer,
          $$ScheduleTimetableCacheTableCreateCompanionBuilder,
          $$ScheduleTimetableCacheTableUpdateCompanionBuilder,
          (
            ScheduleTimetableCacheData,
            BaseReferences<
              _$ScheduleRefDatabase,
              $ScheduleTimetableCacheTable,
              ScheduleTimetableCacheData
            >,
          ),
          ScheduleTimetableCacheData,
          PrefetchHooks Function()
        > {
  $$ScheduleTimetableCacheTableTableManager(
    _$ScheduleRefDatabase db,
    $ScheduleTimetableCacheTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScheduleTimetableCacheTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ScheduleTimetableCacheTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ScheduleTimetableCacheTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> schedulePath = const Value.absent(),
                Value<String> viewKey = const Value.absent(),
                Value<int> fetchedAtMs = const Value.absent(),
                Value<int> validUntilMs = const Value.absent(),
                Value<String> bodyJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScheduleTimetableCacheCompanion(
                schedulePath: schedulePath,
                viewKey: viewKey,
                fetchedAtMs: fetchedAtMs,
                validUntilMs: validUntilMs,
                bodyJson: bodyJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String schedulePath,
                required String viewKey,
                required int fetchedAtMs,
                required int validUntilMs,
                required String bodyJson,
                Value<int> rowid = const Value.absent(),
              }) => ScheduleTimetableCacheCompanion.insert(
                schedulePath: schedulePath,
                viewKey: viewKey,
                fetchedAtMs: fetchedAtMs,
                validUntilMs: validUntilMs,
                bodyJson: bodyJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ScheduleTimetableCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$ScheduleRefDatabase,
      $ScheduleTimetableCacheTable,
      ScheduleTimetableCacheData,
      $$ScheduleTimetableCacheTableFilterComposer,
      $$ScheduleTimetableCacheTableOrderingComposer,
      $$ScheduleTimetableCacheTableAnnotationComposer,
      $$ScheduleTimetableCacheTableCreateCompanionBuilder,
      $$ScheduleTimetableCacheTableUpdateCompanionBuilder,
      (
        ScheduleTimetableCacheData,
        BaseReferences<
          _$ScheduleRefDatabase,
          $ScheduleTimetableCacheTable,
          ScheduleTimetableCacheData
        >,
      ),
      ScheduleTimetableCacheData,
      PrefetchHooks Function()
    >;

class $ScheduleRefDatabaseManager {
  final _$ScheduleRefDatabase _db;
  $ScheduleRefDatabaseManager(this._db);
  $$FacultiesCacheTableTableManager get facultiesCache =>
      $$FacultiesCacheTableTableManager(_db, _db.facultiesCache);
  $$StudyFormsCacheTableTableManager get studyFormsCache =>
      $$StudyFormsCacheTableTableManager(_db, _db.studyFormsCache);
  $$GroupsCacheTableTableManager get groupsCache =>
      $$GroupsCacheTableTableManager(_db, _db.groupsCache);
  $$ScheduleTimetableCacheTableTableManager get scheduleTimetableCache =>
      $$ScheduleTimetableCacheTableTableManager(
        _db,
        _db.scheduleTimetableCache,
      );
}
