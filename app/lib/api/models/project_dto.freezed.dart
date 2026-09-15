// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectDto {

 String get id; String get name;/// Identificador público na rota de detalhe; imutável.
 String get slug; String get shortDescription; String get fullDescription; List<String> get technologies; String? get codeUrl; String? get demoUrl; int get position;/// Galeria, por `position`. A primeira é a capa.
 List<ProjectImageDto> get images; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of ProjectDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectDtoCopyWith<ProjectDto> get copyWith => _$ProjectDtoCopyWithImpl<ProjectDto>(this as ProjectDto, _$identity);

  /// Serializes this ProjectDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.shortDescription, shortDescription) || other.shortDescription == shortDescription)&&(identical(other.fullDescription, fullDescription) || other.fullDescription == fullDescription)&&const DeepCollectionEquality().equals(other.technologies, technologies)&&(identical(other.codeUrl, codeUrl) || other.codeUrl == codeUrl)&&(identical(other.demoUrl, demoUrl) || other.demoUrl == demoUrl)&&(identical(other.position, position) || other.position == position)&&const DeepCollectionEquality().equals(other.images, images)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,slug,shortDescription,fullDescription,const DeepCollectionEquality().hash(technologies),codeUrl,demoUrl,position,const DeepCollectionEquality().hash(images),createdAt,updatedAt);

