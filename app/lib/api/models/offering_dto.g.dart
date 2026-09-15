// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offering_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OfferingDto _$OfferingDtoFromJson(Map<String, dynamic> json) => _OfferingDto(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  position: (json['position'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$OfferingDtoToJson(_OfferingDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'position': instance.position,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
