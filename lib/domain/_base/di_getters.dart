import 'package:sgu_schedule/core/di/di_interface.dart';
import 'package:sgu_schedule/domain/repositories/schedule_path_repository.dart';
import 'package:sgu_schedule/domain/use_cases/schedule/clear_saved_schedule_path_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule/get_initial_schedule_web_url_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule/save_schedule_path_use_case.dart';
import 'package:sgu_schedule/presentation/schedule_webview_page/cubit/schedule_webview_cubit_factory.dart';

class Factories {
  Factories(this._di);

  final DIContainer _di;

  ScheduleWebviewCubitFactory get scheduleWebviewCubitFactory =>
      _di.get<ScheduleWebviewCubitFactory>();
}

class Dependencies {
  Dependencies(this._di);

  /// Зарезервировано под зависимости вне юзкейсов (пока пусто).
  final DIContainer _di;
}

class UseCases {
  UseCases(this._di);

  final DIContainer _di;

  SchedulePathRepository get _schedulePathRepository =>
      _di.get<SchedulePathRepository>();

  GetInitialScheduleWebUrlUseCaseInterface get getInitialScheduleWebUrl =>
      GetInitialScheduleWebUrlUseCase(repository: _schedulePathRepository);

  SaveSchedulePathUseCaseInterface get saveSchedulePath =>
      SaveSchedulePathUseCase(repository: _schedulePathRepository);

  ClearSavedSchedulePathUseCaseInterface get clearSavedSchedulePath =>
      ClearSavedSchedulePathUseCase(repository: _schedulePathRepository);
}
