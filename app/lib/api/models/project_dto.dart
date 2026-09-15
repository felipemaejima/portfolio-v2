// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'project_image_dto.dart';

part 'project_dto.freezed.dart';
part 'project_dto.g.dart';

@Freezed()
abstract class ProjectDto with _$ProjectDto {
  const factory ProjectDto({
    required String id,
    required String name,

    /// Identificador público na rota de detalhe; imutável.
    required String slug,
    required String shortDescription,
    required String fullDescription,
    required List<String> technologies,
    required String? codeUrl,
    required String? demoUrl,
    required int position,

    /// Galeria, por `position`. A primeira é a capa.
    required List<ProjectImageDto> images,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ProjectDto;
  
  factory ProjectDto.fromJson(Map<String, Object?> json) => _$ProjectDtoFromJson(json);
}
