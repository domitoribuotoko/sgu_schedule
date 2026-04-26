import 'package:equatable/equatable.dart';

class ScheduleSlot extends Equatable {
  const ScheduleSlot({
    this.time = '',
    this.title = '',
    this.room = '',
  });

  final String time;
  final String title;
  final String room;

  @override
  List<Object?> get props => [time, title, room];
}

class ScheduleDay extends Equatable {
  const ScheduleDay({required this.dateLabel, this.slots = const <ScheduleSlot>[]});

  final String dateLabel;
  final List<ScheduleSlot> slots;

  @override
  List<Object?> get props => [dateLabel, slots];
}

class ScheduleWeekBlock extends Equatable {
  const ScheduleWeekBlock({this.title = '', this.days = const <ScheduleDay>[]});

  final String title;
  final List<ScheduleDay> days;

  @override
  List<Object?> get props => [title, days];
}

/// Снимок JSON расписания для UI.
class ScheduleTimetable extends Equatable {
  const ScheduleTimetable({
    this.view = 'all',
    this.sourcePath = '',
    this.weeks = const <ScheduleWeekBlock>[],
  });

  final String view;
  final String sourcePath;
  final List<ScheduleWeekBlock> weeks;

  bool get isEmpty => weeks.isEmpty;

  @override
  List<Object?> get props => [view, sourcePath, weeks];
}
