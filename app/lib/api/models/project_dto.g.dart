// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectDto _$ProjectDtoFromJson(Map<String, dynamic> json) => _ProjectDto(
  id: json['id'] as String,
  name: json['name'] as String,
  slug: json['slug'] as String,
  shortDescription: json['shortDescription'] as String,
  fullDescription: json['fullDescription'] as String,
  technologies: (json['technologies'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  codeUrl: json['codeUrl'] as String?,
  demoUrl: json['demoUrl'] as String?,
  position: (json['position'] as num).toInt(),
  images: (json['images'] as List<dynamic>)
      .map((e) => ProjectImageDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ProjectDtoToJson(_ProjectDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'shortDescription': instance.shortDescription,
      'fullDescription': instance.fullDescription,
      'technologies': instance.technologies,
      'codeUrl': instance.codeUrl,
      'demoUrl': instance.demoUrl,
      'position': instance.position,
      'images': instance.images,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
