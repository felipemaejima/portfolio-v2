// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education_input_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EducationInputDto _$EducationInputDtoFromJson(Map<String, dynamic> json) =>
    _EducationInputDto(
      courseName: json['courseName'] as String,
      institution: json['institution'] as String,
      startYear: (json['startYear'] as num).toInt(),
      endYear: (json['endYear'] as num?)?.toInt(),
    );

Map<String, dynamic> _$EducationInputDtoToJson(_EducationInputDto instance) =>
    <String, dynamic>{
      'courseName': instance.courseName,
      'institution': instance.institution,
      'startYear': instance.startYear,
      'endYear': instance.endYear,
    };
