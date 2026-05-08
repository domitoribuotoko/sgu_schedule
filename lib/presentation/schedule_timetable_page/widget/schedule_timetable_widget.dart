import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sgu_schedule/domain/entities/schedule/schedule_timetable.dart';
import 'package:sgu_schedule/presentation/_base/utils/app_router/route_paths.dart';
import 'package:sgu_schedule/presentation/_base/widgets/bloc_wrappers/bloc_multi_selector.dart';
import 'package:sgu_schedule/presentation/schedule_timetable_page/cubit/schedule_timetable_cubit.dart';
import 'package:sgu_schedule/presentation/schedule_timetable_page/cubit/schedule_timetable_state.dart';

class ScheduleTimetableWidget extends StatelessWidget {
  const ScheduleTimetableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Расписание'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(RoutePaths.select),
        ),
        actions: const [_RefreshActionBuilder()],
      ),
      body: const _TimetableBodyBuilder(),
    );
  }
}

class _ScheduleTimetableBlocBuilder extends StatelessWidget {
  const _ScheduleTimetableBlocBuilder({
    required this.selectors,
    required this.builder,
  });

  final List<dynamic> Function(ScheduleTimetableState state) selectors;
  final Widget Function(
    ScheduleTimetableCubit cubit,
    ScheduleTimetableState state,
  )
  builder;

  @override
  Widget build(BuildContext context) {
    return BlocMultiSelector<ScheduleTimetableCubit, ScheduleTimetableState>(
      selectors: selectors,
      cubitBuilder: (context, cubit, state) => builder(cubit, state),
    );
  }
}

class _RefreshActionBuilder extends StatelessWidget {
  const _RefreshActionBuilder();

  @override
  Widget build(BuildContext context) {
    return _ScheduleTimetableBlocBuilder(
      selectors: (s) => [s.loading],
      builder: (cubit, s) {
        return IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: s.loading ? null : () => cubit.load(forceUpdate: true),
        );
      },
    );
  }
}

class _TimetableBodyBuilder extends StatelessWidget {
  const _TimetableBodyBuilder();

  @override
  Widget build(BuildContext context) {
    return _ScheduleTimetableBlocBuilder(
      selectors: (s) => [s.loading, s.error, s.timetable],
      builder: (cubit, state) {
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
                    onPressed: cubit.load,
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
    );
  }
}

class _TimetableBody extends StatelessWidget {
  const _TimetableBody({required this.timetable});

  final ScheduleTimetable timetable;

  @override
  Widget build(BuildContext context) {
    final hasLessons = timetable.weeks.isNotEmpty;
    final hasSession = timetable.session.items.isNotEmpty;
    if (!hasLessons && !hasSession) {
      return const Center(child: Text('Нет данных в ответе бека.'));
    }
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Занятия'),
              Tab(text: 'Сессия'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _LessonsTab(weeks: timetable.weeks),
                _SessionTab(session: timetable.session),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonsTab extends StatelessWidget {
  const _LessonsTab({required this.weeks});

  final List<ScheduleWeekBlock> weeks;

  @override
  Widget build(BuildContext context) {
    if (weeks.isEmpty) {
      return const Center(child: Text('Нет данных расписания занятий.'));
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final w in weeks) ...[
          if (_shouldShowWeekTitle(w.title))
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 8),
              child: Text(
                w.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          for (var di = 0; di < w.days.length; di++) ...[
            if (w.days[di].dateLabel.isNotEmpty)
              _DayExpansionTile(
                day: w.days[di],
                initiallyExpanded: _initialExpandedIndexForWeek(w.days) == di,
              ),
          ],
        ],
      ],
    );
  }
}

class _SessionTab extends StatelessWidget {
  const _SessionTab({required this.session});

  final SessionSchedule session;

  @override
  Widget build(BuildContext context) {
    if (session.isEmpty) {
      return const Center(child: Text('Нет данных расписания сессии.'));
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (session.title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              session.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        if (session.updatedAt.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              session.updatedAt,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        for (final item in session.items)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.dateTime.isNotEmpty)
                    Text(
                      item.dateTime,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  if (item.form.isNotEmpty || item.discipline.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        [
                          if (item.form.isNotEmpty) item.form,
                          if (item.discipline.isNotEmpty) item.discipline,
                        ].join(' · '),
                      ),
                    ),
                  if (item.teacher.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text('Преподаватель: ${item.teacher}'),
                    ),
                  if (item.place.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text('Место: ${item.place}'),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

bool _shouldShowWeekTitle(String title) {
  final t = title.trim().toLowerCase();
  if (t.isEmpty) {
    return false;
  }
  if (t == 'header menu' || t == 'menu') {
    return false;
  }
  return true;
}

int _firstIndexWithSlots(List<ScheduleDay> days) {
  for (var i = 0; i < days.length; i++) {
    if (days[i].slots.isNotEmpty) {
      return i;
    }
  }
  return -1;
}

int _initialExpandedIndexForWeek(List<ScheduleDay> days) {
  final todayWeekday = DateTime.now().weekday;
  for (var i = 0; i < days.length; i++) {
    if (days[i].slots.isEmpty) {
      continue;
    }
    if (_weekdayFromLabel(days[i].dateLabel) == todayWeekday) {
      return i;
    }
  }
  return _firstIndexWithSlots(days);
}

int? _weekdayFromLabel(String label) {
  final s = label.trim().toLowerCase();
  if (s.startsWith('пн') || s.contains('понедель')) {
    return DateTime.monday;
  }
  if (s.startsWith('вт') || s.contains('вторник')) {
    return DateTime.tuesday;
  }
  if (s.startsWith('ср') || s.contains('сред')) {
    return DateTime.wednesday;
  }
  if (s.startsWith('чт') || s.contains('четвер')) {
    return DateTime.thursday;
  }
  if (s.startsWith('пт') || s.contains('пятниц')) {
    return DateTime.friday;
  }
  if (s.startsWith('сб') || s.contains('суббот')) {
    return DateTime.saturday;
  }
  if (s.startsWith('вс') || s.contains('воскрес')) {
    return DateTime.sunday;
  }
  return null;
}

class _DayExpansionTile extends StatelessWidget {
  const _DayExpansionTile({
    required this.day,
    required this.initiallyExpanded,
  });

  final ScheduleDay day;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ExpansionTile(
        key: PageStorageKey('day_${day.dateLabel}'),
        initiallyExpanded: initiallyExpanded,
        enabled: day.slots.isNotEmpty,
        title: Text(day.dateLabel),
        subtitle: day.slots.isEmpty
            ? const Text('Нет пар', style: TextStyle(fontSize: 13))
            : null,
        trailing: day.slots.isEmpty ? const SizedBox.shrink() : null,
        children: [
          for (final slot in day.slots)
            ListTile(
              dense: true,
              title: Text(slot.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (slot.timeStart.isNotEmpty || slot.timeEnd.isNotEmpty)
                    Text(
                      [
                        if (slot.timeStart.isNotEmpty) slot.timeStart,
                        if (slot.timeEnd.isNotEmpty) slot.timeEnd,
                      ].join('\n'),
                    )
                  else if (slot.time.isNotEmpty)
                    Text(slot.time),
                  if (slot.teacher.isNotEmpty) Text(slot.teacher),
                  if (slot.subgroup.isNotEmpty) Text(slot.subgroup),
                  if (slot.room.isNotEmpty) Text(slot.room),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
