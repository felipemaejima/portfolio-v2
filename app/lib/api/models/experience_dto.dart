// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'experience_dto.freezed.dart';
part 'experience_dto.g.dart';

@Freezed()
abstract class ExperienceDto with _$ExperienceDto {
  const factory ExperienceDto({
    required String id,
    required String role,
    required String companyName,
    required List<String> activities,

    /// `YYYY-MM`
    required String startDate,

    /// `YYYY-MM`; null = atual.
    required String? endDate,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ExperienceDto;

  factory ExperienceDto.fromJson(Map<String, Object?> json) =>
      _$ExperienceDtoFromJson(json);
}
