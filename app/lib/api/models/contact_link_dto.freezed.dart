// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_link_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContactLinkDto {

 String get id; String get label; String get value; String get url; int get position; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of ContactLinkDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactLinkDtoCopyWith<ContactLinkDto> get copyWith => _$ContactLinkDtoCopyWithImpl<ContactLinkDto>(this as ContactLinkDto, _$identity);

  /// Serializes this ContactLinkDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactLinkDto&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.url, url) || other.url == url)&&(identical(other.position, position) || other.position == position)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,value,url,position,createdAt,updatedAt);

@override
String toString() {
  return 'ContactLinkDto(id: $id, label: $label, value: $value, url: $url, position: $position, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ContactLinkDtoCopyWith<$Res>  {
  factory $ContactLinkDtoCopyWith(ContactLinkDto value, $Res Function(ContactLinkDto) _then) = _$ContactLinkDtoCopyWithImpl;
@useResult
$Res call({
 String id, String label, String value, String url, int position, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$ContactLinkDtoCopyWithImpl<$Res>
    implements $ContactLinkDtoCopyWith<$Res> {
  _$ContactLinkDtoCopyWithImpl(this._self, this._then);

  final ContactLinkDto _self;
  final $Res Function(ContactLinkDto) _then;

/// Create a copy of ContactLinkDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? value = null,Object? url = null,Object? position = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(ContactLinkDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ContactLinkDto].
extension ContactLinkDtoPatterns on ContactLinkDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactLinkDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactLinkDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactLinkDto value)  $default,){
final _that = this;
switch (_that) {
case _ContactLinkDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactLinkDto value)?  $default,){
final _that = this;
switch (_that) {
case _ContactLinkDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String label,  String value,  String url,  int position,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactLinkDto() when $default != null:
return $default(_that.id,_that.label,_that.value,_that.url,_that.position,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String label,  String value,  String url,  int position,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ContactLinkDto():
return $default(_that.id,_that.label,_that.value,_that.url,_that.position,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String label,  String value,  String url,  int position,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ContactLinkDto() when $default != null:
return $default(_that.id,_that.label,_that.value,_that.url,_that.position,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContactLinkDto implements ContactLinkDto {
  const _ContactLinkDto({required this.id, required this.label, required this.value, required this.url, required this.position, required this.createdAt, required this.updatedAt});
  factory _ContactLinkDto.fromJson(Map<String, dynamic> json) => _$ContactLinkDtoFromJson(json);

@override final  String id;
@override final  String label;
@override final  String value;
@override final  String url;
@override final  int position;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of ContactLinkDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactLinkDtoCopyWith<_ContactLinkDto> get copyWith => __$ContactLinkDtoCopyWithImpl<_ContactLinkDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContactLinkDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactLinkDto&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.url, url) || other.url == url)&&(identical(other.position, position) || other.position == position)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,value,url,position,createdAt,updatedAt);

@override
String toString() {
  return 'ContactLinkDto(id: $id, label: $label, value: $value, url: $url, position: $position, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ContactLinkDtoCopyWith<$Res> implements $ContactLinkDtoCopyWith<$Res> {
  factory _$ContactLinkDtoCopyWith(_ContactLinkDto value, $Res Function(_ContactLinkDto) _then) = __$ContactLinkDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String label, String value, String url, int position, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$ContactLinkDtoCopyWithImpl<$Res>
    implements _$ContactLinkDtoCopyWith<$Res> {
  __$ContactLinkDtoCopyWithImpl(this._self, this._then);

  final _ContactLinkDto _self;
  final $Res Function(_ContactLinkDto) _then;

/// Create a copy of ContactLinkDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? value = null,Object? url = null,Object? position = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ContactLinkDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
