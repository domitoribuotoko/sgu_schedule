import 'package:json_annotation/json_annotation.dart';

part 'schedule_reference_dtos.g.dart';

/// Элемент: подразделение (факультет / институт / пр.).
@JsonSerializable(createToJson: false)
class FacultyItemDto {
  const FacultyItemDto({
    required this.id,
    required this.name,
    this.kind,
  });

  factory FacultyItemDto.fromJson(Map<String, dynamic> json) =>
      _$FacultyItemDtoFromJson(json);

  final String id;
  final String name;
  final String? kind;
}

/// Ответ: `GET /v1/schedule/faculties`
@JsonSerializable(createToJson: false)
class FacultiesListResponseDto {
  const FacultiesListResponseDto({required this.items});

  factory FacultiesListResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FacultiesListResponseDtoFromJson(json);

  final List<FacultyItemDto> items;
}

/// Форма обучения.
@JsonSerializable(createToJson: false)
class StudyFormItemDto {
  const StudyFormItemDto({
    required this.id,
    required this.name,
  });

  factory StudyFormItemDto.fromJson(Map<String, dynamic> json) =>
      _$StudyFormItemDtoFromJson(json);

  final String id;
  final String name;
}

/// Ответ: `GET /v1/schedule/faculties/{id}/study-forms`
@JsonSerializable(createToJson: false)
class StudyFormsListResponseDto {
  const StudyFormsListResponseDto({required this.items});

  factory StudyFormsListResponseDto.fromJson(Map<String, dynamic> json) =>
      _$StudyFormsListResponseDtoFromJson(json);

  final List<StudyFormItemDto> items;
}

/// Группа + путь расписания (как на сайте).
@JsonSerializable(createToJson: false)
class GroupItemDto {
  const GroupItemDto({
    required this.id,
    required this.name,
    required this.schedulePath,
  });

  factory GroupItemDto.fromJson(Map<String, dynamic> json) =>
      _$GroupItemDtoFromJson(json);

  final String id;
  final String name;
  final String schedulePath;
}

/// Ответ: `GET /v1/schedule/faculties/{f}/study-forms/{g}/groups`
@JsonSerializable(createToJson: false)
class GroupsListResponseDto {
  const GroupsListResponseDto({required this.items});

  factory GroupsListResponseDto.fromJson(Map<String, dynamic> json) =>
      _$GroupsListResponseDtoFromJson(json);

  final List<GroupItemDto> items;
}
