import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgu_schedule/presentation/_base/extensions/presentation_di_extension.dart';
import 'package:sgu_schedule/presentation/schedule_webview/widget/schedule_webview_widget.dart';

class ScheduleWebviewPage extends StatelessWidget {
  const ScheduleWebviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => ctx.factories.scheduleWebviewCubitFactory.create(),
      child: const ScheduleWebviewWidget(),
    );
  }
}
