import 'package:json_annotation/json_annotation.dart';

part 'telegram_schedule_binding_dtos.g.dart';

/// Тело POST `/v1/telegram/schedule-selection/query`.
@JsonSerializable(createFactory: false)
class TelegramScheduleSelectionQueryRequestDto {
  const TelegramScheduleSelectionQueryRequestDto({required this.initData});

  final String initData;

  Map<String, dynamic> toJson() =>
      _$TelegramScheduleSelectionQueryRequestDtoToJson(this);
}

/// Поля совпадают с [ScheduleSelectionSnapshot.toJson].
@JsonSerializable()
class ScheduleSelectionSnapshotDto {
  const ScheduleSelectionSnapshotDto({
    this.facultyId = '',
    this.formId = '',
    this.groupId = '',
    this.groupName = '',
    required this.path,
    this.fragment = '',
  });

  factory ScheduleSelectionSnapshotDto.fromJson(Map<String, dynamic> json) =>
      _$ScheduleSelectionSnapshotDtoFromJson(json);

  final String facultyId;
  final String formId;
  final String groupId;
  final String groupName;
  final String path;
  final String fragment;

  Map<String, dynamic> toJson() => _$ScheduleSelectionSnapshotDtoToJson(this);
}

/// Ответ POST query.
@JsonSerializable(createToJson: false)
class TelegramScheduleSelectionQueryResponseDto {
  const TelegramScheduleSelectionQueryResponseDto({
    required this.hasSaved,
    this.selection,
  });

  factory TelegramScheduleSelectionQueryResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$TelegramScheduleSelectionQueryResponseDtoFromJson(json);

  final bool hasSaved;
  final ScheduleSelectionSnapshotDto? selection;
}

/// Тело POST save.
@JsonSerializable(createFactory: false)
class TelegramScheduleSelectionSaveRequestDto {
  const TelegramScheduleSelectionSaveRequestDto({
    required this.initData,
    required this.selection,
  });

  final String initData;
  @JsonKey(toJson: _selectionToMap)
  final ScheduleSelectionSnapshotDto selection;

  static Map<String, dynamic> _selectionToMap(
    ScheduleSelectionSnapshotDto s,
  ) =>
      s.toJson();

  Map<String, dynamic> toJson() =>
      _$TelegramScheduleSelectionSaveRequestDtoToJson(this);
}

/// Ответ POST save.
@JsonSerializable(createToJson: false)
class TelegramScheduleSelectionSaveResponseDto {
  const TelegramScheduleSelectionSaveResponseDto({required this.ok});

  factory TelegramScheduleSelectionSaveResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$TelegramScheduleSelectionSaveResponseDtoFromJson(json);

  final bool ok;
}
