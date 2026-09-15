// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_skill_dto.freezed.dart';
part 'update_skill_dto.g.dart';

@Freezed()
abstract class UpdateSkillDto with _$UpdateSkillDto {
  const factory UpdateSkillDto({
    required String name,
    required String categoryId,
  }) = _UpdateSkillDto;
  
  factory UpdateSkillDto.fromJson(Map<String, Object?> json) => _$UpdateSkillDtoFromJson(json);
}
