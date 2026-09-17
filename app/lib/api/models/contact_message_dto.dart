// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_message_dto.freezed.dart';
part 'contact_message_dto.g.dart';

@Freezed()
abstract class ContactMessageDto with _$ContactMessageDto {
  const factory ContactMessageDto({
    required String id,
    required String name,
    required String email,
    required String message,

    /// null = não lida.
    required DateTime? readAt,
    required DateTime createdAt,
  }) = _ContactMessageDto;

  factory ContactMessageDto.fromJson(Map<String, Object?> json) =>
      _$ContactMessageDtoFromJson(json);
}
