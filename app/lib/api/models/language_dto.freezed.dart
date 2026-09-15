// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'language_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LanguageDto {

/// Nome do idioma, texto livre em PT-BR.
 String get language; LanguageLevel get level;
/// Create a copy of LanguageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LanguageDtoCopyWith<LanguageDto> get copyWith => _$LanguageDtoCopyWithImpl<LanguageDto>(this as LanguageDto, _$identity);

  /// Serializes this LanguageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LanguageDto&&(identical(other.language, language) || other.language == language)&&(identical(other.level, level) || other.level == level));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,language,level);

@override
String toString() {
  return 'LanguageDto(language: $language, level: $level)';
}


}

/// @nodoc
abstract mixin class $LanguageDtoCopyWith<$Res>  {
  factory $LanguageDtoCopyWith(LanguageDto value, $Res Function(LanguageDto) _then) = _$LanguageDtoCopyWithImpl;
@useResult
$Res call({
 String language, LanguageLevel level
});




}
/// @nodoc
class _$LanguageDtoCopyWithImpl<$Res>
    implements $LanguageDtoCopyWith<$Res> {
  _$LanguageDtoCopyWithImpl(this._self, this._then);

  final LanguageDto _self;
  final $Res Function(LanguageDto) _then;

/// Create a copy of LanguageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? language = null,Object? level = null,}) {
  return _then(LanguageDto(
language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as LanguageLevel,
  ));
}

}


/// Adds pattern-matching-related methods to [LanguageDto].
extension LanguageDtoPatterns on LanguageDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LanguageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LanguageDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LanguageDto value)  $default,){
final _that = this;
switch (_that) {
case _LanguageDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LanguageDto value)?  $default,){
final _that = this;
switch (_that) {
case _LanguageDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String language,  LanguageLevel level)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LanguageDto() when $default != null:
return $default(_that.language,_that.level);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String language,  LanguageLevel level)  $default,) {final _that = this;
switch (_that) {
case _LanguageDto():
return $default(_that.language,_that.level);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String language,  LanguageLevel level)?  $default,) {final _that = this;
switch (_that) {
case _LanguageDto() when $default != null:
return $default(_that.language,_that.level);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LanguageDto implements LanguageDto {
  const _LanguageDto({required this.language, required this.level});
  factory _LanguageDto.fromJson(Map<String, dynamic> json) => _$LanguageDtoFromJson(json);

/// Nome do idioma, texto livre em PT-BR.
@override final  String language;
@override final  LanguageLevel level;

/// Create a copy of LanguageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LanguageDtoCopyWith<_LanguageDto> get copyWith => __$LanguageDtoCopyWithImpl<_LanguageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LanguageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LanguageDto&&(identical(other.language, language) || other.language == language)&&(identical(other.level, level) || other.level == level));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,language,level);

@override
String toString() {
  return 'LanguageDto(language: $language, level: $level)';
}


}

/// @nodoc
abstract mixin class _$LanguageDtoCopyWith<$Res> implements $LanguageDtoCopyWith<$Res> {
  factory _$LanguageDtoCopyWith(_LanguageDto value, $Res Function(_LanguageDto) _then) = __$LanguageDtoCopyWithImpl;
@override @useResult
$Res call({
 String language, LanguageLevel level
});




}
/// @nodoc
class __$LanguageDtoCopyWithImpl<$Res>
    implements _$LanguageDtoCopyWith<$Res> {
  __$LanguageDtoCopyWithImpl(this._self, this._then);

  final _LanguageDto _self;
  final $Res Function(_LanguageDto) _then;

/// Create a copy of LanguageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? language = null,Object? level = null,}) {
  return _then(_LanguageDto(
language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as LanguageLevel,
  ));
}


}

// dart format on
