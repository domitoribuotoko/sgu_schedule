import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
import 'package:flutter/services.dart' show rootBundle;
import 'package:sgu_schedule/core/config/schedule_api_config.dart';

/// JSON из [assets/mocks/schedule/] — срез [assets/test_site.html] (#select-education)
/// и вспомогательные карты «форма обучения / группы».
final class ScheduleApiAssetMockInterceptor extends Interceptor {
  static const _assetsPrefix = 'assets/mocks/schedule/';

  static const _kFaculties = '${_assetsPrefix}faculties.json';
  static const _kStudyByFaculty = '${_assetsPrefix}study_forms_by_faculty.json';
  static const _kGroupsByScope = '${_assetsPrefix}groups_by_scope.json';
  static const _kScheduleContentByKey =
      '${_assetsPrefix}schedule_content_by_key.json';

  static String? _facultiesCache;
  static String? _studyByFacultyCache;
  static String? _groupsByScopeCache;
  static String? _scheduleContentByKeyCache;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (!ScheduleApiConfig.useAssetMocks) {
      return handler.next(options);
    }
    if (options.method != 'GET') {
      return handler.next(options);
    }
    unawaited(_tryMock(options, handler));
  }

  static Future<void> _tryMock(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    String path = options.path;
    if (path.isEmpty) {
      path = options.uri.path;
    }
    if (path.isEmpty) {
      return handler.next(options);
    }
    if (!path.startsWith('/')) {
      path = '/$path';
    }
    if (kDebugMode) {
      debugPrint('ScheduleApiMock: $path');
    }
    try {
      final r = _matchRequest(options, path);
      if (r == null) {
        return handler.next(options);
      }
      final (:key, :type) = r;
      final json = await _loadBody(key, type);
      return handler.resolve(
        Response<dynamic>(
          requestOptions: options,
          data: json,
          statusCode: 200,
        ),
      );
    } on Object catch (e, st) {
      if (kDebugMode) {
        debugPrint('ScheduleApiMock: fallback to network: $e\n$st');
      }
      return handler.next(options);
    }
  }

  /// [requestPath] — уже нормализованный path (с ведущим `/`).
  static ({Object? key, _MockType type})? _matchRequest(
    RequestOptions options,
    String requestPath,
  ) {
    if (RegExp(r'^/v1/schedule/faculties/?$').hasMatch(requestPath)) {
      return (key: null, type: _MockType.faculties);
    }
    final f1 = RegExp(
      r'^/v1/schedule/faculties/([^/]+)/study-forms/?$',
    ).firstMatch(requestPath);
    if (f1 != null) {
      return (key: f1.group(1)!, type: _MockType.studyForms);
    }
    final f2 = RegExp(
      r'^/v1/schedule/faculties/([^/]+)/study-forms/([^/]+)/groups/?$',
    ).firstMatch(requestPath);
    if (f2 != null) {
      return (
        key: [f2.group(1)!, f2.group(2)!],
        type: _MockType.groups,
      );
    }
    if (RegExp(r'^/v1/schedule/content/?$').hasMatch(requestPath)) {
      final rawPath = options.uri.queryParameters['path'] ?? '';
      final view = options.uri.queryParameters['view'] ?? 'all';
      var norm = rawPath.trim();
      if (norm.isNotEmpty && !norm.startsWith('/')) {
        norm = '/$norm';
      }
      final lookupKey = '$norm|$view';
      return (key: lookupKey, type: _MockType.scheduleContent);
    }
    return null;
  }

  static Future<dynamic> _loadBody(Object? id, _MockType mType) async {
    switch (mType) {
      case _MockType.faculties:
        _facultiesCache ??= await rootBundle.loadString(_kFaculties);
        return json.decode(_facultiesCache!);
      case _MockType.studyForms:
        final idStr = id as String;
        _studyByFacultyCache ??= await rootBundle.loadString(
          _kStudyByFaculty,
        );
        final root = json.decode(_studyByFacultyCache!) as Map<String, dynamic>;
        final sub = (root[idStr] ?? root['__default']) as Object?;
        if (sub is Map<String, dynamic>) {
          return sub;
        }
        return (root['__default'] as Object?) is Map<String, dynamic>
            ? (root['__default']! as Map<String, dynamic>)
            : <String, dynamic>{'items': <dynamic>[]};
      case _MockType.groups:
        final ids = id as List<String>;
        final k = '${ids[0]}|${ids[1]}';
        _groupsByScopeCache ??= await rootBundle.loadString(_kGroupsByScope);
        final root = json.decode(_groupsByScopeCache!) as Map<String, dynamic>;
        final sub = (root[k] ?? root['__default']) as Object?;
        if (sub is Map<String, dynamic>) {
          return sub;
        }
        return (root['__default'] as Object?) is Map<String, dynamic>
            ? (root['__default']! as Map<String, dynamic>)
            : <String, dynamic>{'items': <dynamic>[]};
      case _MockType.scheduleContent:
        final lookupKey = id as String;
        _scheduleContentByKeyCache ??= await rootBundle.loadString(
          _kScheduleContentByKey,
        );
        final root =
            json.decode(_scheduleContentByKeyCache!) as Map<String, dynamic>;
        final sub = (root[lookupKey] ?? root['__default']) as Object?;
        if (sub is Map<String, dynamic>) {
          return sub;
        }
        return (root['__default'] as Object?) is Map<String, dynamic>
            ? (root['__default']! as Map<String, dynamic>)
            : <String, dynamic>{
                'view': 'all',
                'sourcePath': '',
                'weeks': <dynamic>[],
              };
    }
  }
}

enum _MockType { faculties, studyForms, groups, scheduleContent }
