// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reorder_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReorderDto {

 List<String> get ids;
/// Create a copy of ReorderDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReorderDtoCopyWith<ReorderDto> get copyWith => _$ReorderDtoCopyWithImpl<ReorderDto>(this as ReorderDto, _$identity);

  /// Serializes this ReorderDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReorderDto&&const DeepCollectionEquality().equals(other.ids, ids));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(ids));

@override
String toString() {
  return 'ReorderDto(ids: $ids)';
}


}

/// @nodoc
abstract mixin class $ReorderDtoCopyWith<$Res>  {
  factory $ReorderDtoCopyWith(ReorderDto value, $Res Function(ReorderDto) _then) = _$ReorderDtoCopyWithImpl;
@useResult
$Res call({
 List<String> ids
});




}
/// @nodoc
class _$ReorderDtoCopyWithImpl<$Res>
    implements $ReorderDtoCopyWith<$Res> {
  _$ReorderDtoCopyWithImpl(this._self, this._then);

  final ReorderDto _self;
  final $Res Function(ReorderDto) _then;

/// Create a copy of ReorderDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ids = null,}) {
  return _then(ReorderDto(
ids: null == ids ? _self.ids : ids // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ReorderDto].
extension ReorderDtoPatterns on ReorderDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReorderDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReorderDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReorderDto value)  $default,){
final _that = this;
switch (_that) {
case _ReorderDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReorderDto value)?  $default,){
final _that = this;
switch (_that) {
case _ReorderDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> ids)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReorderDto() when $default != null:
return $default(_that.ids);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> ids)  $default,) {final _that = this;
switch (_that) {
case _ReorderDto():
return $default(_that.ids);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> ids)?  $default,) {final _that = this;
switch (_that) {
case _ReorderDto() when $default != null:
return $default(_that.ids);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReorderDto implements ReorderDto {
  const _ReorderDto({required  List<String> ids}): _ids = ids;
  factory _ReorderDto.fromJson(Map<String, dynamic> json) => _$ReorderDtoFromJson(json);

 final  List<String> _ids;
@override List<String> get ids {
  if (_ids is EqualUnmodifiableListView) return _ids;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ids);
}


/// Create a copy of ReorderDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReorderDtoCopyWith<_ReorderDto> get copyWith => __$ReorderDtoCopyWithImpl<_ReorderDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReorderDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReorderDto&&const DeepCollectionEquality().equals(other._ids, _ids));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_ids));

@override
String toString() {
  return 'ReorderDto(ids: $ids)';
}


}

/// @nodoc
abstract mixin class _$ReorderDtoCopyWith<$Res> implements $ReorderDtoCopyWith<$Res> {
  factory _$ReorderDtoCopyWith(_ReorderDto value, $Res Function(_ReorderDto) _then) = __$ReorderDtoCopyWithImpl;
@override @useResult
$Res call({
 List<String> ids
});




}
/// @nodoc
class __$ReorderDtoCopyWithImpl<$Res>
    implements _$ReorderDtoCopyWith<$Res> {
  __$ReorderDtoCopyWithImpl(this._self, this._then);

  final _ReorderDto _self;
  final $Res Function(_ReorderDto) _then;

/// Create a copy of ReorderDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ids = null,}) {
  return _then(_ReorderDto(
ids: null == ids ? _self._ids : ids // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
