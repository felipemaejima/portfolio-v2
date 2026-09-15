// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experience_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExperienceDto _$ExperienceDtoFromJson(Map<String, dynamic> json) =>
    _ExperienceDto(
      id: json['id'] as String,
      role: json['role'] as String,
      companyName: json['companyName'] as String,
      activities: (json['activities'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ExperienceDtoToJson(_ExperienceDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': instance.role,
      'companyName': instance.companyName,
      'activities': instance.activities,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
