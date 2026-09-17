// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_contact_message_dto.freezed.dart';
part 'create_contact_message_dto.g.dart';

@Freezed()
abstract class CreateContactMessageDto with _$CreateContactMessageDto {
  const factory CreateContactMessageDto({
    required String name,
    required String email,
    required String message,
  }) = _CreateContactMessageDto;

  factory CreateContactMessageDto.fromJson(Map<String, Object?> json) =>
      _$CreateContactMessageDtoFromJson(json);
}
