import 'package:dartz/dartz.dart';
import 'package:sgu_schedule/domain/_base/app_failure.dart';
import 'package:sgu_schedule/domain/_base/base_use_case.dart';
import 'package:sgu_schedule/domain/_base/sourced_result.dart';
import 'package:sgu_schedule/domain/entities/schedule/schedule_group.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/cache/cached_groups_params.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/cache/get_cached_groups_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/cache/save_groups_cache_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/fetch/fetch_groups_params.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/load_groups_use_case.dart';

abstract interface class FetchGroupsUseCaseInterface
    extends
        BaseUseCase<FetchGroupsParams, SourcedResult<List<ScheduleGroup>>>
{}

final class FetchGroupsUseCase implements FetchGroupsUseCaseInterface {
  FetchGroupsUseCase({
    required LoadGroupsUseCaseInterface load,
    required GetCachedGroupsUseCaseInterface getCached,
    required SaveGroupsToCacheUseCaseInterface save,
  }) : _load = load,
       _get = getCached,
       _save = save;

  final LoadGroupsUseCaseInterface _load;
  final GetCachedGroupsUseCaseInterface _get;
  final SaveGroupsToCacheUseCaseInterface _save;

  SourcedData<List<ScheduleGroup>> _ok(
    CaseResultSource s,
    List<ScheduleGroup> d,
  ) => SourcedData(source: s, data: d);

  @override
  Future<Either<AppFailure, SourcedResult<List<ScheduleGroup>>>> call([
    FetchGroupsParams params = const FetchGroupsParams(),
  ]) async {
    if (params.facultyId.isEmpty || params.formId.isEmpty) {
      return const Left<AppFailure, SourcedResult<List<ScheduleGroup>>>(
        AppFailure(
          message: 'FetchGroups: не заданы facultyId / formId',
          kind: AppFailureKind.unknown,
        ),
      );
    }
    if (params.forceUpdate) {
      final net = await _load(
        LoadGroupsParams(
          facultyId: params.facultyId,
          formId: params.formId,
        ),
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
            CachedGroupsParams(
              facultyId: params.facultyId,
              formId: params.formId,
            ),
          );
          return fb.fold(
            (_) => Left<AppFailure, SourcedResult<List<ScheduleGroup>>>(e),
            (c) {
              if (c.isNotEmpty) {
                return Right(_ok(CaseResultSource.cacheUnexpected, c));
              }
              return Left<AppFailure, SourcedResult<List<ScheduleGroup>>>(e);
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
        SaveGroupsToCacheParams(
          facultyId: params.facultyId,
          formId: params.formId,
          items: data,
        ),
      )).fold(
        Left<AppFailure, SourcedResult<List<ScheduleGroup>>>.new,
        (_) {
          return Right(
            _ok(CaseResultSource.networkExpected, data),
          );
        },
      );
    }
    final cache = await _get(
      CachedGroupsParams(
        facultyId: params.facultyId,
        formId: params.formId,
      ),
    );
    if (cache.isLeft()) {
      if (!params.alwaysFallback) {
        return cache.fold(Left<AppFailure, SourcedResult<List<ScheduleGroup>>>.new, (
          _,
        ) {
          throw StateError('unreachable');
        });
      }
      final net = await _load(
        LoadGroupsParams(
          facultyId: params.facultyId,
          formId: params.formId,
        ),
      );
      if (net.isLeft()) {
        return net.fold(Left<AppFailure, SourcedResult<List<ScheduleGroup>>>.new, (
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
        SaveGroupsToCacheParams(
          facultyId: params.facultyId,
          formId: params.formId,
          items: data,
        ),
      )).fold(
        Left<AppFailure, SourcedResult<List<ScheduleGroup>>>.new,
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
      return const Left<AppFailure, SourcedResult<List<ScheduleGroup>>>(
        AppFailure(
          message: 'Группы: кэш пуст, alwaysFallback: false',
          kind: AppFailureKind.unknown,
        ),
      );
    }
    final net2 = await _load(
      LoadGroupsParams(
        facultyId: params.facultyId,
        formId: params.formId,
      ),
    );
    if (net2.isLeft()) {
      return net2.fold(Left<AppFailure, SourcedResult<List<ScheduleGroup>>>.new, (
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
      SaveGroupsToCacheParams(
        facultyId: params.facultyId,
        formId: params.formId,
        items: data2,
      ),
    )).fold(
      Left<AppFailure, SourcedResult<List<ScheduleGroup>>>.new,
      (_) {
        return Right(
          _ok(CaseResultSource.networkUnexpected, data2),
        );
      },
    );
  }
}
