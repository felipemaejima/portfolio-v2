// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_dto.freezed.dart';
part 'admin_dto.g.dart';

@Freezed()
abstract class AdminDto with _$AdminDto {
  const factory AdminDto({
    required String id,
    required String email,
  }) = _AdminDto;
  
  factory AdminDto.fromJson(Map<String, Object?> json) => _$AdminDtoFromJson(json);
}
