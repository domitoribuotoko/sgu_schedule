import 'package:sgu_schedule/core/di/di_interface.dart';
import 'package:sgu_schedule/presentation/_base/services/app_link_laucher_service.dart';
import 'package:sgu_schedule/presentation/schedule_webview/cubit/schedule_webview_cubit.dart';

abstract interface class ScheduleWebviewCubitFactory {
  ScheduleWebviewCubit create();
}

final class ScheduleWebviewCubitFactoryImpl
    implements ScheduleWebviewCubitFactory {
  ScheduleWebviewCubitFactoryImpl(this._di);

  final DIContainer _di;

  @override
  ScheduleWebviewCubit create() {
    final uc = _di.useCases;
    return ScheduleWebviewCubit(
      linkLauncher: AppLinkLauncherService(),
      getInitialUrl: uc.getInitialScheduleWebUrl,
      saveSchedulePath: uc.saveSchedulePath,
    )..init();
  }
}
