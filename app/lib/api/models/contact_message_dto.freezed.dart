// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_message_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContactMessageDto {

 String get id; String get name; String get email; String get message;/// null = não lida.
 DateTime? get readAt; DateTime get createdAt;
/// Create a copy of ContactMessageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactMessageDtoCopyWith<ContactMessageDto> get copyWith => _$ContactMessageDtoCopyWithImpl<ContactMessageDto>(this as ContactMessageDto, _$identity);

  /// Serializes this ContactMessageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactMessageDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.message, message) || other.message == message)&&(identical(other.readAt, readAt) || other.readAt == readAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,message,readAt,createdAt);

@override
String toString() {
  return 'ContactMessageDto(id: $id, name: $name, email: $email, message: $message, readAt: $readAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ContactMessageDtoCopyWith<$Res>  {
  factory $ContactMessageDtoCopyWith(ContactMessageDto value, $Res Function(ContactMessageDto) _then) = _$ContactMessageDtoCopyWithImpl;
@useResult
$Res call({
 String id, String name, String email, String message, DateTime? readAt, DateTime createdAt
});




}
/// @nodoc
class _$ContactMessageDtoCopyWithImpl<$Res>
    implements $ContactMessageDtoCopyWith<$Res> {
  _$ContactMessageDtoCopyWithImpl(this._self, this._then);

  final ContactMessageDto _self;
  final $Res Function(ContactMessageDto) _then;

/// Create a copy of ContactMessageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = null,Object? message = null,Object? readAt = freezed,Object? createdAt = null,}) {
  return _then(ContactMessageDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ContactMessageDto].
extension ContactMessageDtoPatterns on ContactMessageDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactMessageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactMessageDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactMessageDto value)  $default,){
final _that = this;
switch (_that) {
case _ContactMessageDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactMessageDto value)?  $default,){
final _that = this;
switch (_that) {
case _ContactMessageDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String email,  String message,  DateTime? readAt,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactMessageDto() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.message,_that.readAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String email,  String message,  DateTime? readAt,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ContactMessageDto():
return $default(_that.id,_that.name,_that.email,_that.message,_that.readAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String email,  String message,  DateTime? readAt,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ContactMessageDto() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.message,_that.readAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContactMessageDto implements ContactMessageDto {
  const _ContactMessageDto({required this.id, required this.name, required this.email, required this.message, required this.readAt, required this.createdAt});
  factory _ContactMessageDto.fromJson(Map<String, dynamic> json) => _$ContactMessageDtoFromJson(json);

@override final  String id;
@override final  String name;
@override final  String email;
@override final  String message;
/// null = não lida.
@override final  DateTime? readAt;
@override final  DateTime createdAt;

/// Create a copy of ContactMessageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactMessageDtoCopyWith<_ContactMessageDto> get copyWith => __$ContactMessageDtoCopyWithImpl<_ContactMessageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContactMessageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactMessageDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.message, message) || other.message == message)&&(identical(other.readAt, readAt) || other.readAt == readAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,message,readAt,createdAt);

@override
String toString() {
  return 'ContactMessageDto(id: $id, name: $name, email: $email, message: $message, readAt: $readAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ContactMessageDtoCopyWith<$Res> implements $ContactMessageDtoCopyWith<$Res> {
  factory _$ContactMessageDtoCopyWith(_ContactMessageDto value, $Res Function(_ContactMessageDto) _then) = __$ContactMessageDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String email, String message, DateTime? readAt, DateTime createdAt
});




}
/// @nodoc
class __$ContactMessageDtoCopyWithImpl<$Res>
    implements _$ContactMessageDtoCopyWith<$Res> {
  __$ContactMessageDtoCopyWithImpl(this._self, this._then);

  final _ContactMessageDto _self;
  final $Res Function(_ContactMessageDto) _then;

/// Create a copy of ContactMessageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = null,Object? message = null,Object? readAt = freezed,Object? createdAt = null,}) {
  return _then(_ContactMessageDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
