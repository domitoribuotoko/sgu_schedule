import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sgu_schedule/domain/entities/schedule/schedule_group.dart';
import 'package:sgu_schedule/presentation/_base/utils/app_router/route_paths.dart';
import 'package:sgu_schedule/presentation/schedule_selection_web/services/schedule_selection_nav_interface.dart';

class ScheduleSelectionNavService implements ScheduleSelectionNav {
  ScheduleSelectionNavService(this._context);
  final BuildContext _context;

  @override
  void goToSchedule(ScheduleGroup group) {
    if (kIsWeb) {
      _context.go(RoutePaths.scheduleTimetable);
      return;
    }
    _context.go(RoutePaths.schedule);
  }
}
