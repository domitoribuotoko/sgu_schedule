import 'package:shared_preferences/shared_preferences.dart';
import 'package:sgu_schedule/domain/repositories/schedule_path_repository.dart';

final class SchedulePathRepositoryImpl implements SchedulePathRepository {
  SchedulePathRepositoryImpl(this._prefs);

  static const String _key = 'schedule_last_path';

  final SharedPreferences _prefs;

  static Future<SchedulePathRepositoryImpl> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SchedulePathRepositoryImpl(prefs);
  }

  @override
  Future<String?> readSavedPath() async {
    final v = _prefs.getString(_key);
    if (v == null || v.isEmpty) {
      return null;
    }
    return v.startsWith('/') ? v : '/$v';
  }

  @override
  Future<void> savePath(String path) {
    final normalized = path.startsWith('/') ? path : '/$path';
    return _prefs.setString(_key, normalized);
  }

  @override
  Future<void> clear() {
    return _prefs.remove(_key);
  }
}
