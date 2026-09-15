// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'experience_input_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExperienceInputDto {

 String get role; String get companyName;/// Itens; viram bullets no CV.
 List<String> get activities;/// Mês/ano, `YYYY-MM`.
 String get startDate;/// Mês/ano, `YYYY-MM`; null = atual.
 String? get endDate;
/// Create a copy of ExperienceInputDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExperienceInputDtoCopyWith<ExperienceInputDto> get copyWith => _$ExperienceInputDtoCopyWithImpl<ExperienceInputDto>(this as ExperienceInputDto, _$identity);

  /// Serializes this ExperienceInputDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExperienceInputDto&&(identical(other.role, role) || other.role == role)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&const DeepCollectionEquality().equals(other.activities, activities)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role,companyName,const DeepCollectionEquality().hash(activities),startDate,endDate);

@override
String toString() {
  return 'ExperienceInputDto(role: $role, companyName: $companyName, activities: $activities, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class $ExperienceInputDtoCopyWith<$Res>  {
  factory $ExperienceInputDtoCopyWith(ExperienceInputDto value, $Res Function(ExperienceInputDto) _then) = _$ExperienceInputDtoCopyWithImpl;
@useResult
$Res call({
 String role, String companyName, List<String> activities, String startDate, String? endDate
});




}
/// @nodoc
class _$ExperienceInputDtoCopyWithImpl<$Res>
    implements $ExperienceInputDtoCopyWith<$Res> {
  _$ExperienceInputDtoCopyWithImpl(this._self, this._then);

  final ExperienceInputDto _self;
  final $Res Function(ExperienceInputDto) _then;

/// Create a copy of ExperienceInputDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? role = null,Object? companyName = null,Object? activities = null,Object? startDate = null,Object? endDate = freezed,}) {
  return _then(ExperienceInputDto(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,activities: null == activities ? _self.activities : activities // ignore: cast_nullable_to_non_nullable
as List<String>,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExperienceInputDto].
extension ExperienceInputDtoPatterns on ExperienceInputDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExperienceInputDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExperienceInputDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExperienceInputDto value)  $default,){
final _that = this;
switch (_that) {
case _ExperienceInputDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExperienceInputDto value)?  $default,){
final _that = this;
switch (_that) {
case _ExperienceInputDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String role,  String companyName,  List<String> activities,  String startDate,  String? endDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExperienceInputDto() when $default != null:
return $default(_that.role,_that.companyName,_that.activities,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String role,  String companyName,  List<String> activities,  String startDate,  String? endDate)  $default,) {final _that = this;
switch (_that) {
case _ExperienceInputDto():
return $default(_that.role,_that.companyName,_that.activities,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String role,  String companyName,  List<String> activities,  String startDate,  String? endDate)?  $default,) {final _that = this;
switch (_that) {
case _ExperienceInputDto() when $default != null:
return $default(_that.role,_that.companyName,_that.activities,_that.startDate,_that.endDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExperienceInputDto implements ExperienceInputDto {
  const _ExperienceInputDto({required this.role, required this.companyName, required  List<String> activities, required this.startDate, this.endDate}): _activities = activities;
  factory _ExperienceInputDto.fromJson(Map<String, dynamic> json) => _$ExperienceInputDtoFromJson(json);

@override final  String role;
@override final  String companyName;
/// Itens; viram bullets no CV.
 final  List<String> _activities;
/// Itens; viram bullets no CV.
@override List<String> get activities {
  if (_activities is EqualUnmodifiableListView) return _activities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_activities);
}

/// Mês/ano, `YYYY-MM`.
@override final  String startDate;
/// Mês/ano, `YYYY-MM`; null = atual.
@override final  String? endDate;

/// Create a copy of ExperienceInputDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExperienceInputDtoCopyWith<_ExperienceInputDto> get copyWith => __$ExperienceInputDtoCopyWithImpl<_ExperienceInputDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExperienceInputDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExperienceInputDto&&(identical(other.role, role) || other.role == role)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&const DeepCollectionEquality().equals(other._activities, _activities)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role,companyName,const DeepCollectionEquality().hash(_activities),startDate,endDate);

@override
String toString() {
  return 'ExperienceInputDto(role: $role, companyName: $companyName, activities: $activities, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class _$ExperienceInputDtoCopyWith<$Res> implements $ExperienceInputDtoCopyWith<$Res> {
  factory _$ExperienceInputDtoCopyWith(_ExperienceInputDto value, $Res Function(_ExperienceInputDto) _then) = __$ExperienceInputDtoCopyWithImpl;
@override @useResult
$Res call({
 String role, String companyName, List<String> activities, String startDate, String? endDate
});




}
/// @nodoc
class __$ExperienceInputDtoCopyWithImpl<$Res>
    implements _$ExperienceInputDtoCopyWith<$Res> {
  __$ExperienceInputDtoCopyWithImpl(this._self, this._then);

  final _ExperienceInputDto _self;
  final $Res Function(_ExperienceInputDto) _then;

/// Create a copy of ExperienceInputDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? role = null,Object? companyName = null,Object? activities = null,Object? startDate = null,Object? endDate = freezed,}) {
  return _then(_ExperienceInputDto(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,activities: null == activities ? _self._activities : activities // ignore: cast_nullable_to_non_nullable
as List<String>,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
