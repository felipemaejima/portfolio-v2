// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'skill_category_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SkillCategoryDto {

 String get id; String get name; int get position;/// Por `position`.
 List<SkillDto> get skills; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of SkillCategoryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SkillCategoryDtoCopyWith<SkillCategoryDto> get copyWith => _$SkillCategoryDtoCopyWithImpl<SkillCategoryDto>(this as SkillCategoryDto, _$identity);

  /// Serializes this SkillCategoryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SkillCategoryDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.position, position) || other.position == position)&&const DeepCollectionEquality().equals(other.skills, skills)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,position,const DeepCollectionEquality().hash(skills),createdAt,updatedAt);

@override
String toString() {
  return 'SkillCategoryDto(id: $id, name: $name, position: $position, skills: $skills, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $SkillCategoryDtoCopyWith<$Res>  {
  factory $SkillCategoryDtoCopyWith(SkillCategoryDto value, $Res Function(SkillCategoryDto) _then) = _$SkillCategoryDtoCopyWithImpl;
@useResult
$Res call({
 String id, String name, int position, List<SkillDto> skills, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$SkillCategoryDtoCopyWithImpl<$Res>
    implements $SkillCategoryDtoCopyWith<$Res> {
  _$SkillCategoryDtoCopyWithImpl(this._self, this._then);

  final SkillCategoryDto _self;
  final $Res Function(SkillCategoryDto) _then;

/// Create a copy of SkillCategoryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? position = null,Object? skills = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(SkillCategoryDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,skills: null == skills ? _self.skills : skills // ignore: cast_nullable_to_non_nullable
as List<SkillDto>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SkillCategoryDto].
extension SkillCategoryDtoPatterns on SkillCategoryDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SkillCategoryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SkillCategoryDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SkillCategoryDto value)  $default,){
final _that = this;
switch (_that) {
case _SkillCategoryDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SkillCategoryDto value)?  $default,){
final _that = this;
switch (_that) {
case _SkillCategoryDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int position,  List<SkillDto> skills,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SkillCategoryDto() when $default != null:
return $default(_that.id,_that.name,_that.position,_that.skills,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int position,  List<SkillDto> skills,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _SkillCategoryDto():
return $default(_that.id,_that.name,_that.position,_that.skills,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int position,  List<SkillDto> skills,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _SkillCategoryDto() when $default != null:
return $default(_that.id,_that.name,_that.position,_that.skills,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SkillCategoryDto implements SkillCategoryDto {
  const _SkillCategoryDto({required this.id, required this.name, required this.position, required  List<SkillDto> skills, required this.createdAt, required this.updatedAt}): _skills = skills;
  factory _SkillCategoryDto.fromJson(Map<String, dynamic> json) => _$SkillCategoryDtoFromJson(json);

@override final  String id;
@override final  String name;
@override final  int position;
/// Por `position`.
 final  List<SkillDto> _skills;
/// Por `position`.
@override List<SkillDto> get skills {
  if (_skills is EqualUnmodifiableListView) return _skills;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_skills);
}

@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of SkillCategoryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SkillCategoryDtoCopyWith<_SkillCategoryDto> get copyWith => __$SkillCategoryDtoCopyWithImpl<_SkillCategoryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SkillCategoryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SkillCategoryDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.position, position) || other.position == position)&&const DeepCollectionEquality().equals(other._skills, _skills)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,position,const DeepCollectionEquality().hash(_skills),createdAt,updatedAt);

@override
String toString() {
  return 'SkillCategoryDto(id: $id, name: $name, position: $position, skills: $skills, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$SkillCategoryDtoCopyWith<$Res> implements $SkillCategoryDtoCopyWith<$Res> {
  factory _$SkillCategoryDtoCopyWith(_SkillCategoryDto value, $Res Function(_SkillCategoryDto) _then) = __$SkillCategoryDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int position, List<SkillDto> skills, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$SkillCategoryDtoCopyWithImpl<$Res>
    implements _$SkillCategoryDtoCopyWith<$Res> {
  __$SkillCategoryDtoCopyWithImpl(this._self, this._then);

  final _SkillCategoryDto _self;
  final $Res Function(_SkillCategoryDto) _then;

/// Create a copy of SkillCategoryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? position = null,Object? skills = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_SkillCategoryDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,skills: null == skills ? _self._skills : skills // ignore: cast_nullable_to_non_nullable
as List<SkillDto>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
