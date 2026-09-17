// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'skill_dto.freezed.dart';
part 'skill_dto.g.dart';

@Freezed()
abstract class SkillDto with _$SkillDto {
  const factory SkillDto({
    required String id,
    required String name,

    /// Posição dentro da categoria.
    required int position,
    required String categoryId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SkillDto;

  factory SkillDto.fromJson(Map<String, Object?> json) =>
      _$SkillDtoFromJson(json);
}
