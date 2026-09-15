// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_link_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ContactLinkDto _$ContactLinkDtoFromJson(Map<String, dynamic> json) =>
    _ContactLinkDto(
      id: json['id'] as String,
      label: json['label'] as String,
      value: json['value'] as String,
      url: json['url'] as String,
      position: (json['position'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ContactLinkDtoToJson(_ContactLinkDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'value': instance.value,
      'url': instance.url,
      'position': instance.position,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
