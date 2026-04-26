import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sgu_schedule/domain/entities/schedule/schedule_selection_snapshot.dart';
import 'package:sgu_schedule/domain/repositories/schedule_path_repository.dart';

final class SchedulePathRepositoryImpl implements SchedulePathRepository {
  SchedulePathRepositoryImpl(this._prefs);

  static const String _keySnapshot = 'schedule_selection_v1';
  static const String _key = 'schedule_last_path';

  final SharedPreferences _prefs;

  static Future<SchedulePathRepositoryImpl> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SchedulePathRepositoryImpl(prefs);
  }

  Future<void> _migrateLegacyToSnapshotIfNeeded() async {
    if (_prefs.getString(_keySnapshot) != null) {
      return;
    }
    final leg = _prefs.getString(_key);
    if (leg == null || leg.isEmpty) {
      return;
    }
    final snap = ScheduleSelectionSnapshot.fromLegacyStoredPath(leg);
    if (snap.isEmpty) {
      return;
    }
    await _prefs.setString(
      _keySnapshot,
      json.encode(snap.toJson()),
    );
  }

  @override
  Future<String?> readSavedPath() async {
    await _migrateLegacyToSnapshotIfNeeded();
    final j = _prefs.getString(_keySnapshot);
    if (j != null) {
      final m = json.decode(j) as Map<String, dynamic>;
      final s = ScheduleSelectionSnapshot.fromJson(m);
      if (s != null && !s.isEmpty) {
        final p = s.fullStoragePath;
        if (p.isNotEmpty) {
          return p;
        }
      }
    }
    return _readLegacy();
  }

  String? _readLegacy() {
    final v = _prefs.getString(_key);
    if (v == null || v.isEmpty) {
      return null;
    }
    return v.startsWith('/') ? v : '/$v';
  }

  @override
  Future<ScheduleSelectionSnapshot?> readSelectionSnapshot() async {
    await _migrateLegacyToSnapshotIfNeeded();
    final j = _prefs.getString(_keySnapshot);
    if (j == null) {
      return null;
    }
    return ScheduleSelectionSnapshot.fromJson(
      json.decode(j) as Map<String, dynamic>,
    );
  }

  /// [path] может включать фрагмент, напр. `/schedule/.../421#session`.
  @override
  Future<void> savePath(String fullPath) async {
    var raw = fullPath.trim();
    if (raw.isEmpty) {
      return;
    }
    if (!raw.startsWith('/')) {
      raw = '/$raw';
    }
    var pathPart = raw;
    var frag = '';
    final hash = raw.indexOf('#');
    if (hash >= 0) {
      pathPart = raw.substring(0, hash);
      frag = raw.substring(hash + 1);
    }
    await _prefs.setString(
      _key,
      frag.isEmpty ? pathPart : '$pathPart#$frag',
    );
    final j = _prefs.getString(_keySnapshot);
    if (j != null) {
      final prev = ScheduleSelectionSnapshot.fromJson(
        json.decode(j) as Map<String, dynamic>,
      );
      if (prev == null) {
        return;
      }
      final next = prev.copyWith(path: pathPart, fragment: frag);
      await _prefs.setString(
        _keySnapshot,
        json.encode(next.toJson()),
      );
    }
  }

  @override
  Future<void> saveSelectionSnapshot(ScheduleSelectionSnapshot snapshot) async {
    if (snapshot.isEmpty) {
      return;
    }
    await _prefs.setString(_keySnapshot, json.encode(snapshot.toJson()));
    final rel = snapshot.fullStoragePath;
    await _prefs.setString(
      _key,
      rel.startsWith('/') ? rel : '/$rel',
    );
  }

  @override
  Future<void> clear() {
    return Future(() async {
      await _prefs.remove(_keySnapshot);
      await _prefs.remove(_key);
    });
  }
}
