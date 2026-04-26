import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgu_schedule/domain/use_cases/schedule/get_schedule_selection_snapshot_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule/load_schedule_timetable_use_case.dart';
import 'package:sgu_schedule/presentation/schedule_timetable_page/cubit/schedule_timetable_state.dart';

class ScheduleTimetableCubit extends Cubit<ScheduleTimetableState> {
  ScheduleTimetableCubit({
    required GetScheduleSelectionSnapshotUseCaseInterface getSelection,
    required LoadScheduleTimetableUseCaseInterface loadTimetable,
  }) : _getSelection = getSelection,
       _loadTimetable = loadTimetable,
       super(const ScheduleTimetableState()) {
    load();
  }

  final GetScheduleSelectionSnapshotUseCaseInterface _getSelection;
  final LoadScheduleTimetableUseCaseInterface _loadTimetable;

  Future<void> load({bool forceUpdate = false}) async {
    emit(state.copyWith(loading: true, error: ''));
    final selR = await _getSelection();
    final sel = selR.fold((_) => null, (s) => s);
    if (sel == null || sel.path.isEmpty) {
      emit(
        const ScheduleTimetableState(
          loading: false,
          error: 'Расписание не выбрано',
        ),
      );
      return;
    }
    final t = await _loadTimetable(
      LoadScheduleTimetableParams(
        schedulePath: sel.path,
        viewKey: sel.viewKey,
        forceUpdate: forceUpdate,
      ),
    );
    t.fold(
      (e) {
        emit(
          ScheduleTimetableState(loading: false, error: e.message),
        );
      },
      (data) {
        emit(ScheduleTimetableState(loading: false, timetable: data));
      },
    );
  }
}
