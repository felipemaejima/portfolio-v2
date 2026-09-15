// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_link_input_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContactLinkInputDto {

/// Nome do canal.
 String get label;/// Texto exibido.
 String get value;/// Destino abrível pelo app: `https://…`, `mailto:…` ou `tel:…`.
 String get url;
/// Create a copy of ContactLinkInputDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactLinkInputDtoCopyWith<ContactLinkInputDto> get copyWith => _$ContactLinkInputDtoCopyWithImpl<ContactLinkInputDto>(this as ContactLinkInputDto, _$identity);

  /// Serializes this ContactLinkInputDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactLinkInputDto&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,value,url);

@override
String toString() {
  return 'ContactLinkInputDto(label: $label, value: $value, url: $url)';
}


}

/// @nodoc
abstract mixin class $ContactLinkInputDtoCopyWith<$Res>  {
  factory $ContactLinkInputDtoCopyWith(ContactLinkInputDto value, $Res Function(ContactLinkInputDto) _then) = _$ContactLinkInputDtoCopyWithImpl;
@useResult
$Res call({
 String label, String value, String url
});




}
/// @nodoc
class _$ContactLinkInputDtoCopyWithImpl<$Res>
    implements $ContactLinkInputDtoCopyWith<$Res> {
  _$ContactLinkInputDtoCopyWithImpl(this._self, this._then);

  final ContactLinkInputDto _self;
  final $Res Function(ContactLinkInputDto) _then;

/// Create a copy of ContactLinkInputDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? value = null,Object? url = null,}) {
  return _then(ContactLinkInputDto(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ContactLinkInputDto].
extension ContactLinkInputDtoPatterns on ContactLinkInputDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactLinkInputDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactLinkInputDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactLinkInputDto value)  $default,){
final _that = this;
switch (_that) {
case _ContactLinkInputDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactLinkInputDto value)?  $default,){
final _that = this;
switch (_that) {
case _ContactLinkInputDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  String value,  String url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactLinkInputDto() when $default != null:
return $default(_that.label,_that.value,_that.url);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  String value,  String url)  $default,) {final _that = this;
switch (_that) {
case _ContactLinkInputDto():
return $default(_that.label,_that.value,_that.url);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  String value,  String url)?  $default,) {final _that = this;
switch (_that) {
case _ContactLinkInputDto() when $default != null:
return $default(_that.label,_that.value,_that.url);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContactLinkInputDto implements ContactLinkInputDto {
  const _ContactLinkInputDto({required this.label, required this.value, required this.url});
  factory _ContactLinkInputDto.fromJson(Map<String, dynamic> json) => _$ContactLinkInputDtoFromJson(json);

/// Nome do canal.
@override final  String label;
/// Texto exibido.
@override final  String value;
/// Destino abrível pelo app: `https://…`, `mailto:…` ou `tel:…`.
@override final  String url;

/// Create a copy of ContactLinkInputDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactLinkInputDtoCopyWith<_ContactLinkInputDto> get copyWith => __$ContactLinkInputDtoCopyWithImpl<_ContactLinkInputDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContactLinkInputDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactLinkInputDto&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,value,url);

@override
String toString() {
  return 'ContactLinkInputDto(label: $label, value: $value, url: $url)';
}


}

/// @nodoc
abstract mixin class _$ContactLinkInputDtoCopyWith<$Res> implements $ContactLinkInputDtoCopyWith<$Res> {
  factory _$ContactLinkInputDtoCopyWith(_ContactLinkInputDto value, $Res Function(_ContactLinkInputDto) _then) = __$ContactLinkInputDtoCopyWithImpl;
@override @useResult
$Res call({
 String label, String value, String url
});




}
/// @nodoc
class __$ContactLinkInputDtoCopyWithImpl<$Res>
    implements _$ContactLinkInputDtoCopyWith<$Res> {
  __$ContactLinkInputDtoCopyWithImpl(this._self, this._then);

  final _ContactLinkInputDto _self;
  final $Res Function(_ContactLinkInputDto) _then;

/// Create a copy of ContactLinkInputDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? value = null,Object? url = null,}) {
  return _then(_ContactLinkInputDto(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
