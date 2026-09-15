// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_profile_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateProfileDto {

 String get name;/// Uma linha acima do nome no hero.
 String get headline;/// Parágrafo curto do hero.
 String get summary;/// Texto longo do "Sobre mim"; parágrafos separados por linha em branco.
 String get description; LocationDto get location; List<Availability> get availability; List<WorkMode> get workModes; List<LanguageDto> get languages;/// Texto de abertura da seção Contato; null = sem texto.
 String? get contactIntro;
/// Create a copy of UpdateProfileDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateProfileDtoCopyWith<UpdateProfileDto> get copyWith => _$UpdateProfileDtoCopyWithImpl<UpdateProfileDto>(this as UpdateProfileDto, _$identity);

  /// Serializes this UpdateProfileDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateProfileDto&&(identical(other.name, name) || other.name == name)&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.description, description) || other.description == description)&&(identical(other.location, location) || other.location == location)&&const DeepCollectionEquality().equals(other.availability, availability)&&const DeepCollectionEquality().equals(other.workModes, workModes)&&const DeepCollectionEquality().equals(other.languages, languages)&&(identical(other.contactIntro, contactIntro) || other.contactIntro == contactIntro));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,headline,summary,description,location,const DeepCollectionEquality().hash(availability),const DeepCollectionEquality().hash(workModes),const DeepCollectionEquality().hash(languages),contactIntro);

@override
String toString() {
  return 'UpdateProfileDto(name: $name, headline: $headline, summary: $summary, description: $description, location: $location, availability: $availability, workModes: $workModes, languages: $languages, contactIntro: $contactIntro)';
}


}

/// @nodoc
abstract mixin class $UpdateProfileDtoCopyWith<$Res>  {
  factory $UpdateProfileDtoCopyWith(UpdateProfileDto value, $Res Function(UpdateProfileDto) _then) = _$UpdateProfileDtoCopyWithImpl;
@useResult
$Res call({
 String name, String headline, String summary, String description, LocationDto location, List<Availability> availability, List<WorkMode> workModes, List<LanguageDto> languages, String? contactIntro
});


$LocationDtoCopyWith<$Res> get location;

}
/// @nodoc
class _$UpdateProfileDtoCopyWithImpl<$Res>
    implements $UpdateProfileDtoCopyWith<$Res> {
  _$UpdateProfileDtoCopyWithImpl(this._self, this._then);

  final UpdateProfileDto _self;
  final $Res Function(UpdateProfileDto) _then;

/// Create a copy of UpdateProfileDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? headline = null,Object? summary = null,Object? description = null,Object? location = null,Object? availability = null,Object? workModes = null,Object? languages = null,Object? contactIntro = freezed,}) {
  return _then(UpdateProfileDto(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,headline: null == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as LocationDto,availability: null == availability ? _self.availability : availability // ignore: cast_nullable_to_non_nullable
as List<Availability>,workModes: null == workModes ? _self.workModes : workModes // ignore: cast_nullable_to_non_nullable
as List<WorkMode>,languages: null == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as List<LanguageDto>,contactIntro: freezed == contactIntro ? _self.contactIntro : contactIntro // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of UpdateProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocationDtoCopyWith<$Res> get location {
  
  return $LocationDtoCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// Adds pattern-matching-related methods to [UpdateProfileDto].
extension UpdateProfileDtoPatterns on UpdateProfileDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateProfileDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateProfileDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateProfileDto value)  $default,){
final _that = this;
switch (_that) {
case _UpdateProfileDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateProfileDto value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateProfileDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String headline,  String summary,  String description,  LocationDto location,  List<Availability> availability,  List<WorkMode> workModes,  List<LanguageDto> languages,  String? contactIntro)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateProfileDto() when $default != null:
return $default(_that.name,_that.headline,_that.summary,_that.description,_that.location,_that.availability,_that.workModes,_that.languages,_that.contactIntro);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String headline,  String summary,  String description,  LocationDto location,  List<Availability> availability,  List<WorkMode> workModes,  List<LanguageDto> languages,  String? contactIntro)  $default,) {final _that = this;
switch (_that) {
case _UpdateProfileDto():
return $default(_that.name,_that.headline,_that.summary,_that.description,_that.location,_that.availability,_that.workModes,_that.languages,_that.contactIntro);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String headline,  String summary,  String description,  LocationDto location,  List<Availability> availability,  List<WorkMode> workModes,  List<LanguageDto> languages,  String? contactIntro)?  $default,) {final _that = this;
switch (_that) {
case _UpdateProfileDto() when $default != null:
return $default(_that.name,_that.headline,_that.summary,_that.description,_that.location,_that.availability,_that.workModes,_that.languages,_that.contactIntro);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateProfileDto implements UpdateProfileDto {
  const _UpdateProfileDto({required this.name, required this.headline, required this.summary, required this.description, required this.location, required  List<Availability> availability, required  List<WorkMode> workModes, required  List<LanguageDto> languages, this.contactIntro}): _availability = availability,_workModes = workModes,_languages = languages;
  factory _UpdateProfileDto.fromJson(Map<String, dynamic> json) => _$UpdateProfileDtoFromJson(json);

@override final  String name;
/// Uma linha acima do nome no hero.
@override final  String headline;
/// Parágrafo curto do hero.
@override final  String summary;
/// Texto longo do "Sobre mim"; parágrafos separados por linha em branco.
@override final  String description;
@override final  LocationDto location;
 final  List<Availability> _availability;
@override List<Availability> get availability {
  if (_availability is EqualUnmodifiableListView) return _availability;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availability);
}

 final  List<WorkMode> _workModes;
@override List<WorkMode> get workModes {
  if (_workModes is EqualUnmodifiableListView) return _workModes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_workModes);
}

 final  List<LanguageDto> _languages;
@override List<LanguageDto> get languages {
  if (_languages is EqualUnmodifiableListView) return _languages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_languages);
}

