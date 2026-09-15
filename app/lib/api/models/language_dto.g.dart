// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LanguageDto _$LanguageDtoFromJson(Map<String, dynamic> json) => _LanguageDto(
  language: json['language'] as String,
  level: LanguageLevel.fromJson(json['level'] as String),
);

Map<String, dynamic> _$LanguageDtoToJson(_LanguageDto instance) =>
    <String, dynamic>{'language': instance.language, 'level': instance.level};
