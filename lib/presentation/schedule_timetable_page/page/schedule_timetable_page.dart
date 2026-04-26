import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sgu_schedule/domain/entities/schedule/schedule_timetable.dart';
import 'package:sgu_schedule/presentation/_base/extensions/presentation_di_extension.dart';
import 'package:sgu_schedule/presentation/_base/utils/app_router/route_paths.dart';
import 'package:sgu_schedule/presentation/schedule_timetable_page/cubit/schedule_timetable_cubit.dart';
import 'package:sgu_schedule/presentation/schedule_timetable_page/cubit/schedule_timetable_state.dart';

class ScheduleTimetablePage extends StatelessWidget {
  const ScheduleTimetablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => context.factories.scheduleTimetableCubitFactory.create(),
      child: const _ScheduleTimetableView(),
    );
  }
}

class _ScheduleTimetableView extends StatelessWidget {
  const _ScheduleTimetableView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Расписание'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(RoutePaths.select),
        ),
        actions: [
          BlocBuilder<ScheduleTimetableCubit, ScheduleTimetableState>(
            builder: (context, s) {
              return IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: s.loading
                    ? null
                    : () {
                        context.read<ScheduleTimetableCubit>().load(
                          forceUpdate: true,
                        );
                      },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ScheduleTimetableCubit, ScheduleTimetableState>(
        builder: (context, state) {
          if (state.loading && state.timetable == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.error, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () {
                        context.read<ScheduleTimetableCubit>().load();
                      },
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              ),
            );
          }
          final t = state.timetable;
          if (t == null) {
            return const SizedBox.shrink();
          }
          return _TimetableBody(timetable: t);
        },
      ),
    );
  }
}

class _TimetableBody extends StatelessWidget {
  const _TimetableBody({required this.timetable});

  final ScheduleTimetable timetable;

  @override
  Widget build(BuildContext context) {
    if (timetable.isEmpty) {
      return const Center(child: Text('Нет данных в ответе бека.'));
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final w in timetable.weeks) ...[
          if (w.title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 8),
              child: Text(
                w.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          for (final d in w.days) ...[
            if (d.dateLabel.isNotEmpty)
              Text(
                d.dateLabel,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            for (final slot in d.slots)
              ListTile(
                dense: true,
                title: Text(slot.title),
                subtitle: Text(
                  [
                    if (slot.time.isNotEmpty) slot.time,
                    if (slot.room.isNotEmpty) slot.room,
                  ].join(' · '),
                ),
              ),
            const SizedBox(height: 8),
          ],
        ],
      ],
    );
  }
}
