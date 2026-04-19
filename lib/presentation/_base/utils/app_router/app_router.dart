import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sgu_schedule/presentation/_base/utils/app_router/app_routes.dart';
import 'package:sgu_schedule/presentation/_base/utils/app_router/route_paths.dart';

class AppRouter extends GoRouter {
  AppRouter()
    : super.routingConfig(
        initialLocation: RoutePaths.schedule,
        observers: [RouteObserver<ModalRoute<dynamic>>()],
        // refreshListenable: noInternetNotifier,
        routingConfig: ValueNotifier(
          RoutingConfig(routes: [AppRoutes.schedule]),
        ),
      );
}
