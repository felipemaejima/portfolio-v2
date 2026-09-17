// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'education_dto.freezed.dart';
part 'education_dto.g.dart';

@Freezed()
abstract class EducationDto with _$EducationDto {
  const factory EducationDto({
    required String id,
    required String courseName,
    required String institution,
    required int startYear,

    /// null = em andamento.
    required int? endYear,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _EducationDto;

  factory EducationDto.fromJson(Map<String, Object?> json) =>
      _$EducationDtoFromJson(json);
}
