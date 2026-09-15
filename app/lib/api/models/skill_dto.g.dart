// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SkillDto _$SkillDtoFromJson(Map<String, dynamic> json) => _SkillDto(
  id: json['id'] as String,
  name: json['name'] as String,
  position: (json['position'] as num).toInt(),
  categoryId: json['categoryId'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$SkillDtoToJson(_SkillDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'position': instance.position,
  'categoryId': instance.categoryId,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
