import 'package:sgu_schedule/core/di/di_interface.dart';
import 'package:sgu_schedule/domain/use_cases/schedule/load_schedule_timetable_use_case.dart';
import 'package:sgu_schedule/presentation/schedule_timetable_page/cubit/schedule_timetable_cubit.dart';

abstract interface class ScheduleTimetableCubitFactory {
  ScheduleTimetableCubit create();
}

final class ScheduleTimetableCubitFactoryImpl
    implements ScheduleTimetableCubitFactory {
  ScheduleTimetableCubitFactoryImpl(this._di);

  final DIContainer _di;

  @override
  ScheduleTimetableCubit create() {
    return ScheduleTimetableCubit(
      getSelection: _di.useCases.getScheduleSelectionSnapshot,
      loadTimetable: _di.get<LoadScheduleTimetableUseCaseInterface>(),
    );
  }
}
