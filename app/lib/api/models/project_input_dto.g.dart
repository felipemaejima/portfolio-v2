// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_input_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectInputDto _$ProjectInputDtoFromJson(Map<String, dynamic> json) =>
    _ProjectInputDto(
      name: json['name'] as String,
      shortDescription: json['shortDescription'] as String,
      fullDescription: json['fullDescription'] as String,
      technologies: (json['technologies'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      codeUrl: json['codeUrl'] as String?,
      demoUrl: json['demoUrl'] as String?,
    );

Map<String, dynamic> _$ProjectInputDtoToJson(_ProjectInputDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'shortDescription': instance.shortDescription,
      'fullDescription': instance.fullDescription,
      'technologies': instance.technologies,
      'codeUrl': instance.codeUrl,
      'demoUrl': instance.demoUrl,
    };
