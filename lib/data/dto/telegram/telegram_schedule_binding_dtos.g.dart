// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telegram_schedule_binding_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$TelegramScheduleSelectionQueryRequestDtoToJson(
  TelegramScheduleSelectionQueryRequestDto instance,
) => <String, dynamic>{'initData': instance.initData};

ScheduleSelectionSnapshotDto _$ScheduleSelectionSnapshotDtoFromJson(
  Map<String, dynamic> json,
) => ScheduleSelectionSnapshotDto(
  facultyId: json['facultyId'] as String? ?? '',
  formId: json['formId'] as String? ?? '',
  groupId: json['groupId'] as String? ?? '',
  groupName: json['groupName'] as String? ?? '',
  path: json['path'] as String,
  fragment: json['fragment'] as String? ?? '',
);

Map<String, dynamic> _$ScheduleSelectionSnapshotDtoToJson(
  ScheduleSelectionSnapshotDto instance,
) => <String, dynamic>{
  'facultyId': instance.facultyId,
  'formId': instance.formId,
  'groupId': instance.groupId,
  'groupName': instance.groupName,
  'path': instance.path,
  'fragment': instance.fragment,
};

TelegramScheduleSelectionQueryResponseDto
_$TelegramScheduleSelectionQueryResponseDtoFromJson(
  Map<String, dynamic> json,
) => TelegramScheduleSelectionQueryResponseDto(
  hasSaved: json['hasSaved'] as bool,
  selection: json['selection'] == null
      ? null
      : ScheduleSelectionSnapshotDto.fromJson(
          json['selection'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$TelegramScheduleSelectionSaveRequestDtoToJson(
  TelegramScheduleSelectionSaveRequestDto instance,
) => <String, dynamic>{
  'initData': instance.initData,
  'selection': TelegramScheduleSelectionSaveRequestDto._selectionToMap(
    instance.selection,
  ),
};

TelegramScheduleSelectionSaveResponseDto
_$TelegramScheduleSelectionSaveResponseDtoFromJson(Map<String, dynamic> json) =>
    TelegramScheduleSelectionSaveResponseDto(ok: json['ok'] as bool);
