// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'offering_dto.freezed.dart';
part 'offering_dto.g.dart';

@Freezed()
abstract class OfferingDto with _$OfferingDto {
  const factory OfferingDto({
    required String id,
    required String title,
    required String description,
    required int position,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _OfferingDto;
  
  factory OfferingDto.fromJson(Map<String, Object?> json) => _$OfferingDtoFromJson(json);
}
