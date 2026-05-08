import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sgu_schedule/presentation/_base/utils/app_router/route_paths.dart';
import 'package:sgu_schedule/presentation/splash/services/splash_nav_interface.dart';

class SplashNavService implements SplashNav {
  SplashNavService(this._context);

  final BuildContext _context;

  @override
  void goSelect() {
    _context.go(RoutePaths.select);
  }

  @override
  void goTimetable() {
    _context.go(RoutePaths.scheduleTimetable);
  }
}
