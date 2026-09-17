// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'offering_input_dto.freezed.dart';
part 'offering_input_dto.g.dart';

@Freezed()
abstract class OfferingInputDto with _$OfferingInputDto {
  const factory OfferingInputDto({
    required String title,
    required String description,
  }) = _OfferingInputDto;

  factory OfferingInputDto.fromJson(Map<String, Object?> json) =>
      _$OfferingInputDtoFromJson(json);
}
