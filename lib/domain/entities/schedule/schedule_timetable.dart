import 'package:equatable/equatable.dart';

class ScheduleSlot extends Equatable {
  const ScheduleSlot({
    this.time = '',
    this.timeStart = '',
    this.timeEnd = '',
    this.title = '',
    this.room = '',
    this.teacher = '',
    this.subgroup = '',
  });

  final String time;
  final String timeStart;
  final String timeEnd;
  final String title;
  final String room;
  final String teacher;
  final String subgroup;

  @override
  List<Object?> get props => [time, timeStart, timeEnd, title, room, teacher, subgroup];
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

class SessionScheduleItem extends Equatable {
  const SessionScheduleItem({
    this.dateTime = '',
    this.form = '',
    this.discipline = '',
    this.teacher = '',
    this.place = '',
  });

  final String dateTime;
  final String form;
  final String discipline;
  final String teacher;
  final String place;

  @override
  List<Object?> get props => [dateTime, form, discipline, teacher, place];
}

class SessionSchedule extends Equatable {
  const SessionSchedule({
    this.title = '',
    this.updatedAt = '',
    this.items = const <SessionScheduleItem>[],
  });

  final String title;
  final String updatedAt;
  final List<SessionScheduleItem> items;

  bool get isEmpty => items.isEmpty;

  @override
  List<Object?> get props => [title, updatedAt, items];
}

/// Снимок JSON расписания для UI.
class ScheduleTimetable extends Equatable {
  const ScheduleTimetable({
    this.view = 'all',
    this.sourcePath = '',
    this.weeks = const <ScheduleWeekBlock>[],
    this.session = const SessionSchedule(),
  });

  final String view;
  final String sourcePath;
  final List<ScheduleWeekBlock> weeks;
  final SessionSchedule session;

  bool get isEmpty => weeks.isEmpty;

  @override
  List<Object?> get props => [view, sourcePath, weeks, session];
}
