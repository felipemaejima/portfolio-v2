// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileDto _$ProfileDtoFromJson(Map<String, dynamic> json) => _ProfileDto(
  id: json['id'] as String,
  name: json['name'] as String,
  headline: json['headline'] as String,
  summary: json['summary'] as String,
  description: json['description'] as String,
  location: LocationDto.fromJson(json['location'] as Map<String, dynamic>),
  availability: (json['availability'] as List<dynamic>)
      .map((e) => Availability.fromJson(e as String))
      .toList(),
  workModes: (json['workModes'] as List<dynamic>)
      .map((e) => WorkMode.fromJson(e as String))
      .toList(),
  languages: (json['languages'] as List<dynamic>)
      .map((e) => LanguageDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  imageUrl: json['imageUrl'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ProfileDtoToJson(_ProfileDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'headline': instance.headline,
      'summary': instance.summary,
      'description': instance.description,
      'location': instance.location,
      'availability': instance.availability,
      'workModes': instance.workModes,
      'languages': instance.languages,
      'imageUrl': instance.imageUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
