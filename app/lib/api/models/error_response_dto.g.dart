// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ErrorResponseDto _$ErrorResponseDtoFromJson(Map<String, dynamic> json) =>
    _ErrorResponseDto(
      statusCode: (json['statusCode'] as num).toInt(),
      code: ErrorCode.fromJson(json['code'] as String),
      message: json['message'] as String,
      details: (json['details'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ),
    );

Map<String, dynamic> _$ErrorResponseDtoToJson(_ErrorResponseDto instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'code': instance.code,
      'message': instance.message,
      'details': instance.details,
    };
