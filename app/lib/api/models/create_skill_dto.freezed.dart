// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_skill_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateSkillDto {

 String get name;
/// Create a copy of CreateSkillDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateSkillDtoCopyWith<CreateSkillDto> get copyWith => _$CreateSkillDtoCopyWithImpl<CreateSkillDto>(this as CreateSkillDto, _$identity);

  /// Serializes this CreateSkillDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateSkillDto&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'CreateSkillDto(name: $name)';
}


}

/// @nodoc
abstract mixin class $CreateSkillDtoCopyWith<$Res>  {
  factory $CreateSkillDtoCopyWith(CreateSkillDto value, $Res Function(CreateSkillDto) _then) = _$CreateSkillDtoCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class _$CreateSkillDtoCopyWithImpl<$Res>
    implements $CreateSkillDtoCopyWith<$Res> {
  _$CreateSkillDtoCopyWithImpl(this._self, this._then);

  final CreateSkillDto _self;
  final $Res Function(CreateSkillDto) _then;

/// Create a copy of CreateSkillDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,}) {
  return _then(CreateSkillDto(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateSkillDto].
extension CreateSkillDtoPatterns on CreateSkillDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateSkillDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateSkillDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateSkillDto value)  $default,){
final _that = this;
switch (_that) {
case _CreateSkillDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateSkillDto value)?  $default,){
final _that = this;
switch (_that) {
case _CreateSkillDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateSkillDto() when $default != null:
return $default(_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name)  $default,) {final _that = this;
switch (_that) {
case _CreateSkillDto():
return $default(_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name)?  $default,) {final _that = this;
switch (_that) {
case _CreateSkillDto() when $default != null:
return $default(_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateSkillDto implements CreateSkillDto {
  const _CreateSkillDto({required this.name});
  factory _CreateSkillDto.fromJson(Map<String, dynamic> json) => _$CreateSkillDtoFromJson(json);

@override final  String name;

/// Create a copy of CreateSkillDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateSkillDtoCopyWith<_CreateSkillDto> get copyWith => __$CreateSkillDtoCopyWithImpl<_CreateSkillDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateSkillDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateSkillDto&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'CreateSkillDto(name: $name)';
}


}

/// @nodoc
abstract mixin class _$CreateSkillDtoCopyWith<$Res> implements $CreateSkillDtoCopyWith<$Res> {
  factory _$CreateSkillDtoCopyWith(_CreateSkillDto value, $Res Function(_CreateSkillDto) _then) = __$CreateSkillDtoCopyWithImpl;
@override @useResult
$Res call({
 String name
});




}
/// @nodoc
class __$CreateSkillDtoCopyWithImpl<$Res>
    implements _$CreateSkillDtoCopyWith<$Res> {
  __$CreateSkillDtoCopyWithImpl(this._self, this._then);

  final _CreateSkillDto _self;
  final $Res Function(_CreateSkillDto) _then;

/// Create a copy of CreateSkillDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(_CreateSkillDto(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
