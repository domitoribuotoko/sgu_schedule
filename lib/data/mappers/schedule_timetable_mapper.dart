import 'package:sgu_schedule/data/dto/schedule_content/schedule_content_dtos.dart';
import 'package:sgu_schedule/domain/entities/schedule/schedule_timetable.dart';

abstract final class ScheduleTimetableMapper {
  static ScheduleTimetable fromDto(ScheduleContentResponseDto d) {
    return ScheduleTimetable(
      view: d.view,
      sourcePath: d.sourcePath,
      weeks: d.weeks
          .map(
            (w) => ScheduleWeekBlock(
              title: w.title,
              days: w.days
                  .map(
                    (day) => ScheduleDay(
                      dateLabel: day.dateLabel,
                      slots: day.slots
                          .map(
                            (s) => ScheduleSlot(
                              time: s.time,
                              title: s.title,
                              room: s.room,
                            ),
                          )
                          .toList(),
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
      session: SessionSchedule(
        title: d.session.title,
        updatedAt: d.session.updatedAt,
        items: d.session.items
            .map(
              (it) => SessionScheduleItem(
                dateTime: it.dateTime,
                form: it.form,
                discipline: it.discipline,
                teacher: it.teacher,
                place: it.place,
              ),
            )
            .toList(),
      ),
    );
  }

  static Map<String, dynamic> toJsonMap(ScheduleTimetable t) {
    return {
      'view': t.view,
      'sourcePath': t.sourcePath,
      'weeks': t.weeks
          .map(
            (w) => {
              'title': w.title,
              'days': w.days
                  .map(
                    (d) => {
                      'dateLabel': d.dateLabel,
                      'slots': d.slots
                          .map(
                            (s) => {
                              'time': s.time,
                              'title': s.title,
                              'room': s.room,
                            },
                          )
                          .toList(),
                    },
                  )
                  .toList(),
            },
          )
          .toList(),
      'session': {
        'title': t.session.title,
        'updatedAt': t.session.updatedAt,
        'items': t.session.items
            .map(
              (it) => {
                'dateTime': it.dateTime,
                'form': it.form,
                'discipline': it.discipline,
                'teacher': it.teacher,
                'place': it.place,
              },
            )
            .toList(),
      },
    };
  }
}
