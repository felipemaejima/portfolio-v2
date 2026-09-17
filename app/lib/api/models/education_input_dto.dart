// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'education_input_dto.freezed.dart';
part 'education_input_dto.g.dart';

@Freezed()
abstract class EducationInputDto with _$EducationInputDto {
  const factory EducationInputDto({
    required String courseName,
    required String institution,
    required int startYear,

    /// null = em andamento. Igual a `startYear` → exibe um ano só.
    int? endYear,
  }) = _EducationInputDto;
  
  factory EducationInputDto.fromJson(Map<String, Object?> json) => _$EducationInputDtoFromJson(json);
}
