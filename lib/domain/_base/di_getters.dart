import 'package:sgu_schedule/core/di/di_interface.dart';
import 'package:sgu_schedule/domain/repositories/schedule_path_repository.dart';
import 'package:sgu_schedule/domain/services/telegram_mini_app_gateway.dart';
import 'package:sgu_schedule/domain/use_cases/schedule/clear_saved_schedule_path_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule/get_schedule_selection_snapshot_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule/load_schedule_timetable_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule/save_schedule_selection_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/fetch/fetch_faculties_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/fetch/fetch_groups_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/fetch/fetch_study_forms_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/load_faculties_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/load_groups_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/load_study_forms_use_case.dart';
import 'package:sgu_schedule/presentation/schedule_selection_web/cubit/schedule_selection_cubit_factory.dart';
import 'package:sgu_schedule/presentation/schedule_timetable_page/cubit/schedule_timetable_cubit_factory.dart';
import 'package:sgu_schedule/presentation/splash/cubit/splash_cubit_factory.dart';

class Factories {
  Factories(this._di);

  final DIContainer _di;

  ScheduleSelectionCubitFactory get scheduleSelectionCubitFactory =>
      _di.get<ScheduleSelectionCubitFactory>();

  ScheduleTimetableCubitFactory get scheduleTimetableCubitFactory =>
      _di.get<ScheduleTimetableCubitFactory>();

  SplashCubitFactory get splashCubitFactory => _di.get<SplashCubitFactory>();
}

class Dependencies {
  Dependencies(this._di);

  final DIContainer _di;

  TelegramMiniAppGateway get telegramMiniApp =>
      _di.get<TelegramMiniAppGateway>();
}

class UseCases {
  UseCases(this._di);

  final DIContainer _di;

  SchedulePathRepository get _schedulePathRepository =>
      _di.get<SchedulePathRepository>();

  ClearSavedSchedulePathUseCaseInterface get clearSavedSchedulePath =>
      ClearSavedSchedulePathUseCase(repository: _schedulePathRepository);

  SaveScheduleSelectionUseCaseInterface get saveScheduleSelection =>
      SaveScheduleSelectionUseCase(repository: _schedulePathRepository);

  GetScheduleSelectionSnapshotUseCaseInterface
  get getScheduleSelectionSnapshot => GetScheduleSelectionSnapshotUseCase(
    repository: _schedulePathRepository,
  );

  LoadScheduleTimetableUseCaseInterface get loadScheduleTimetable =>
      _di.get<LoadScheduleTimetableUseCaseInterface>();

  LoadFacultiesUseCaseInterface get loadFaculties =>
      _di.get<LoadFacultiesUseCaseInterface>();

  LoadStudyFormsUseCaseInterface get loadStudyForms =>
      _di.get<LoadStudyFormsUseCaseInterface>();

  LoadGroupsUseCaseInterface get loadGroups =>
      _di.get<LoadGroupsUseCaseInterface>();

  FetchFacultiesUseCaseInterface get fetchFaculties =>
      _di.get<FetchFacultiesUseCaseInterface>();

  FetchStudyFormsUseCaseInterface get fetchStudyForms =>
      _di.get<FetchStudyFormsUseCaseInterface>();

  FetchGroupsUseCaseInterface get fetchGroups =>
      _di.get<FetchGroupsUseCaseInterface>();
}
