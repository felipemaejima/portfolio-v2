// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_input_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectInputDto {

 String get name;/// Usada na listagem/cards.
 String get shortDescription;/// Usada no detalhe.
 String get fullDescription; List<String> get technologies; String? get codeUrl; String? get demoUrl;
/// Create a copy of ProjectInputDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectInputDtoCopyWith<ProjectInputDto> get copyWith => _$ProjectInputDtoCopyWithImpl<ProjectInputDto>(this as ProjectInputDto, _$identity);

  /// Serializes this ProjectInputDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectInputDto&&(identical(other.name, name) || other.name == name)&&(identical(other.shortDescription, shortDescription) || other.shortDescription == shortDescription)&&(identical(other.fullDescription, fullDescription) || other.fullDescription == fullDescription)&&const DeepCollectionEquality().equals(other.technologies, technologies)&&(identical(other.codeUrl, codeUrl) || other.codeUrl == codeUrl)&&(identical(other.demoUrl, demoUrl) || other.demoUrl == demoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,shortDescription,fullDescription,const DeepCollectionEquality().hash(technologies),codeUrl,demoUrl);

@override
String toString() {
  return 'ProjectInputDto(name: $name, shortDescription: $shortDescription, fullDescription: $fullDescription, technologies: $technologies, codeUrl: $codeUrl, demoUrl: $demoUrl)';
}


}

/// @nodoc
abstract mixin class $ProjectInputDtoCopyWith<$Res>  {
  factory $ProjectInputDtoCopyWith(ProjectInputDto value, $Res Function(ProjectInputDto) _then) = _$ProjectInputDtoCopyWithImpl;
@useResult
$Res call({
 String name, String shortDescription, String fullDescription, List<String> technologies, String? codeUrl, String? demoUrl
});




}
/// @nodoc
class _$ProjectInputDtoCopyWithImpl<$Res>
    implements $ProjectInputDtoCopyWith<$Res> {
  _$ProjectInputDtoCopyWithImpl(this._self, this._then);

  final ProjectInputDto _self;
  final $Res Function(ProjectInputDto) _then;

/// Create a copy of ProjectInputDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? shortDescription = null,Object? fullDescription = null,Object? technologies = null,Object? codeUrl = freezed,Object? demoUrl = freezed,}) {
  return _then(ProjectInputDto(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,shortDescription: null == shortDescription ? _self.shortDescription : shortDescription // ignore: cast_nullable_to_non_nullable
as String,fullDescription: null == fullDescription ? _self.fullDescription : fullDescription // ignore: cast_nullable_to_non_nullable
as String,technologies: null == technologies ? _self.technologies : technologies // ignore: cast_nullable_to_non_nullable
as List<String>,codeUrl: freezed == codeUrl ? _self.codeUrl : codeUrl // ignore: cast_nullable_to_non_nullable
as String?,demoUrl: freezed == demoUrl ? _self.demoUrl : demoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectInputDto].
extension ProjectInputDtoPatterns on ProjectInputDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectInputDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectInputDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectInputDto value)  $default,){
final _that = this;
switch (_that) {
case _ProjectInputDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectInputDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectInputDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String shortDescription,  String fullDescription,  List<String> technologies,  String? codeUrl,  String? demoUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectInputDto() when $default != null:
return $default(_that.name,_that.shortDescription,_that.fullDescription,_that.technologies,_that.codeUrl,_that.demoUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String shortDescription,  String fullDescription,  List<String> technologies,  String? codeUrl,  String? demoUrl)  $default,) {final _that = this;
switch (_that) {
case _ProjectInputDto():
return $default(_that.name,_that.shortDescription,_that.fullDescription,_that.technologies,_that.codeUrl,_that.demoUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String shortDescription,  String fullDescription,  List<String> technologies,  String? codeUrl,  String? demoUrl)?  $default,) {final _that = this;
switch (_that) {
case _ProjectInputDto() when $default != null:
return $default(_that.name,_that.shortDescription,_that.fullDescription,_that.technologies,_that.codeUrl,_that.demoUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectInputDto implements ProjectInputDto {
  const _ProjectInputDto({required this.name, required this.shortDescription, required this.fullDescription, required  List<String> technologies, this.codeUrl, this.demoUrl}): _technologies = technologies;
  factory _ProjectInputDto.fromJson(Map<String, dynamic> json) => _$ProjectInputDtoFromJson(json);

@override final  String name;
/// Usada na listagem/cards.
@override final  String shortDescription;
/// Usada no detalhe.
@override final  String fullDescription;
 final  List<String> _technologies;
@override List<String> get technologies {
  if (_technologies is EqualUnmodifiableListView) return _technologies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_technologies);
}

@override final  String? codeUrl;
@override final  String? demoUrl;

/// Create a copy of ProjectInputDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectInputDtoCopyWith<_ProjectInputDto> get copyWith => __$ProjectInputDtoCopyWithImpl<_ProjectInputDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectInputDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectInputDto&&(identical(other.name, name) || other.name == name)&&(identical(other.shortDescription, shortDescription) || other.shortDescription == shortDescription)&&(identical(other.fullDescription, fullDescription) || other.fullDescription == fullDescription)&&const DeepCollectionEquality().equals(other._technologies, _technologies)&&(identical(other.codeUrl, codeUrl) || other.codeUrl == codeUrl)&&(identical(other.demoUrl, demoUrl) || other.demoUrl == demoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,shortDescription,fullDescription,const DeepCollectionEquality().hash(_technologies),codeUrl,demoUrl);

@override
String toString() {
  return 'ProjectInputDto(name: $name, shortDescription: $shortDescription, fullDescription: $fullDescription, technologies: $technologies, codeUrl: $codeUrl, demoUrl: $demoUrl)';
}


}

/// @nodoc
abstract mixin class _$ProjectInputDtoCopyWith<$Res> implements $ProjectInputDtoCopyWith<$Res> {
  factory _$ProjectInputDtoCopyWith(_ProjectInputDto value, $Res Function(_ProjectInputDto) _then) = __$ProjectInputDtoCopyWithImpl;
@override @useResult
$Res call({
 String name, String shortDescription, String fullDescription, List<String> technologies, String? codeUrl, String? demoUrl
});




}
/// @nodoc
class __$ProjectInputDtoCopyWithImpl<$Res>
    implements _$ProjectInputDtoCopyWith<$Res> {
  __$ProjectInputDtoCopyWithImpl(this._self, this._then);

  final _ProjectInputDto _self;
  final $Res Function(_ProjectInputDto) _then;

/// Create a copy of ProjectInputDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? shortDescription = null,Object? fullDescription = null,Object? technologies = null,Object? codeUrl = freezed,Object? demoUrl = freezed,}) {
  return _then(_ProjectInputDto(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,shortDescription: null == shortDescription ? _self.shortDescription : shortDescription // ignore: cast_nullable_to_non_nullable
as String,fullDescription: null == fullDescription ? _self.fullDescription : fullDescription // ignore: cast_nullable_to_non_nullable
as String,technologies: null == technologies ? _self._technologies : technologies // ignore: cast_nullable_to_non_nullable
as List<String>,codeUrl: freezed == codeUrl ? _self.codeUrl : codeUrl // ignore: cast_nullable_to_non_nullable
as String?,demoUrl: freezed == demoUrl ? _self.demoUrl : demoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
