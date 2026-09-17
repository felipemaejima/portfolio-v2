// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'reorder_dto.freezed.dart';
part 'reorder_dto.g.dart';

@Freezed()
abstract class ReorderDto with _$ReorderDto {
  const factory ReorderDto({required List<String> ids}) = _ReorderDto;

  factory ReorderDto.fromJson(Map<String, Object?> json) =>
      _$ReorderDtoFromJson(json);
}