@override
String toString() {
  return 'ProjectDto(id: $id, name: $name, slug: $slug, shortDescription: $shortDescription, fullDescription: $fullDescription, technologies: $technologies, codeUrl: $codeUrl, demoUrl: $demoUrl, position: $position, images: $images, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ProjectDtoCopyWith<$Res>  {
  factory $ProjectDtoCopyWith(ProjectDto value, $Res Function(ProjectDto) _then) = _$ProjectDtoCopyWithImpl;
@useResult
$Res call({
 String id, String name, String slug, String shortDescription, String fullDescription, List<String> technologies, String? codeUrl, String? demoUrl, int position, List<ProjectImageDto> images, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$ProjectDtoCopyWithImpl<$Res>
    implements $ProjectDtoCopyWith<$Res> {
  _$ProjectDtoCopyWithImpl(this._self, this._then);

  final ProjectDto _self;
  final $Res Function(ProjectDto) _then;

/// Create a copy of ProjectDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? shortDescription = null,Object? fullDescription = null,Object? technologies = null,Object? codeUrl = freezed,Object? demoUrl = freezed,Object? position = null,Object? images = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(ProjectDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,shortDescription: null == shortDescription ? _self.shortDescription : shortDescription // ignore: cast_nullable_to_non_nullable
as String,fullDescription: null == fullDescription ? _self.fullDescription : fullDescription // ignore: cast_nullable_to_non_nullable
as String,technologies: null == technologies ? _self.technologies : technologies // ignore: cast_nullable_to_non_nullable
as List<String>,codeUrl: freezed == codeUrl ? _self.codeUrl : codeUrl // ignore: cast_nullable_to_non_nullable
as String?,demoUrl: freezed == demoUrl ? _self.demoUrl : demoUrl // ignore: cast_nullable_to_non_nullable
as String?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<ProjectImageDto>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectDto].
extension ProjectDtoPatterns on ProjectDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectDto value)  $default,){
final _that = this;
switch (_that) {
case _ProjectDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String slug,  String shortDescription,  String fullDescription,  List<String> technologies,  String? codeUrl,  String? demoUrl,  int position,  List<ProjectImageDto> images,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectDto() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.shortDescription,_that.fullDescription,_that.technologies,_that.codeUrl,_that.demoUrl,_that.position,_that.images,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String slug,  String shortDescription,  String fullDescription,  List<String> technologies,  String? codeUrl,  String? demoUrl,  int position,  List<ProjectImageDto> images,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ProjectDto():
return $default(_that.id,_that.name,_that.slug,_that.shortDescription,_that.fullDescription,_that.technologies,_that.codeUrl,_that.demoUrl,_that.position,_that.images,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String slug,  String shortDescription,  String fullDescription,  List<String> technologies,  String? codeUrl,  String? demoUrl,  int position,  List<ProjectImageDto> images,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ProjectDto() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.shortDescription,_that.fullDescription,_that.technologies,_that.codeUrl,_that.demoUrl,_that.position,_that.images,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectDto implements ProjectDto {
  const _ProjectDto({required this.id, required this.name, required this.slug, required this.shortDescription, required this.fullDescription, required  List<String> technologies, required this.codeUrl, required this.demoUrl, required this.position, required  List<ProjectImageDto> images, required this.createdAt, required this.updatedAt}): _technologies = technologies,_images = images;
  factory _ProjectDto.fromJson(Map<String, dynamic> json) => _$ProjectDtoFromJson(json);

@override final  String id;
@override final  String name;
/// Identificador público na rota de detalhe; imutável.
@override final  String slug;
@override final  String shortDescription;
@override final  String fullDescription;
 final  List<String> _technologies;
@override List<String> get technologies {
  if (_technologies is EqualUnmodifiableListView) return _technologies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_technologies);
}

@override final  String? codeUrl;
@override final  String? demoUrl;
@override final  int position;
/// Galeria, por `position`. A primeira é a capa.
 final  List<ProjectImageDto> _images;
/// Galeria, por `position`. A primeira é a capa.
@override List<ProjectImageDto> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of ProjectDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectDtoCopyWith<_ProjectDto> get copyWith => __$ProjectDtoCopyWithImpl<_ProjectDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.shortDescription, shortDescription) || other.shortDescription == shortDescription)&&(identical(other.fullDescription, fullDescription) || other.fullDescription == fullDescription)&&const DeepCollectionEquality().equals(other._technologies, _technologies)&&(identical(other.codeUrl, codeUrl) || other.codeUrl == codeUrl)&&(identical(other.demoUrl, demoUrl) || other.demoUrl == demoUrl)&&(identical(other.position, position) || other.position == position)&&const DeepCollectionEquality().equals(other._images, _images)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,slug,shortDescription,fullDescription,const DeepCollectionEquality().hash(_technologies),codeUrl,demoUrl,position,const DeepCollectionEquality().hash(_images),createdAt,updatedAt);

@override
String toString() {
  return 'ProjectDto(id: $id, name: $name, slug: $slug, shortDescription: $shortDescription, fullDescription: $fullDescription, technologies: $technologies, codeUrl: $codeUrl, demoUrl: $demoUrl, position: $position, images: $images, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ProjectDtoCopyWith<$Res> implements $ProjectDtoCopyWith<$Res> {
  factory _$ProjectDtoCopyWith(_ProjectDto value, $Res Function(_ProjectDto) _then) = __$ProjectDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String slug, String shortDescription, String fullDescription, List<String> technologies, String? codeUrl, String? demoUrl, int position, List<ProjectImageDto> images, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$ProjectDtoCopyWithImpl<$Res>
    implements _$ProjectDtoCopyWith<$Res> {
  __$ProjectDtoCopyWithImpl(this._self, this._then);

  final _ProjectDto _self;
  final $Res Function(_ProjectDto) _then;

/// Create a copy of ProjectDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? shortDescription = null,Object? fullDescription = null,Object? technologies = null,Object? codeUrl = freezed,Object? demoUrl = freezed,Object? position = null,Object? images = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ProjectDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,shortDescription: null == shortDescription ? _self.shortDescription : shortDescription // ignore: cast_nullable_to_non_nullable
as String,fullDescription: null == fullDescription ? _self.fullDescription : fullDescription // ignore: cast_nullable_to_non_nullable
as String,technologies: null == technologies ? _self._technologies : technologies // ignore: cast_nullable_to_non_nullable
as List<String>,codeUrl: freezed == codeUrl ? _self.codeUrl : codeUrl // ignore: cast_nullable_to_non_nullable
as String?,demoUrl: freezed == demoUrl ? _self.demoUrl : demoUrl // ignore: cast_nullable_to_non_nullable
as String?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<ProjectImageDto>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
