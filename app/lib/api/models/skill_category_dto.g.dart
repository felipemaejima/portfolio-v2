// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill_category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SkillCategoryDto _$SkillCategoryDtoFromJson(Map<String, dynamic> json) =>
    _SkillCategoryDto(
      id: json['id'] as String,
      name: json['name'] as String,
      position: (json['position'] as num).toInt(),
      skills: (json['skills'] as List<dynamic>)
          .map((e) => SkillDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$SkillCategoryDtoToJson(_SkillCategoryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'position': instance.position,
      'skills': instance.skills,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
