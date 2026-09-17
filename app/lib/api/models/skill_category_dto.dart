// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'skill_dto.dart';

part 'skill_category_dto.freezed.dart';
part 'skill_category_dto.g.dart';

@Freezed()
abstract class SkillCategoryDto with _$SkillCategoryDto {
  const factory SkillCategoryDto({
    required String id,
    required String name,
    required int position,

    /// Por `position`.
    required List<SkillDto> skills,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SkillCategoryDto;

  factory SkillCategoryDto.fromJson(Map<String, Object?> json) =>
      _$SkillCategoryDtoFromJson(json);
}
