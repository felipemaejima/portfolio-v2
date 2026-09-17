// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'error_code.dart';

part 'error_response_dto.freezed.dart';
part 'error_response_dto.g.dart';

@Freezed()
abstract class ErrorResponseDto with _$ErrorResponseDto {
  const factory ErrorResponseDto({
    required int statusCode,
    required ErrorCode code,

    /// Texto exibível, em PT-BR.
    required String message,

    /// Só em VALIDATION_FAILED: mensagens por campo.
    Map<String, List<String>>? details,
  }) = _ErrorResponseDto;
  
  factory ErrorResponseDto.fromJson(Map<String, Object?> json) => _$ErrorResponseDtoFromJson(json);
}
