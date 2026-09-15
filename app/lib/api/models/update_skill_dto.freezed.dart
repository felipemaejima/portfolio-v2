// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_skill_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateSkillDto {

 String get name; String get categoryId;
/// Create a copy of UpdateSkillDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateSkillDtoCopyWith<UpdateSkillDto> get copyWith => _$UpdateSkillDtoCopyWithImpl<UpdateSkillDto>(this as UpdateSkillDto, _$identity);

  /// Serializes this UpdateSkillDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateSkillDto&&(identical(other.name, name) || other.name == name)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,categoryId);

@override
String toString() {
  return 'UpdateSkillDto(name: $name, categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class $UpdateSkillDtoCopyWith<$Res>  {
  factory $UpdateSkillDtoCopyWith(UpdateSkillDto value, $Res Function(UpdateSkillDto) _then) = _$UpdateSkillDtoCopyWithImpl;
@useResult
$Res call({
 String name, String categoryId
});




}
/// @nodoc
class _$UpdateSkillDtoCopyWithImpl<$Res>
    implements $UpdateSkillDtoCopyWith<$Res> {
  _$UpdateSkillDtoCopyWithImpl(this._self, this._then);

  final UpdateSkillDto _self;
  final $Res Function(UpdateSkillDto) _then;

/// Create a copy of UpdateSkillDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? categoryId = null,}) {
  return _then(UpdateSkillDto(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateSkillDto].
extension UpdateSkillDtoPatterns on UpdateSkillDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateSkillDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateSkillDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateSkillDto value)  $default,){
final _that = this;
switch (_that) {
case _UpdateSkillDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateSkillDto value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateSkillDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String categoryId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateSkillDto() when $default != null:
return $default(_that.name,_that.categoryId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String categoryId)  $default,) {final _that = this;
switch (_that) {
case _UpdateSkillDto():
return $default(_that.name,_that.categoryId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String categoryId)?  $default,) {final _that = this;
switch (_that) {
case _UpdateSkillDto() when $default != null:
return $default(_that.name,_that.categoryId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateSkillDto implements UpdateSkillDto {
  const _UpdateSkillDto({required this.name, required this.categoryId});
  factory _UpdateSkillDto.fromJson(Map<String, dynamic> json) => _$UpdateSkillDtoFromJson(json);

@override final  String name;
@override final  String categoryId;

/// Create a copy of UpdateSkillDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateSkillDtoCopyWith<_UpdateSkillDto> get copyWith => __$UpdateSkillDtoCopyWithImpl<_UpdateSkillDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateSkillDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateSkillDto&&(identical(other.name, name) || other.name == name)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,categoryId);

@override
String toString() {
  return 'UpdateSkillDto(name: $name, categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class _$UpdateSkillDtoCopyWith<$Res> implements $UpdateSkillDtoCopyWith<$Res> {
  factory _$UpdateSkillDtoCopyWith(_UpdateSkillDto value, $Res Function(_UpdateSkillDto) _then) = __$UpdateSkillDtoCopyWithImpl;
@override @useResult
$Res call({
 String name, String categoryId
});




}
/// @nodoc
class __$UpdateSkillDtoCopyWithImpl<$Res>
    implements _$UpdateSkillDtoCopyWith<$Res> {
  __$UpdateSkillDtoCopyWithImpl(this._self, this._then);

  final _UpdateSkillDto _self;
  final $Res Function(_UpdateSkillDto) _then;

/// Create a copy of UpdateSkillDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? categoryId = null,}) {
  return _then(_UpdateSkillDto(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
