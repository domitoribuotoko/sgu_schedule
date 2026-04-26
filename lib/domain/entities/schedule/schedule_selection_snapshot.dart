import 'package:equatable/equatable.dart';

/// Снимок выбора (факультет / форма / группа + путь на сайт СГУ) для префа и веб-экрана.
class ScheduleSelectionSnapshot extends Equatable {
  const ScheduleSelectionSnapshot({
    this.facultyId = '',
    this.formId = '',
    this.groupId = '',
    this.groupName = '',
    required this.path,
    this.fragment = '',
  });

  final String facultyId;
  final String formId;
  final String groupId;
  final String groupName;
  final String path;
  final String fragment;

  /// Ключ `view` для бека/кэша: [fragment] сопоставим с `lection` / `session`, иначе `all`.
  String get viewKey {
    final f = fragment.toLowerCase();
    if (f == 'session') {
      return 'session';
    }
    if (f == 'lection') {
      return 'lection';
    }
    return 'all';
  }

  String get fullStoragePath {
    var p = path.trim();
    if (p.isEmpty) {
      return '';
    }
    p = p.startsWith('/') ? p : '/$p';
    if (fragment.isEmpty) {
      return p;
    }
    return '$p#$fragment';
  }

  bool get isEmpty => path.isEmpty;

  ScheduleSelectionSnapshot copyWith({
    String? facultyId,
    String? formId,
    String? groupId,
    String? groupName,
    String? path,
    String? fragment,
  }) {
    return ScheduleSelectionSnapshot(
      facultyId: facultyId ?? this.facultyId,
      formId: formId ?? this.formId,
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      path: path ?? this.path,
      fragment: fragment ?? this.fragment,
    );
  }

  static ScheduleSelectionSnapshot? fromJson(Map<String, dynamic>? m) {
    if (m == null) {
      return null;
    }
    return ScheduleSelectionSnapshot(
      facultyId: m['facultyId'] as String? ?? '',
      formId: m['formId'] as String? ?? '',
      groupId: m['groupId'] as String? ?? '',
      groupName: m['groupName'] as String? ?? '',
      path: m['path'] as String? ?? '',
      fragment: m['fragment'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'facultyId': facultyId,
      'formId': formId,
      'groupId': groupId,
      'groupName': groupName,
      'path': path,
      'fragment': fragment,
    };
  }

  /// Миграция из одного ключа [schedule_last_path] (путь с опциональным `#`).
  static ScheduleSelectionSnapshot fromLegacyStoredPath(String stored) {
    var s = stored.trim();
    if (s.isEmpty) {
      return const ScheduleSelectionSnapshot(path: '');
    }
    if (!s.startsWith('/')) {
      s = '/$s';
    }
    final h = s.indexOf('#');
    if (h < 0) {
      return ScheduleSelectionSnapshot(path: s);
    }
    return ScheduleSelectionSnapshot(
      path: s.substring(0, h),
      fragment: s.substring(h + 1),
    );
  }

  @override
  List<Object?> get props => [
    facultyId,
    formId,
    groupId,
    groupName,
    path,
    fragment,
  ];
}
