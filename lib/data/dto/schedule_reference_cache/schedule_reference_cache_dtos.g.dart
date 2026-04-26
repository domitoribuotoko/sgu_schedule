// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_reference_cache_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FacultyCacheItemDto _$FacultyCacheItemDtoFromJson(Map<String, dynamic> json) =>
    FacultyCacheItemDto(
      id: json['id'] as String,
      name: json['name'] as String,
      kind: json['kind'] as String?,
    );

Map<String, dynamic> _$FacultyCacheItemDtoToJson(
  FacultyCacheItemDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'kind': instance.kind,
};

FacultiesCachePayloadDto _$FacultiesCachePayloadDtoFromJson(
  Map<String, dynamic> json,
) => FacultiesCachePayloadDto(
  items: (json['items'] as List<dynamic>)
      .map((e) => FacultyCacheItemDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$FacultiesCachePayloadDtoToJson(
  FacultiesCachePayloadDto instance,
) => <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};

StudyFormCacheItemDto _$StudyFormCacheItemDtoFromJson(
  Map<String, dynamic> json,
) => StudyFormCacheItemDto(
  id: json['id'] as String,
  name: json['name'] as String,
);

Map<String, dynamic> _$StudyFormCacheItemDtoToJson(
  StudyFormCacheItemDto instance,
) => <String, dynamic>{'id': instance.id, 'name': instance.name};

StudyFormsCachePayloadDto _$StudyFormsCachePayloadDtoFromJson(
  Map<String, dynamic> json,
) => StudyFormsCachePayloadDto(
  items: (json['items'] as List<dynamic>)
      .map((e) => StudyFormCacheItemDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$StudyFormsCachePayloadDtoToJson(
  StudyFormsCachePayloadDto instance,
) => <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};

GroupCacheItemDto _$GroupCacheItemDtoFromJson(Map<String, dynamic> json) =>
    GroupCacheItemDto(
      id: json['id'] as String,
      name: json['name'] as String,
      schedulePath: json['schedulePath'] as String,
    );

Map<String, dynamic> _$GroupCacheItemDtoToJson(GroupCacheItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'schedulePath': instance.schedulePath,
    };

GroupsCachePayloadDto _$GroupsCachePayloadDtoFromJson(
  Map<String, dynamic> json,
) => GroupsCachePayloadDto(
  items: (json['items'] as List<dynamic>)
      .map((e) => GroupCacheItemDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GroupsCachePayloadDtoToJson(
  GroupsCachePayloadDto instance,
) => <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};
