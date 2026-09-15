// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminDto {

 String get id; String get email;
/// Create a copy of AdminDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminDtoCopyWith<AdminDto> get copyWith => _$AdminDtoCopyWithImpl<AdminDto>(this as AdminDto, _$identity);

  /// Serializes this AdminDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminDto&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email);

@override
String toString() {
  return 'AdminDto(id: $id, email: $email)';
}


}

/// @nodoc
abstract mixin class $AdminDtoCopyWith<$Res>  {
  factory $AdminDtoCopyWith(AdminDto value, $Res Function(AdminDto) _then) = _$AdminDtoCopyWithImpl;
@useResult
$Res call({
 String id, String email
});




}
/// @nodoc
class _$AdminDtoCopyWithImpl<$Res>
    implements $AdminDtoCopyWith<$Res> {
  _$AdminDtoCopyWithImpl(this._self, this._then);

  final AdminDto _self;
  final $Res Function(AdminDto) _then;

/// Create a copy of AdminDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,}) {
  return _then(AdminDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminDto].
extension AdminDtoPatterns on AdminDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminDto value)  $default,){
final _that = this;
switch (_that) {
case _AdminDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminDto value)?  $default,){
final _that = this;
switch (_that) {
case _AdminDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminDto() when $default != null:
return $default(_that.id,_that.email);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email)  $default,) {final _that = this;
switch (_that) {
case _AdminDto():
return $default(_that.id,_that.email);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email)?  $default,) {final _that = this;
switch (_that) {
case _AdminDto() when $default != null:
return $default(_that.id,_that.email);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminDto implements AdminDto {
  const _AdminDto({required this.id, required this.email});
  factory _AdminDto.fromJson(Map<String, dynamic> json) => _$AdminDtoFromJson(json);

@override final  String id;
@override final  String email;

/// Create a copy of AdminDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminDtoCopyWith<_AdminDto> get copyWith => __$AdminDtoCopyWithImpl<_AdminDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminDto&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email);

@override
String toString() {
  return 'AdminDto(id: $id, email: $email)';
}


}

/// @nodoc
abstract mixin class _$AdminDtoCopyWith<$Res> implements $AdminDtoCopyWith<$Res> {
  factory _$AdminDtoCopyWith(_AdminDto value, $Res Function(_AdminDto) _then) = __$AdminDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String email
});




}
/// @nodoc
class __$AdminDtoCopyWithImpl<$Res>
    implements _$AdminDtoCopyWith<$Res> {
  __$AdminDtoCopyWithImpl(this._self, this._then);

  final _AdminDto _self;
  final $Res Function(_AdminDto) _then;

/// Create a copy of AdminDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,}) {
  return _then(_AdminDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
