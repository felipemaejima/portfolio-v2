// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'education_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EducationDto {

 String get id; String get courseName; String get institution; int get startYear;/// null = em andamento.
 int? get endYear; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of EducationDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EducationDtoCopyWith<EducationDto> get copyWith => _$EducationDtoCopyWithImpl<EducationDto>(this as EducationDto, _$identity);

  /// Serializes this EducationDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EducationDto&&(identical(other.id, id) || other.id == id)&&(identical(other.courseName, courseName) || other.courseName == courseName)&&(identical(other.institution, institution) || other.institution == institution)&&(identical(other.startYear, startYear) || other.startYear == startYear)&&(identical(other.endYear, endYear) || other.endYear == endYear)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,courseName,institution,startYear,endYear,createdAt,updatedAt);

@override
String toString() {
  return 'EducationDto(id: $id, courseName: $courseName, institution: $institution, startYear: $startYear, endYear: $endYear, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $EducationDtoCopyWith<$Res>  {
  factory $EducationDtoCopyWith(EducationDto value, $Res Function(EducationDto) _then) = _$EducationDtoCopyWithImpl;
@useResult
$Res call({
 String id, String courseName, String institution, int startYear, int? endYear, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$EducationDtoCopyWithImpl<$Res>
    implements $EducationDtoCopyWith<$Res> {
  _$EducationDtoCopyWithImpl(this._self, this._then);

  final EducationDto _self;
  final $Res Function(EducationDto) _then;

/// Create a copy of EducationDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? courseName = null,Object? institution = null,Object? startYear = null,Object? endYear = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(EducationDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,courseName: null == courseName ? _self.courseName : courseName // ignore: cast_nullable_to_non_nullable
as String,institution: null == institution ? _self.institution : institution // ignore: cast_nullable_to_non_nullable
as String,startYear: null == startYear ? _self.startYear : startYear // ignore: cast_nullable_to_non_nullable
as int,endYear: freezed == endYear ? _self.endYear : endYear // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [EducationDto].
extension EducationDtoPatterns on EducationDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EducationDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EducationDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EducationDto value)  $default,){
final _that = this;
switch (_that) {
case _EducationDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EducationDto value)?  $default,){
final _that = this;
switch (_that) {
case _EducationDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String courseName,  String institution,  int startYear,  int? endYear,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EducationDto() when $default != null:
return $default(_that.id,_that.courseName,_that.institution,_that.startYear,_that.endYear,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String courseName,  String institution,  int startYear,  int? endYear,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _EducationDto():
return $default(_that.id,_that.courseName,_that.institution,_that.startYear,_that.endYear,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String courseName,  String institution,  int startYear,  int? endYear,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _EducationDto() when $default != null:
return $default(_that.id,_that.courseName,_that.institution,_that.startYear,_that.endYear,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EducationDto implements EducationDto {
  const _EducationDto({required this.id, required this.courseName, required this.institution, required this.startYear, required this.endYear, required this.createdAt, required this.updatedAt});
  factory _EducationDto.fromJson(Map<String, dynamic> json) => _$EducationDtoFromJson(json);

@override final  String id;
@override final  String courseName;
@override final  String institution;
@override final  int startYear;
/// null = em andamento.
@override final  int? endYear;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of EducationDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EducationDtoCopyWith<_EducationDto> get copyWith => __$EducationDtoCopyWithImpl<_EducationDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EducationDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EducationDto&&(identical(other.id, id) || other.id == id)&&(identical(other.courseName, courseName) || other.courseName == courseName)&&(identical(other.institution, institution) || other.institution == institution)&&(identical(other.startYear, startYear) || other.startYear == startYear)&&(identical(other.endYear, endYear) || other.endYear == endYear)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,courseName,institution,startYear,endYear,createdAt,updatedAt);

@override
String toString() {
  return 'EducationDto(id: $id, courseName: $courseName, institution: $institution, startYear: $startYear, endYear: $endYear, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$EducationDtoCopyWith<$Res> implements $EducationDtoCopyWith<$Res> {
  factory _$EducationDtoCopyWith(_EducationDto value, $Res Function(_EducationDto) _then) = __$EducationDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String courseName, String institution, int startYear, int? endYear, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$EducationDtoCopyWithImpl<$Res>
    implements _$EducationDtoCopyWith<$Res> {
  __$EducationDtoCopyWithImpl(this._self, this._then);

  final _EducationDto _self;
  final $Res Function(_EducationDto) _then;

/// Create a copy of EducationDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? courseName = null,Object? institution = null,Object? startYear = null,Object? endYear = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_EducationDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,courseName: null == courseName ? _self.courseName : courseName // ignore: cast_nullable_to_non_nullable
as String,institution: null == institution ? _self.institution : institution // ignore: cast_nullable_to_non_nullable
as String,startYear: null == startYear ? _self.startYear : startYear // ignore: cast_nullable_to_non_nullable
as int,endYear: freezed == endYear ? _self.endYear : endYear // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
