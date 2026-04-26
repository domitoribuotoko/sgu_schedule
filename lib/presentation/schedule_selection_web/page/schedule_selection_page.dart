import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgu_schedule/presentation/_base/extensions/presentation_di_extension.dart';
import 'package:sgu_schedule/presentation/schedule_selection_web/widget/schedule_selection_widget.dart';

class ScheduleSelectionPage extends StatelessWidget {
  const ScheduleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) =>
          ctx.factories.scheduleSelectionCubitFactory.create(ctx),
      child: const ScheduleSelectionWidget(),
    );
  }
}
