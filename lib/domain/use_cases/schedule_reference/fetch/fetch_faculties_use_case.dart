import 'package:dartz/dartz.dart';
import 'package:sgu_schedule/domain/_base/app_failure.dart';
import 'package:sgu_schedule/domain/_base/base_use_case.dart';
import 'package:sgu_schedule/domain/_base/sourced_result.dart';
import 'package:sgu_schedule/domain/entities/schedule/faculty.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/cache/get_cached_faculties_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/cache/save_faculties_cache_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/fetch/fetch_faculties_params.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/load_faculties_use_case.dart';

abstract interface class FetchFacultiesUseCaseInterface
    extends
        BaseUseCase<FetchFacultiesParams, SourcedResult<List<Faculty>>>
{}

final class FetchFacultiesUseCase implements FetchFacultiesUseCaseInterface {
  FetchFacultiesUseCase({
    required LoadFacultiesUseCaseInterface loadFaculties,
    required GetCachedFacultiesUseCaseInterface getCached,
    required SaveFacultiesToCacheUseCaseInterface saveToCache,
  }) : _load = loadFaculties,
       _get = getCached,
       _save = saveToCache;

  final LoadFacultiesUseCaseInterface _load;
  final GetCachedFacultiesUseCaseInterface _get;
  final SaveFacultiesToCacheUseCaseInterface _save;

  SourcedData<List<Faculty>> _ok(CaseResultSource s, List<Faculty> d) =>
      SourcedData(source: s, data: d);

  @override
  Future<Either<AppFailure, SourcedResult<List<Faculty>>>> call([
    FetchFacultiesParams params = const FetchFacultiesParams(),
  ]) async {
    if (params.forceUpdate) {
      final net = await _load();
      if (net.isLeft()) {
        final e = net.fold<AppFailure>(
          (f) => f,
          (_) {
            throw StateError('unreachable');
          },
        );
        if (params.alwaysFallback) {
          final fb = await _get();
          return fb.fold(
            (_) => Left<AppFailure, SourcedResult<List<Faculty>>>(e),
            (c) {
              if (c.isNotEmpty) {
                return Right(_ok(CaseResultSource.cacheUnexpected, c));
              }
              return Left<AppFailure, SourcedResult<List<Faculty>>>(e);
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
        SaveFacultiesToCacheParams(items: data),
      )).fold(
        Left<AppFailure, SourcedResult<List<Faculty>>>.new,
        (_) {
          return Right(
            _ok(CaseResultSource.networkExpected, data),
          );
        },
      );
    }

    final cache = await _get();
    if (cache.isLeft()) {
      if (!params.alwaysFallback) {
        return cache.fold(Left<AppFailure, SourcedResult<List<Faculty>>>.new, (
          _,
        ) {
          throw StateError('unreachable');
        });
      }
      final net = await _load();
      if (net.isLeft()) {
        return net.fold(Left<AppFailure, SourcedResult<List<Faculty>>>.new, (
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
        SaveFacultiesToCacheParams(items: data),
      )).fold(
        Left<AppFailure, SourcedResult<List<Faculty>>>.new,
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
      return const Left<AppFailure, SourcedResult<List<Faculty>>>(
        AppFailure(
          message: 'Список факультетов пуст, сеть отключена (alwaysFallback: false)',
          kind: AppFailureKind.unknown,
        ),
      );
    }
    final net2 = await _load();
    if (net2.isLeft()) {
      return net2.fold(Left<AppFailure, SourcedResult<List<Faculty>>>.new, (
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
      SaveFacultiesToCacheParams(items: data2),
    )).fold(
      Left<AppFailure, SourcedResult<List<Faculty>>>.new,
      (_) {
        return Right(
          _ok(CaseResultSource.networkUnexpected, data2),
        );
      },
    );
  }
}
