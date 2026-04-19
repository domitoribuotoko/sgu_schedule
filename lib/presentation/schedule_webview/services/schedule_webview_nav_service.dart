import 'package:flutter/material.dart';
import 'package:sgu_schedule/presentation/schedule_webview/services/schedule_webview_nav_interface.dart';

final class ScheduleWebviewNavService implements ScheduleWebviewNavInterface {
  ScheduleWebviewNavService({required BuildContext context}) : _context = context;

  final BuildContext _context;

  @override
  void pop() {
    Navigator.of(_context).maybePop();
  }
}
