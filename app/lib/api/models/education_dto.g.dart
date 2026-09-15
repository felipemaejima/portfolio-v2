// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EducationDto _$EducationDtoFromJson(Map<String, dynamic> json) =>
    _EducationDto(
      id: json['id'] as String,
      courseName: json['courseName'] as String,
      institution: json['institution'] as String,
      startYear: (json['startYear'] as num).toInt(),
      endYear: (json['endYear'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$EducationDtoToJson(_EducationDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courseName': instance.courseName,
      'institution': instance.institution,
      'startYear': instance.startYear,
      'endYear': instance.endYear,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
