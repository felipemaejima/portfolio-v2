// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'client_platform.dart';

part 'login_dto.freezed.dart';
part 'login_dto.g.dart';

@Freezed()
abstract class LoginDto with _$LoginDto {
  const factory LoginDto({
    required String email,
    required String password,

    /// WEB → refresh em cookie httpOnly; MOBILE → refresh no body.
    required ClientPlatform clientPlatform,
  }) = _LoginDto;

  factory LoginDto.fromJson(Map<String, Object?> json) =>
      _$LoginDtoFromJson(json);
}
