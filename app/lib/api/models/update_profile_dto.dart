// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'availability.dart';
import 'language_dto.dart';
import 'location_dto.dart';
import 'work_mode.dart';

part 'update_profile_dto.freezed.dart';
part 'update_profile_dto.g.dart';

@Freezed()
abstract class UpdateProfileDto with _$UpdateProfileDto {
  const factory UpdateProfileDto({
    required String name,

    /// Uma linha acima do nome no hero.
    required String headline,

    /// Parágrafo curto do hero.
    required String summary,

    /// Texto longo do "Sobre mim"; parágrafos separados por linha em branco.
    required String description,
    required LocationDto location,
    required List<Availability> availability,
    required List<WorkMode> workModes,
    required List<LanguageDto> languages,

    /// Texto de abertura da seção Contato; null = sem texto.
    String? contactIntro,
  }) = _UpdateProfileDto;
  
  factory UpdateProfileDto.fromJson(Map<String, Object?> json) => _$UpdateProfileDtoFromJson(json);
}