/// Texto de abertura da seção Contato; null = sem texto.
@override final  String? contactIntro;

/// Create a copy of UpdateProfileDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateProfileDtoCopyWith<_UpdateProfileDto> get copyWith => __$UpdateProfileDtoCopyWithImpl<_UpdateProfileDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateProfileDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateProfileDto&&(identical(other.name, name) || other.name == name)&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.description, description) || other.description == description)&&(identical(other.location, location) || other.location == location)&&const DeepCollectionEquality().equals(other._availability, _availability)&&const DeepCollectionEquality().equals(other._workModes, _workModes)&&const DeepCollectionEquality().equals(other._languages, _languages)&&(identical(other.contactIntro, contactIntro) || other.contactIntro == contactIntro));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,headline,summary,description,location,const DeepCollectionEquality().hash(_availability),const DeepCollectionEquality().hash(_workModes),const DeepCollectionEquality().hash(_languages),contactIntro);

@override
String toString() {
  return 'UpdateProfileDto(name: $name, headline: $headline, summary: $summary, description: $description, location: $location, availability: $availability, workModes: $workModes, languages: $languages, contactIntro: $contactIntro)';
}


}

/// @nodoc
abstract mixin class _$UpdateProfileDtoCopyWith<$Res> implements $UpdateProfileDtoCopyWith<$Res> {
  factory _$UpdateProfileDtoCopyWith(_UpdateProfileDto value, $Res Function(_UpdateProfileDto) _then) = __$UpdateProfileDtoCopyWithImpl;
@override @useResult
$Res call({
 String name, String headline, String summary, String description, LocationDto location, List<Availability> availability, List<WorkMode> workModes, List<LanguageDto> languages, String? contactIntro
});


@override $LocationDtoCopyWith<$Res> get location;

}
/// @nodoc
class __$UpdateProfileDtoCopyWithImpl<$Res>
    implements _$UpdateProfileDtoCopyWith<$Res> {
  __$UpdateProfileDtoCopyWithImpl(this._self, this._then);

  final _UpdateProfileDto _self;
  final $Res Function(_UpdateProfileDto) _then;

/// Create a copy of UpdateProfileDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? headline = null,Object? summary = null,Object? description = null,Object? location = null,Object? availability = null,Object? workModes = null,Object? languages = null,Object? contactIntro = freezed,}) {
  return _then(_UpdateProfileDto(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,headline: null == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as LocationDto,availability: null == availability ? _self._availability : availability // ignore: cast_nullable_to_non_nullable
as List<Availability>,workModes: null == workModes ? _self._workModes : workModes // ignore: cast_nullable_to_non_nullable
as List<WorkMode>,languages: null == languages ? _self._languages : languages // ignore: cast_nullable_to_non_nullable
as List<LanguageDto>,contactIntro: freezed == contactIntro ? _self.contactIntro : contactIntro // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of UpdateProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocationDtoCopyWith<$Res> get location {
  
  return $LocationDtoCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}

// dart format on
