// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'skill_category_input_dto.freezed.dart';
part 'skill_category_input_dto.g.dart';

@Freezed()
abstract class SkillCategoryInputDto with _$SkillCategoryInputDto {
  const factory SkillCategoryInputDto({
    required String name,
  }) = _SkillCategoryInputDto;
  
  factory SkillCategoryInputDto.fromJson(Map<String, Object?> json) => _$SkillCategoryInputDtoFromJson(json);
}
