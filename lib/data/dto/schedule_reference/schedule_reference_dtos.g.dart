// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_reference_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FacultyItemDto _$FacultyItemDtoFromJson(Map<String, dynamic> json) =>
    FacultyItemDto(
      id: json['id'] as String,
      name: json['name'] as String,
      kind: json['kind'] as String?,
    );

FacultiesListResponseDto _$FacultiesListResponseDtoFromJson(
  Map<String, dynamic> json,
) => FacultiesListResponseDto(
  items: (json['items'] as List<dynamic>)
      .map((e) => FacultyItemDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

StudyFormItemDto _$StudyFormItemDtoFromJson(Map<String, dynamic> json) =>
    StudyFormItemDto(id: json['id'] as String, name: json['name'] as String);

StudyFormsListResponseDto _$StudyFormsListResponseDtoFromJson(
  Map<String, dynamic> json,
) => StudyFormsListResponseDto(
  items: (json['items'] as List<dynamic>)
      .map((e) => StudyFormItemDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

GroupItemDto _$GroupItemDtoFromJson(Map<String, dynamic> json) => GroupItemDto(
  id: json['id'] as String,
  name: json['name'] as String,
  schedulePath: json['schedulePath'] as String,
);

GroupsListResponseDto _$GroupsListResponseDtoFromJson(
  Map<String, dynamic> json,
) => GroupsListResponseDto(
  items: (json['items'] as List<dynamic>)
      .map((e) => GroupItemDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);
