import 'package:sgu_schedule/presentation/_base/utils/app_router/base_routes.dart';
import 'package:sgu_schedule/presentation/_base/utils/app_router/route_paths.dart';
import 'package:sgu_schedule/presentation/schedule_selection_web/page/schedule_selection_page.dart';
import 'package:sgu_schedule/presentation/schedule_timetable_page/page/schedule_timetable_page.dart';
import 'package:sgu_schedule/presentation/splash/splash_page.dart';

class AppRoutes {
  AppRoutes._();

  static BaseRoute get splash =>
      BaseRoute(path: RoutePaths.splash, child: const SplashPage());

  static BaseRoute get select => BaseRoute(
    path: RoutePaths.select,
    child: const ScheduleSelectionPage(),
  );

  static BaseRoute get scheduleTimetable => BaseRoute(
    path: RoutePaths.scheduleTimetable,
    child: const ScheduleTimetablePage(),
  );
}
