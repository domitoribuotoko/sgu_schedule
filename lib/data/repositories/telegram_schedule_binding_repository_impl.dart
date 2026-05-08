import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sgu_schedule/data/dto/telegram/telegram_schedule_binding_dtos.dart';
import 'package:sgu_schedule/data/network/sgu_schedule_api.dart';
import 'package:sgu_schedule/domain/_base/app_failure.dart';
import 'package:sgu_schedule/domain/entities/schedule/schedule_selection_snapshot.dart';
import 'package:sgu_schedule/domain/repositories/telegram_schedule_binding_repository.dart';

class TelegramScheduleBindingRepositoryImpl
    implements TelegramScheduleBindingRepository {
  TelegramScheduleBindingRepositoryImpl({required SguScheduleApi api})
    : _api = api;

  final SguScheduleApi _api;

  @override
  Future<Either<AppFailure, ScheduleSelectionSnapshot?>> getBinding(
    String initDataRaw,
  ) async {
    final trimmed = initDataRaw.trim();
    if (trimmed.isEmpty) {
      return const Right(null);
    }
    try {
      final r = await _api.queryTelegramScheduleSelection(
        TelegramScheduleSelectionQueryRequestDto(initData: trimmed),
      );
      if (!r.hasSaved || r.selection == null) {
        return const Right(null);
      }
      final s = r.selection!;
      return Right(
        ScheduleSelectionSnapshot(
          facultyId: s.facultyId,
          formId: s.formId,
          groupId: s.groupId,
          groupName: s.groupName,
          path: s.path,
          fragment: s.fragment,
        ),
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 401 || code == 403) {
        return const Right(null);
      }
      final msg = e.message ?? e.response?.data?.toString() ?? 'DioException';
      return Left(
        AppFailure(
          message: 'Сеть: $msg',
          kind: AppFailureKind.network,
        ),
      );
    } on Object catch (e) {
      return Left(
        AppFailure(
          message: 'Telegram binding: $e',
          kind: AppFailureKind.unknown,
        ),
      );
    }
  }

  @override
  Future<Either<AppFailure, Unit>> saveBinding(
    String initDataRaw,
    ScheduleSelectionSnapshot snapshot,
  ) async {
    final trimmed = initDataRaw.trim();
    if (trimmed.isEmpty || snapshot.isEmpty) {
      return const Right(unit);
    }
    try {
      await _api.saveTelegramScheduleSelection(
        TelegramScheduleSelectionSaveRequestDto(
          initData: trimmed,
          selection: ScheduleSelectionSnapshotDto(
            facultyId: snapshot.facultyId,
            formId: snapshot.formId,
            groupId: snapshot.groupId,
            groupName: snapshot.groupName,
            path: snapshot.path,
            fragment: snapshot.fragment,
          ),
        ),
      );
      return const Right(unit);
    } on DioException catch (e) {
      final msg = e.message ?? e.response?.data?.toString() ?? 'DioException';
      return Left(
        AppFailure(
          message: 'Сеть: $msg',
          kind: AppFailureKind.network,
        ),
      );
    } on Object catch (e) {
      return Left(
        AppFailure(
          message: 'Telegram binding: $e',
          kind: AppFailureKind.unknown,
        ),
      );
    }
  }
}
