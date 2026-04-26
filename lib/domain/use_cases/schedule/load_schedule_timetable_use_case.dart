import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:sgu_schedule/domain/_base/app_failure.dart';
import 'package:sgu_schedule/domain/_base/base_use_case.dart';
import 'package:sgu_schedule/domain/entities/schedule/schedule_timetable.dart';
import 'package:sgu_schedule/domain/repositories/schedule_timetable_cache_repository.dart';
import 'package:sgu_schedule/domain/repositories/schedule_timetable_repository.dart';

/// Срок, в течение которого кэш считается «свежим» (неделя).
int scheduleTimetableValidDurationMs() => 7 * 24 * 60 * 60 * 1000;

class LoadScheduleTimetableParams {
  const LoadScheduleTimetableParams({
    required this.schedulePath,
    required this.viewKey,
    this.forceUpdate = false,
  });

  final String schedulePath;
  final String viewKey;
  final bool forceUpdate;
}

abstract interface class LoadScheduleTimetableUseCaseInterface
    extends BaseUseCase<LoadScheduleTimetableParams, ScheduleTimetable> {}

/// Кэш (TTL) + сеть; при сбое сети — устаревший кэш, если есть.
final class LoadScheduleTimetableUseCase
    implements LoadScheduleTimetableUseCaseInterface {
  LoadScheduleTimetableUseCase({
    required ScheduleTimetableRepository remote,
    required ScheduleTimetableCacheRepository cache,
  }) : _remote = remote,
       _cache = cache;

  final ScheduleTimetableRepository _remote;
  final ScheduleTimetableCacheRepository _cache;

  @override
  FutureOr<Either<AppFailure, ScheduleTimetable>> call([
    LoadScheduleTimetableParams params = const LoadScheduleTimetableParams(
      schedulePath: '',
      viewKey: 'all',
    ),
  ]) async {
    if (params.schedulePath.isEmpty) {
      return Left(
        AppFailure(
          message: 'Путь расписания не задан',
          kind: AppFailureKind.unknown,
        ),
      );
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    final view = params.viewKey.isEmpty ? 'all' : params.viewKey;

    final cachedEither = await _cache.getWithMeta(
      params.schedulePath,
      view,
    );
    return cachedEither.fold(Left.new, (cached) async {
      if (!params.forceUpdate && cached != null && now < cached.validUntilMs) {
        return Right(cached.data);
      }

      final net = await _remote.fetchRemote(params.schedulePath, view);
      return await net.fold(
        (fail) async {
          if (cached != null) {
            return Right(cached.data);
          }
          return Left(fail);
        },
        (data) async {
          final v = now + scheduleTimetableValidDurationMs();
          final s = await _cache.save(
            params.schedulePath,
            view,
            data,
            fetchedAtMs: now,
            validUntilMs: v,
          );
          return s.fold(Left.new, (_) => Right(data));
        },
      );
    });
  }
}
