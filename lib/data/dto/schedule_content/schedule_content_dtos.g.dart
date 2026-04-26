// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_content_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleSlotDto _$ScheduleSlotDtoFromJson(Map<String, dynamic> json) =>
    ScheduleSlotDto(
      time: json['time'] as String? ?? '',
      title: json['title'] as String? ?? '',
      room: json['room'] as String? ?? '',
    );

ScheduleDayDto _$ScheduleDayDtoFromJson(Map<String, dynamic> json) =>
    ScheduleDayDto(
      dateLabel: json['dateLabel'] as String,
      slots: (json['slots'] as List<dynamic>)
          .map((e) => ScheduleSlotDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

ScheduleWeekBlockDto _$ScheduleWeekBlockDtoFromJson(
  Map<String, dynamic> json,
) => ScheduleWeekBlockDto(
  title: json['title'] as String? ?? '',
  days:
      (json['days'] as List<dynamic>?)
          ?.map((e) => ScheduleDayDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ScheduleDayDto>[],
);

ScheduleContentResponseDto _$ScheduleContentResponseDtoFromJson(
  Map<String, dynamic> json,
) => ScheduleContentResponseDto(
  view: json['view'] as String? ?? 'all',
  sourcePath: json['sourcePath'] as String? ?? '',
  weeks:
      (json['weeks'] as List<dynamic>?)
          ?.map((e) => ScheduleWeekBlockDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ScheduleWeekBlockDto>[],
);
