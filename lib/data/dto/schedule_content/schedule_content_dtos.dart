import 'package:json_annotation/json_annotation.dart';

part 'schedule_content_dtos.g.dart';

/// Слот пары/занятия (фрагмент с сайта, разобранный беком).
@JsonSerializable(createToJson: false)
class ScheduleSlotDto {
  const ScheduleSlotDto({
    this.time = '',
    this.title = '',
    this.room = '',
  });

  factory ScheduleSlotDto.fromJson(Map<String, dynamic> json) =>
      _$ScheduleSlotDtoFromJson(json);

  final String time;
  final String title;
  final String room;
}

/// Один день в блоке «неделя».
@JsonSerializable(createToJson: false)
class ScheduleDayDto {
  const ScheduleDayDto({required this.dateLabel, required this.slots});

  factory ScheduleDayDto.fromJson(Map<String, dynamic> json) =>
      _$ScheduleDayDtoFromJson(json);

  final String dateLabel;
  final List<ScheduleSlotDto> slots;
}

/// Блок (например, верх/нижнеделка) — согласно парсеру [test_schedule] / [test_session].
@JsonSerializable(createToJson: false)
class ScheduleWeekBlockDto {
  const ScheduleWeekBlockDto({this.title = '', this.days = const <ScheduleDayDto>[]});

  factory ScheduleWeekBlockDto.fromJson(Map<String, dynamic> json) =>
      _$ScheduleWeekBlockDtoFromJson(json);

  final String title;
  final List<ScheduleDayDto> days;
}

/// Ответ: `GET /v1/schedule/content?path=…&view=…`
/// Бек: HTTP к `https://www.sgu.ru/…` + HTML-парсинг. Подробности — [docs/schedule_content_api.md].
@JsonSerializable(createToJson: false)
class ScheduleContentResponseDto {
  const ScheduleContentResponseDto({
    this.view = 'all',
    this.sourcePath = '',
    this.weeks = const <ScheduleWeekBlockDto>[],
  });

  factory ScheduleContentResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ScheduleContentResponseDtoFromJson(json);

  final String view;
  final String sourcePath;
  final List<ScheduleWeekBlockDto> weeks;
}
