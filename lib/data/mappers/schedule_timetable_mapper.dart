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
    };
  }
}
