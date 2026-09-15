// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'experience_input_dto.freezed.dart';
part 'experience_input_dto.g.dart';

@Freezed()
abstract class ExperienceInputDto with _$ExperienceInputDto {
  const factory ExperienceInputDto({
    required String role,
    required String companyName,

    /// Itens; viram bullets no CV.
    required List<String> activities,

    /// Mês/ano, `YYYY-MM`.
    required String startDate,

    /// Mês/ano, `YYYY-MM`; null = atual.
    String? endDate,
  }) = _ExperienceInputDto;
  
  factory ExperienceInputDto.fromJson(Map<String, Object?> json) => _$ExperienceInputDtoFromJson(json);
}
