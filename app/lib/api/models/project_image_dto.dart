// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_image_dto.freezed.dart';
part 'project_image_dto.g.dart';

@Freezed()
abstract class ProjectImageDto with _$ProjectImageDto {
  const factory ProjectImageDto({
    required String id,

    /// URL pública permanente.
    required String url,
    required int position,
  }) = _ProjectImageDto;
  
  factory ProjectImageDto.fromJson(Map<String, Object?> json) => _$ProjectImageDtoFromJson(json);
}
