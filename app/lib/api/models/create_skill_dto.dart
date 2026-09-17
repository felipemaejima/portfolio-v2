// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_skill_dto.freezed.dart';
part 'create_skill_dto.g.dart';

@Freezed()
abstract class CreateSkillDto with _$CreateSkillDto {
  const factory CreateSkillDto({required String name}) = _CreateSkillDto;

  factory CreateSkillDto.fromJson(Map<String, Object?> json) =>
      _$CreateSkillDtoFromJson(json);
}
