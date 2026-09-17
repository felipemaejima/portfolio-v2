// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_link_input_dto.freezed.dart';
part 'contact_link_input_dto.g.dart';

@Freezed()
abstract class ContactLinkInputDto with _$ContactLinkInputDto {
  const factory ContactLinkInputDto({
    /// Nome do canal.
    required String label,

    /// Texto exibido.
    required String value,

    /// Destino abrível pelo app: `https://…`, `mailto:…` ou `tel:…`.
    required String url,
  }) = _ContactLinkInputDto;

  factory ContactLinkInputDto.fromJson(Map<String, Object?> json) =>
      _$ContactLinkInputDtoFromJson(json);
}
