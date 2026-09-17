// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_input_dto.freezed.dart';
part 'project_input_dto.g.dart';

@Freezed()
abstract class ProjectInputDto with _$ProjectInputDto {
  const factory ProjectInputDto({
    required String name,

    /// Usada na listagem/cards.
    required String shortDescription,

    /// Usada no detalhe.
    required String fullDescription,
    required List<String> technologies,
    String? codeUrl,
    String? demoUrl,
  }) = _ProjectInputDto;
  
  factory ProjectInputDto.fromJson(Map<String, Object?> json) => _$ProjectInputDtoFromJson(json);
}
