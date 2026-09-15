// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_image_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectImageDto _$ProjectImageDtoFromJson(Map<String, dynamic> json) =>
    _ProjectImageDto(
      id: json['id'] as String,
      url: json['url'] as String,
      position: (json['position'] as num).toInt(),
    );

Map<String, dynamic> _$ProjectImageDtoToJson(_ProjectImageDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'position': instance.position,
    };
