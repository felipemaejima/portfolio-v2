// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_tokens_dto.freezed.dart';
part 'auth_tokens_dto.g.dart';

@Freezed()
abstract class AuthTokensDto with _$AuthTokensDto {
  const factory AuthTokensDto({
    required String accessToken,

    /// Segundos até o access token expirar.
    required int expiresIn,

    /// Presente só para MOBILE; no WEB o refresh viaja em cookie httpOnly.
    String? refreshToken,
  }) = _AuthTokensDto;
  
  factory AuthTokensDto.fromJson(Map<String, Object?> json) => _$AuthTokensDtoFromJson(json);
}
