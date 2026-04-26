import 'package:json_annotation/json_annotation.dart';

part 'schedule_reference_cache_dtos.g.dart';

/// Элемент списка факультетов в JSON колонке Drift.
@JsonSerializable()
class FacultyCacheItemDto {
  const FacultyCacheItemDto({
    required this.id,
    required this.name,
    this.kind,
  });

  factory FacultyCacheItemDto.fromJson(Map<String, dynamic> json) =>
      _$FacultyCacheItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FacultyCacheItemDtoToJson(this);

  final String id;
  final String name;
  final String? kind;
}

/// Обёртка для сериализации бакета факультетов.
@JsonSerializable(explicitToJson: true)
class FacultiesCachePayloadDto {
  const FacultiesCachePayloadDto({required this.items});

  factory FacultiesCachePayloadDto.fromJson(Map<String, dynamic> json) =>
      _$FacultiesCachePayloadDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FacultiesCachePayloadDtoToJson(this);

  final List<FacultyCacheItemDto> items;
}

@JsonSerializable()
class StudyFormCacheItemDto {
  const StudyFormCacheItemDto({
    required this.id,
    required this.name,
  });

  factory StudyFormCacheItemDto.fromJson(Map<String, dynamic> json) =>
      _$StudyFormCacheItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StudyFormCacheItemDtoToJson(this);

  final String id;
  final String name;
}

@JsonSerializable(explicitToJson: true)
class StudyFormsCachePayloadDto {
  const StudyFormsCachePayloadDto({required this.items});

  factory StudyFormsCachePayloadDto.fromJson(Map<String, dynamic> json) =>
      _$StudyFormsCachePayloadDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StudyFormsCachePayloadDtoToJson(this);

  final List<StudyFormCacheItemDto> items;
}

@JsonSerializable()
class GroupCacheItemDto {
  const GroupCacheItemDto({
    required this.id,
    required this.name,
    required this.schedulePath,
  });

  factory GroupCacheItemDto.fromJson(Map<String, dynamic> json) =>
      _$GroupCacheItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GroupCacheItemDtoToJson(this);

  final String id;
  final String name;
  final String schedulePath;
}

@JsonSerializable(explicitToJson: true)
class GroupsCachePayloadDto {
  const GroupsCachePayloadDto({required this.items});

  factory GroupsCachePayloadDto.fromJson(Map<String, dynamic> json) =>
      _$GroupsCachePayloadDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GroupsCachePayloadDtoToJson(this);

  final List<GroupCacheItemDto> items;
}
