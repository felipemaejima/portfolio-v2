// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experience_input_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExperienceInputDto _$ExperienceInputDtoFromJson(Map<String, dynamic> json) =>
    _ExperienceInputDto(
      role: json['role'] as String,
      companyName: json['companyName'] as String,
      activities: (json['activities'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String?,
    );

Map<String, dynamic> _$ExperienceInputDtoToJson(_ExperienceInputDto instance) =>
    <String, dynamic>{
      'role': instance.role,
      'companyName': instance.companyName,
      'activities': instance.activities,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
    };
