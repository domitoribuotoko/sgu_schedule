// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_content_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleSlotDto _$ScheduleSlotDtoFromJson(Map<String, dynamic> json) =>
    ScheduleSlotDto(
      time: json['time'] as String? ?? '',
      timeStart: json['timeStart'] as String? ?? '',
      timeEnd: json['timeEnd'] as String? ?? '',
      title: json['title'] as String? ?? '',
      room: json['room'] as String? ?? '',
      teacher: json['teacher'] as String? ?? '',
      subgroup: json['subgroup'] as String? ?? '',
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

SessionScheduleItemDto _$SessionScheduleItemDtoFromJson(
  Map<String, dynamic> json,
) => SessionScheduleItemDto(
  dateTime: json['dateTime'] as String? ?? '',
  form: json['form'] as String? ?? '',
  discipline: json['discipline'] as String? ?? '',
  teacher: json['teacher'] as String? ?? '',
  place: json['place'] as String? ?? '',
);

SessionScheduleDto _$SessionScheduleDtoFromJson(Map<String, dynamic> json) =>
    SessionScheduleDto(
      title: json['title'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (e) =>
                    SessionScheduleItemDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <SessionScheduleItemDto>[],
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
  session: json['session'] == null
      ? const SessionScheduleDto()
      : SessionScheduleDto.fromJson(json['session'] as Map<String, dynamic>),
);
