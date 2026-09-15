// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_image_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectImageDto {

 String get id;/// URL pública permanente.
 String get url; int get position;
/// Create a copy of ProjectImageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectImageDtoCopyWith<ProjectImageDto> get copyWith => _$ProjectImageDtoCopyWithImpl<ProjectImageDto>(this as ProjectImageDto, _$identity);

  /// Serializes this ProjectImageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectImageDto&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.position, position) || other.position == position));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,url,position);

@override
String toString() {
  return 'ProjectImageDto(id: $id, url: $url, position: $position)';
}


}

/// @nodoc
abstract mixin class $ProjectImageDtoCopyWith<$Res>  {
  factory $ProjectImageDtoCopyWith(ProjectImageDto value, $Res Function(ProjectImageDto) _then) = _$ProjectImageDtoCopyWithImpl;
@useResult
$Res call({
 String id, String url, int position
});




}
/// @nodoc
class _$ProjectImageDtoCopyWithImpl<$Res>
    implements $ProjectImageDtoCopyWith<$Res> {
  _$ProjectImageDtoCopyWithImpl(this._self, this._then);

  final ProjectImageDto _self;
  final $Res Function(ProjectImageDto) _then;

/// Create a copy of ProjectImageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? url = null,Object? position = null,}) {
  return _then(ProjectImageDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectImageDto].
extension ProjectImageDtoPatterns on ProjectImageDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectImageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectImageDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectImageDto value)  $default,){
final _that = this;
switch (_that) {
case _ProjectImageDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectImageDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectImageDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String url,  int position)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectImageDto() when $default != null:
return $default(_that.id,_that.url,_that.position);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String url,  int position)  $default,) {final _that = this;
switch (_that) {
case _ProjectImageDto():
return $default(_that.id,_that.url,_that.position);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String url,  int position)?  $default,) {final _that = this;
switch (_that) {
case _ProjectImageDto() when $default != null:
return $default(_that.id,_that.url,_that.position);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectImageDto implements ProjectImageDto {
  const _ProjectImageDto({required this.id, required this.url, required this.position});
  factory _ProjectImageDto.fromJson(Map<String, dynamic> json) => _$ProjectImageDtoFromJson(json);

@override final  String id;
/// URL pública permanente.
@override final  String url;
@override final  int position;

/// Create a copy of ProjectImageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectImageDtoCopyWith<_ProjectImageDto> get copyWith => __$ProjectImageDtoCopyWithImpl<_ProjectImageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectImageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectImageDto&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.position, position) || other.position == position));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,url,position);

@override
String toString() {
  return 'ProjectImageDto(id: $id, url: $url, position: $position)';
}


}

/// @nodoc
abstract mixin class _$ProjectImageDtoCopyWith<$Res> implements $ProjectImageDtoCopyWith<$Res> {
  factory _$ProjectImageDtoCopyWith(_ProjectImageDto value, $Res Function(_ProjectImageDto) _then) = __$ProjectImageDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String url, int position
});




}
/// @nodoc
class __$ProjectImageDtoCopyWithImpl<$Res>
    implements _$ProjectImageDtoCopyWith<$Res> {
  __$ProjectImageDtoCopyWithImpl(this._self, this._then);

  final _ProjectImageDto _self;
  final $Res Function(_ProjectImageDto) _then;

/// Create a copy of ProjectImageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? url = null,Object? position = null,}) {
  return _then(_ProjectImageDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
