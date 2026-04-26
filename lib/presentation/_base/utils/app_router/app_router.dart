import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sgu_schedule/presentation/_base/utils/app_router/app_routes.dart';
import 'package:sgu_schedule/presentation/_base/utils/app_router/route_paths.dart';
import 'package:sgu_schedule/presentation/_base/utils/app_router/telegram_tgweb_redirect.dart';

class AppRouter extends GoRouter {
  AppRouter()
    : super.routingConfig(
        initialLocation: kIsWeb ? RoutePaths.splash : RoutePaths.schedule,
        observers: [RouteObserver<ModalRoute<dynamic>>()],
        onException: telegramTgWebOnException,
        routingConfig: ValueNotifier(
          RoutingConfig(
            redirect: telegramTgWebGlobalRedirect,
            routes: [
              AppRoutes.splash,
              AppRoutes.select,
              AppRoutes.scheduleTimetable,
              AppRoutes.schedule,
            ],
          ),
        ),
      );
}
