import 'package:dartz/dartz.dart';
import 'package:sgu_schedule/domain/_base/app_failure.dart';
import 'package:sgu_schedule/domain/_base/base_use_case.dart';
import 'package:sgu_schedule/domain/_base/sourced_result.dart';
import 'package:sgu_schedule/domain/entities/schedule/study_form.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/cache/cached_study_forms_params.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/cache/get_cached_study_forms_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/cache/save_study_forms_cache_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/fetch/fetch_study_forms_params.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/load_study_forms_use_case.dart';

abstract interface class FetchStudyFormsUseCaseInterface
    extends
        BaseUseCase<FetchStudyFormsParams, SourcedResult<List<StudyForm>>>
{}

final class FetchStudyFormsUseCase implements FetchStudyFormsUseCaseInterface {
  FetchStudyFormsUseCase({
    required LoadStudyFormsUseCaseInterface load,
    required GetCachedStudyFormsUseCaseInterface getCached,
    required SaveStudyFormsToCacheUseCaseInterface save,
  }) : _load = load,
       _get = getCached,
       _save = save;

  final LoadStudyFormsUseCaseInterface _load;
  final GetCachedStudyFormsUseCaseInterface _get;
  final SaveStudyFormsToCacheUseCaseInterface _save;

  SourcedData<List<StudyForm>> _ok(CaseResultSource s, List<StudyForm> d) =>
      SourcedData(source: s, data: d);

  @override
  Future<Either<AppFailure, SourcedResult<List<StudyForm>>>> call([
    FetchStudyFormsParams params = const FetchStudyFormsParams(),
  ]) async {
    if (params.facultyId.isEmpty) {
      return const Left<AppFailure, SourcedResult<List<StudyForm>>>(
        AppFailure(
          message: 'FetchStudyForms: не задан facultyId',
          kind: AppFailureKind.unknown,
        ),
      );
    }
    if (params.forceUpdate) {
      final net = await _load(
        LoadStudyFormsParams(facultyId: params.facultyId),
      );
      if (net.isLeft()) {
        final e = net.fold<AppFailure>(
          (f) => f,
          (_) {
            throw StateError('unreachable');
          },
        );
        if (params.alwaysFallback) {
          final fb = await _get(
            CachedStudyFormsParams(facultyId: params.facultyId),
          );
          return fb.fold(
            (_) => Left<AppFailure, SourcedResult<List<StudyForm>>>(e),
            (c) {
              if (c.isNotEmpty) {
                return Right(_ok(CaseResultSource.cacheUnexpected, c));
              }
              return Left<AppFailure, SourcedResult<List<StudyForm>>>(e);
            },
          );
        }
        return Left(e);
      }
      final data = net.fold(
        (f) {
          throw f;
        },
        (r) => r,
      );
      return (await _save(
        SaveStudyFormsToCacheParams(
          facultyId: params.facultyId,
          items: data,
        ),
      )).fold(
        Left<AppFailure, SourcedResult<List<StudyForm>>>.new,
        (_) {
          return Right(
            _ok(CaseResultSource.networkExpected, data),
          );
        },
      );
    }
    final cache = await _get(
      CachedStudyFormsParams(facultyId: params.facultyId),
    );
    if (cache.isLeft()) {
      if (!params.alwaysFallback) {
        return cache.fold(Left<AppFailure, SourcedResult<List<StudyForm>>>.new, (
          _,
        ) {
          throw StateError('unreachable');
        });
      }
      final net = await _load(
        LoadStudyFormsParams(facultyId: params.facultyId),
      );
      if (net.isLeft()) {
        return net.fold(Left<AppFailure, SourcedResult<List<StudyForm>>>.new, (
          _,
        ) {
          throw StateError('unreachable');
        });
      }
      final data = net.fold(
        (f) {
          throw f;
        },
        (r) => r,
      );
      return (await _save(
        SaveStudyFormsToCacheParams(
          facultyId: params.facultyId,
          items: data,
        ),
      )).fold(
        Left<AppFailure, SourcedResult<List<StudyForm>>>.new,
        (_) {
          return Right(
            _ok(CaseResultSource.networkUnexpected, data),
          );
        },
      );
    }
    final c = cache.fold(
      (f) {
        throw f;
      },
      (r) => r,
    );
    if (c.isNotEmpty) {
      return Right(_ok(CaseResultSource.cacheExpected, c));
    }
    if (!params.alwaysFallback) {
      return const Left<AppFailure, SourcedResult<List<StudyForm>>>(
        AppFailure(
          message: 'Формы обучения: кэш пуст, alwaysFallback: false',
          kind: AppFailureKind.unknown,
        ),
      );
    }
    final net2 = await _load(
      LoadStudyFormsParams(facultyId: params.facultyId),
    );
    if (net2.isLeft()) {
      return net2.fold(Left<AppFailure, SourcedResult<List<StudyForm>>>.new, (
        _,
      ) {
        throw StateError('unreachable');
      });
    }
    final data2 = net2.fold(
      (f) {
        throw f;
      },
      (r) => r,
    );
    return (await _save(
      SaveStudyFormsToCacheParams(
        facultyId: params.facultyId,
        items: data2,
      ),
    )).fold(
      Left<AppFailure, SourcedResult<List<StudyForm>>>.new,
      (_) {
        return Right(
          _ok(CaseResultSource.networkUnexpected, data2),
        );
      },
    );
  }
}
