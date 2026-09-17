// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'availability.dart';
import 'language_dto.dart';
import 'location_dto.dart';
import 'work_mode.dart';

part 'profile_dto.freezed.dart';
part 'profile_dto.g.dart';

@Freezed()
abstract class ProfileDto with _$ProfileDto {
  const factory ProfileDto({
    required String id,
    required String name,
    required String headline,
    required String summary,
    required String description,

    /// Texto de abertura da seção Contato, ou null.
    required String? contactIntro,
    required LocationDto location,
    required List<Availability> availability,
    required List<WorkMode> workModes,
    required List<LanguageDto> languages,

    /// URL pública permanente da foto, ou null.
    required String? imageUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ProfileDto;
  
  factory ProfileDto.fromJson(Map<String, Object?> json) => _$ProfileDtoFromJson(json);
}
