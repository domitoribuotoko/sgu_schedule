import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgu_schedule/presentation/_base/extensions/presentation_di_extension.dart';
import 'package:sgu_schedule/presentation/schedule_timetable_page/widget/schedule_timetable_widget.dart';

class ScheduleTimetablePage extends StatelessWidget {
  const ScheduleTimetablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => context.factories.scheduleTimetableCubitFactory.create(),
      child: const ScheduleTimetableWidget(),
    );
  }
}
