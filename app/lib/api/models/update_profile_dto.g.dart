// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateProfileDto _$UpdateProfileDtoFromJson(Map<String, dynamic> json) =>
    _UpdateProfileDto(
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
      contactIntro: json['contactIntro'] as String?,
    );

Map<String, dynamic> _$UpdateProfileDtoToJson(_UpdateProfileDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'headline': instance.headline,
      'summary': instance.summary,
      'description': instance.description,
      'location': instance.location,
      'availability': instance.availability,
      'workModes': instance.workModes,
      'languages': instance.languages,
      'contactIntro': instance.contactIntro,
    };
