// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'education_input_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EducationInputDto {

 String get courseName; String get institution; int get startYear;/// null = em andamento. Igual a `startYear` → exibe um ano só.
 int? get endYear;
/// Create a copy of EducationInputDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EducationInputDtoCopyWith<EducationInputDto> get copyWith => _$EducationInputDtoCopyWithImpl<EducationInputDto>(this as EducationInputDto, _$identity);

  /// Serializes this EducationInputDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EducationInputDto&&(identical(other.courseName, courseName) || other.courseName == courseName)&&(identical(other.institution, institution) || other.institution == institution)&&(identical(other.startYear, startYear) || other.startYear == startYear)&&(identical(other.endYear, endYear) || other.endYear == endYear));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,courseName,institution,startYear,endYear);

@override
String toString() {
  return 'EducationInputDto(courseName: $courseName, institution: $institution, startYear: $startYear, endYear: $endYear)';
}


}

/// @nodoc
abstract mixin class $EducationInputDtoCopyWith<$Res>  {
  factory $EducationInputDtoCopyWith(EducationInputDto value, $Res Function(EducationInputDto) _then) = _$EducationInputDtoCopyWithImpl;
@useResult
$Res call({
 String courseName, String institution, int startYear, int? endYear
});




}
/// @nodoc
class _$EducationInputDtoCopyWithImpl<$Res>
    implements $EducationInputDtoCopyWith<$Res> {
  _$EducationInputDtoCopyWithImpl(this._self, this._then);

  final EducationInputDto _self;
  final $Res Function(EducationInputDto) _then;

/// Create a copy of EducationInputDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? courseName = null,Object? institution = null,Object? startYear = null,Object? endYear = freezed,}) {
  return _then(EducationInputDto(
courseName: null == courseName ? _self.courseName : courseName // ignore: cast_nullable_to_non_nullable
as String,institution: null == institution ? _self.institution : institution // ignore: cast_nullable_to_non_nullable
as String,startYear: null == startYear ? _self.startYear : startYear // ignore: cast_nullable_to_non_nullable
as int,endYear: freezed == endYear ? _self.endYear : endYear // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [EducationInputDto].
extension EducationInputDtoPatterns on EducationInputDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EducationInputDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EducationInputDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EducationInputDto value)  $default,){
final _that = this;
switch (_that) {
case _EducationInputDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EducationInputDto value)?  $default,){
final _that = this;
switch (_that) {
case _EducationInputDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String courseName,  String institution,  int startYear,  int? endYear)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EducationInputDto() when $default != null:
return $default(_that.courseName,_that.institution,_that.startYear,_that.endYear);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String courseName,  String institution,  int startYear,  int? endYear)  $default,) {final _that = this;
switch (_that) {
case _EducationInputDto():
return $default(_that.courseName,_that.institution,_that.startYear,_that.endYear);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String courseName,  String institution,  int startYear,  int? endYear)?  $default,) {final _that = this;
switch (_that) {
case _EducationInputDto() when $default != null:
return $default(_that.courseName,_that.institution,_that.startYear,_that.endYear);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EducationInputDto implements EducationInputDto {
  const _EducationInputDto({required this.courseName, required this.institution, required this.startYear, this.endYear});
  factory _EducationInputDto.fromJson(Map<String, dynamic> json) => _$EducationInputDtoFromJson(json);

@override final  String courseName;
@override final  String institution;
@override final  int startYear;
/// null = em andamento. Igual a `startYear` → exibe um ano só.
@override final  int? endYear;

/// Create a copy of EducationInputDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EducationInputDtoCopyWith<_EducationInputDto> get copyWith => __$EducationInputDtoCopyWithImpl<_EducationInputDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EducationInputDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EducationInputDto&&(identical(other.courseName, courseName) || other.courseName == courseName)&&(identical(other.institution, institution) || other.institution == institution)&&(identical(other.startYear, startYear) || other.startYear == startYear)&&(identical(other.endYear, endYear) || other.endYear == endYear));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,courseName,institution,startYear,endYear);

@override
String toString() {
  return 'EducationInputDto(courseName: $courseName, institution: $institution, startYear: $startYear, endYear: $endYear)';
}


}

/// @nodoc
abstract mixin class _$EducationInputDtoCopyWith<$Res> implements $EducationInputDtoCopyWith<$Res> {
  factory _$EducationInputDtoCopyWith(_EducationInputDto value, $Res Function(_EducationInputDto) _then) = __$EducationInputDtoCopyWithImpl;
@override @useResult
$Res call({
 String courseName, String institution, int startYear, int? endYear
});




}
/// @nodoc
class __$EducationInputDtoCopyWithImpl<$Res>
    implements _$EducationInputDtoCopyWith<$Res> {
  __$EducationInputDtoCopyWithImpl(this._self, this._then);

  final _EducationInputDto _self;
  final $Res Function(_EducationInputDto) _then;

/// Create a copy of EducationInputDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? courseName = null,Object? institution = null,Object? startYear = null,Object? endYear = freezed,}) {
  return _then(_EducationInputDto(
courseName: null == courseName ? _self.courseName : courseName // ignore: cast_nullable_to_non_nullable
as String,institution: null == institution ? _self.institution : institution // ignore: cast_nullable_to_non_nullable
as String,startYear: null == startYear ? _self.startYear : startYear // ignore: cast_nullable_to_non_nullable
as int,endYear: freezed == endYear ? _self.endYear : endYear // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
