// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_link_input_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ContactLinkInputDto _$ContactLinkInputDtoFromJson(Map<String, dynamic> json) =>
    _ContactLinkInputDto(
      label: json['label'] as String,
      value: json['value'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$ContactLinkInputDtoToJson(
  _ContactLinkInputDto instance,
) => <String, dynamic>{
  'label': instance.label,
  'value': instance.value,
  'url': instance.url,
};
