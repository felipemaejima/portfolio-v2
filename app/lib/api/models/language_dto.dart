// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'language_level.dart';

part 'language_dto.freezed.dart';
part 'language_dto.g.dart';

@Freezed()
abstract class LanguageDto with _$LanguageDto {
  const factory LanguageDto({
    /// Nome do idioma, texto livre em PT-BR.
    required String language,
    required LanguageLevel level,
  }) = _LanguageDto;

  factory LanguageDto.fromJson(Map<String, Object?> json) =>
      _$LanguageDtoFromJson(json);
}
