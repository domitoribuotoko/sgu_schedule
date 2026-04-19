import 'package:sgu_schedule/presentation/_base/utils/app_router/base_routes.dart';
import 'package:sgu_schedule/presentation/_base/utils/app_router/route_paths.dart';
import 'package:sgu_schedule/presentation/schedule_webview/page/schedule_webview_page.dart';

class AppRoutes {
  AppRoutes._();

  static BaseRoute get schedule =>
      BaseRoute(path: RoutePaths.schedule, child: const ScheduleWebviewPage());
}
