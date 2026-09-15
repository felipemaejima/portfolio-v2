// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'experience_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExperienceDto {

 String get id; String get role; String get companyName; List<String> get activities;/// `YYYY-MM`
 String get startDate;/// `YYYY-MM`; null = atual.
 String? get endDate; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of ExperienceDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExperienceDtoCopyWith<ExperienceDto> get copyWith => _$ExperienceDtoCopyWithImpl<ExperienceDto>(this as ExperienceDto, _$identity);

  /// Serializes this ExperienceDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExperienceDto&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&const DeepCollectionEquality().equals(other.activities, activities)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,role,companyName,const DeepCollectionEquality().hash(activities),startDate,endDate,createdAt,updatedAt);

@override
String toString() {
  return 'ExperienceDto(id: $id, role: $role, companyName: $companyName, activities: $activities, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ExperienceDtoCopyWith<$Res>  {
  factory $ExperienceDtoCopyWith(ExperienceDto value, $Res Function(ExperienceDto) _then) = _$ExperienceDtoCopyWithImpl;
@useResult
$Res call({
 String id, String role, String companyName, List<String> activities, String startDate, String? endDate, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$ExperienceDtoCopyWithImpl<$Res>
    implements $ExperienceDtoCopyWith<$Res> {
  _$ExperienceDtoCopyWithImpl(this._self, this._then);

  final ExperienceDto _self;
  final $Res Function(ExperienceDto) _then;

/// Create a copy of ExperienceDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? role = null,Object? companyName = null,Object? activities = null,Object? startDate = null,Object? endDate = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(ExperienceDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,activities: null == activities ? _self.activities : activities // ignore: cast_nullable_to_non_nullable
as List<String>,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ExperienceDto].
extension ExperienceDtoPatterns on ExperienceDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExperienceDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExperienceDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExperienceDto value)  $default,){
final _that = this;
switch (_that) {
case _ExperienceDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExperienceDto value)?  $default,){
final _that = this;
switch (_that) {
case _ExperienceDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String role,  String companyName,  List<String> activities,  String startDate,  String? endDate,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExperienceDto() when $default != null:
return $default(_that.id,_that.role,_that.companyName,_that.activities,_that.startDate,_that.endDate,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String role,  String companyName,  List<String> activities,  String startDate,  String? endDate,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ExperienceDto():
return $default(_that.id,_that.role,_that.companyName,_that.activities,_that.startDate,_that.endDate,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String role,  String companyName,  List<String> activities,  String startDate,  String? endDate,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ExperienceDto() when $default != null:
return $default(_that.id,_that.role,_that.companyName,_that.activities,_that.startDate,_that.endDate,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExperienceDto implements ExperienceDto {
  const _ExperienceDto({required this.id, required this.role, required this.companyName, required  List<String> activities, required this.startDate, required this.endDate, required this.createdAt, required this.updatedAt}): _activities = activities;
  factory _ExperienceDto.fromJson(Map<String, dynamic> json) => _$ExperienceDtoFromJson(json);

@override final  String id;
@override final  String role;
@override final  String companyName;
 final  List<String> _activities;
@override List<String> get activities {
  if (_activities is EqualUnmodifiableListView) return _activities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_activities);
}

/// `YYYY-MM`
@override final  String startDate;
/// `YYYY-MM`; null = atual.
@override final  String? endDate;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of ExperienceDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExperienceDtoCopyWith<_ExperienceDto> get copyWith => __$ExperienceDtoCopyWithImpl<_ExperienceDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExperienceDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExperienceDto&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&const DeepCollectionEquality().equals(other._activities, _activities)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,role,companyName,const DeepCollectionEquality().hash(_activities),startDate,endDate,createdAt,updatedAt);

@override
String toString() {
  return 'ExperienceDto(id: $id, role: $role, companyName: $companyName, activities: $activities, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ExperienceDtoCopyWith<$Res> implements $ExperienceDtoCopyWith<$Res> {
  factory _$ExperienceDtoCopyWith(_ExperienceDto value, $Res Function(_ExperienceDto) _then) = __$ExperienceDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String role, String companyName, List<String> activities, String startDate, String? endDate, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$ExperienceDtoCopyWithImpl<$Res>
    implements _$ExperienceDtoCopyWith<$Res> {
  __$ExperienceDtoCopyWithImpl(this._self, this._then);

  final _ExperienceDto _self;
  final $Res Function(_ExperienceDto) _then;

/// Create a copy of ExperienceDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? role = null,Object? companyName = null,Object? activities = null,Object? startDate = null,Object? endDate = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ExperienceDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,activities: null == activities ? _self._activities : activities // ignore: cast_nullable_to_non_nullable
as List<String>,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
