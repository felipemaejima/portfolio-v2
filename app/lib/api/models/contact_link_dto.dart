// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_link_dto.freezed.dart';
part 'contact_link_dto.g.dart';

@Freezed()
abstract class ContactLinkDto with _$ContactLinkDto {
  const factory ContactLinkDto({
    required String id,
    required String label,
    required String value,
    required String url,
    required int position,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ContactLinkDto;

  factory ContactLinkDto.fromJson(Map<String, Object?> json) =>
      _$ContactLinkDtoFromJson(json);
}
