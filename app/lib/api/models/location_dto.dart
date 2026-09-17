// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_dto.freezed.dart';
part 'location_dto.g.dart';

@Freezed()
abstract class LocationDto with _$LocationDto {
  const factory LocationDto({
    required String city,
    required String state,
    required String country,
  }) = _LocationDto;

  factory LocationDto.fromJson(Map<String, Object?> json) =>
      _$LocationDtoFromJson(json);
}
