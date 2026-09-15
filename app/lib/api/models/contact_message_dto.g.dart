// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ContactMessageDto _$ContactMessageDtoFromJson(Map<String, dynamic> json) =>
    _ContactMessageDto(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      message: json['message'] as String,
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ContactMessageDtoToJson(_ContactMessageDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'message': instance.message,
      'readAt': instance.readAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
