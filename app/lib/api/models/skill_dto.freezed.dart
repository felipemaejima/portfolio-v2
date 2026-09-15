// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'skill_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SkillDto {

 String get id; String get name;/// Posição dentro da categoria.
 int get position; String get categoryId; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of SkillDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SkillDtoCopyWith<SkillDto> get copyWith => _$SkillDtoCopyWithImpl<SkillDto>(this as SkillDto, _$identity);

  /// Serializes this SkillDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SkillDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.position, position) || other.position == position)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,position,categoryId,createdAt,updatedAt);

@override
String toString() {
  return 'SkillDto(id: $id, name: $name, position: $position, categoryId: $categoryId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $SkillDtoCopyWith<$Res>  {
  factory $SkillDtoCopyWith(SkillDto value, $Res Function(SkillDto) _then) = _$SkillDtoCopyWithImpl;
@useResult
$Res call({
 String id, String name, int position, String categoryId, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$SkillDtoCopyWithImpl<$Res>
    implements $SkillDtoCopyWith<$Res> {
  _$SkillDtoCopyWithImpl(this._self, this._then);

  final SkillDto _self;
  final $Res Function(SkillDto) _then;

/// Create a copy of SkillDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? position = null,Object? categoryId = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(SkillDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SkillDto].
extension SkillDtoPatterns on SkillDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SkillDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SkillDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SkillDto value)  $default,){
final _that = this;
switch (_that) {
case _SkillDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SkillDto value)?  $default,){
final _that = this;
switch (_that) {
case _SkillDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int position,  String categoryId,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SkillDto() when $default != null:
return $default(_that.id,_that.name,_that.position,_that.categoryId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int position,  String categoryId,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _SkillDto():
return $default(_that.id,_that.name,_that.position,_that.categoryId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int position,  String categoryId,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _SkillDto() when $default != null:
return $default(_that.id,_that.name,_that.position,_that.categoryId,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SkillDto implements SkillDto {
  const _SkillDto({required this.id, required this.name, required this.position, required this.categoryId, required this.createdAt, required this.updatedAt});
  factory _SkillDto.fromJson(Map<String, dynamic> json) => _$SkillDtoFromJson(json);

@override final  String id;
@override final  String name;
/// Posição dentro da categoria.
@override final  int position;
@override final  String categoryId;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of SkillDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SkillDtoCopyWith<_SkillDto> get copyWith => __$SkillDtoCopyWithImpl<_SkillDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SkillDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SkillDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.position, position) || other.position == position)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,position,categoryId,createdAt,updatedAt);

@override
String toString() {
  return 'SkillDto(id: $id, name: $name, position: $position, categoryId: $categoryId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$SkillDtoCopyWith<$Res> implements $SkillDtoCopyWith<$Res> {
  factory _$SkillDtoCopyWith(_SkillDto value, $Res Function(_SkillDto) _then) = __$SkillDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int position, String categoryId, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$SkillDtoCopyWithImpl<$Res>
    implements _$SkillDtoCopyWith<$Res> {
  __$SkillDtoCopyWithImpl(this._self, this._then);

  final _SkillDto _self;
  final $Res Function(_SkillDto) _then;

/// Create a copy of SkillDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? position = null,Object? categoryId = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_SkillDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
