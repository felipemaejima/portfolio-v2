// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_contact_message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateContactMessageDto _$CreateContactMessageDtoFromJson(
  Map<String, dynamic> json,
) => _CreateContactMessageDto(
  name: json['name'] as String,
  email: json['email'] as String,
  message: json['message'] as String,
);

Map<String, dynamic> _$CreateContactMessageDtoToJson(
  _CreateContactMessageDto instance,
) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'message': instance.message,
};
