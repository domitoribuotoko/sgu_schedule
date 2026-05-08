import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgu_schedule/domain/entities/schedule/schedule_group.dart';
import 'package:sgu_schedule/domain/services/telegram_mini_app_gateway.dart';
import 'package:sgu_schedule/domain/use_cases/schedule/get_schedule_selection_snapshot_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule/save_schedule_selection_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/fetch/fetch_faculties_params.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/fetch/fetch_faculties_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/telegram/get_telegram_schedule_binding_use_case.dart';
import 'package:sgu_schedule/presentation/splash/cubit/splash_state.dart';
import 'package:sgu_schedule/presentation/splash/services/splash_nav_interface.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({
    required TelegramMiniAppGateway telegramGateway,
    required GetTelegramScheduleBindingUseCaseInterface getTelegramBinding,
    required GetScheduleSelectionSnapshotUseCaseInterface getLocalSnapshot,
    required SaveScheduleSelectionUseCaseInterface saveLocalSelection,
    required FetchFacultiesUseCaseInterface fetchFaculties,
    required SplashNav nav,
  }) : _telegramGateway = telegramGateway,
       _getTelegramBinding = getTelegramBinding,
       _getLocalSnapshot = getLocalSnapshot,
       _saveLocalSelection = saveLocalSelection,
       _fetchFaculties = fetchFaculties,
       _nav = nav,
       super(const SplashState());

  final TelegramMiniAppGateway _telegramGateway;
  final GetTelegramScheduleBindingUseCaseInterface _getTelegramBinding;
  final GetScheduleSelectionSnapshotUseCaseInterface _getLocalSnapshot;
  final SaveScheduleSelectionUseCaseInterface _saveLocalSelection;
  final FetchFacultiesUseCaseInterface _fetchFaculties;
  final SplashNav _nav;

  void init() {
    _run();
  }

  void onRetryTap() {
    _run();
  }

  Future<void> _run() async {
    emit(state.copyWith(loading: true, clearError: true));

    final rawInit = _telegramGateway.readLaunchContext().rawInitData?.trim() ?? '';
    if (rawInit.isNotEmpty) {
      final bindR = await _getTelegramBinding.call(
        GetTelegramScheduleBindingParams(initDataRaw: rawInit),
      );
      if (isClosed) {
        return;
      }
      final remote = bindR.fold((_) => null, (r) => r);
      if (remote != null && !remote.isEmpty) {
        var path = remote.path.trim();
        if (path.isNotEmpty && !path.startsWith('/')) {
          path = '/$path';
        }
        var frag = remote.fragment;
        if (frag.startsWith('#')) {
          frag = frag.substring(1);
        }
        final saveR = await _saveLocalSelection.call(
          SaveScheduleSelectionInput(
            facultyId: remote.facultyId,
            formId: remote.formId,
            group: ScheduleGroup(
              id: remote.groupId,
              name: remote.groupName,
              schedulePath: path,
            ),
            fragment: frag,
          ),
        );
        if (isClosed) {
          return;
        }
        saveR.fold(
          (e) {
            emit(state.copyWith(loading: false, error: e.message));
          },
          (_) {
            emit(state.copyWith(loading: false));
            _nav.goTimetable();
          },
        );
        return;
      }
    }

    if (kIsWeb) {
      final snapR = await _getLocalSnapshot.call();
      if (isClosed) {
        return;
      }
      final snap = snapR.fold((_) => null, (s) => s);
      if (snap != null && snap.path.isNotEmpty) {
        emit(state.copyWith(loading: false));
        _nav.goTimetable();
        return;
      }
    }

    final fetchR = await _fetchFaculties.call(
      const FetchFacultiesParams(
        forceUpdate: true,
        alwaysFallback: true,
      ),
    );
    if (isClosed) {
      return;
    }
    fetchR.fold(
      (e) {
        emit(state.copyWith(loading: false, error: e.message));
      },
      (_) {
        emit(state.copyWith(loading: false));
        _nav.goSelect();
      },
    );
  }
}
