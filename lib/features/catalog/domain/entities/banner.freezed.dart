// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'banner.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CatalogBanner {

 String get id; String get name; String get imageUrl; CatalogBannerTarget get target; String? get targetId; String? get targetName;
/// Create a copy of CatalogBanner
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogBannerCopyWith<CatalogBanner> get copyWith => _$CatalogBannerCopyWithImpl<CatalogBanner>(this as CatalogBanner, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogBanner&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.target, target) || other.target == target)&&(identical(other.targetId, targetId) || other.targetId == targetId)&&(identical(other.targetName, targetName) || other.targetName == targetName));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,imageUrl,target,targetId,targetName);

@override
String toString() {
  return 'CatalogBanner(id: $id, name: $name, imageUrl: $imageUrl, target: $target, targetId: $targetId, targetName: $targetName)';
}


}

/// @nodoc
abstract mixin class $CatalogBannerCopyWith<$Res>  {
  factory $CatalogBannerCopyWith(CatalogBanner value, $Res Function(CatalogBanner) _then) = _$CatalogBannerCopyWithImpl;
@useResult
$Res call({
 String id, String name, String imageUrl, CatalogBannerTarget target, String? targetId, String? targetName
});




}
/// @nodoc
class _$CatalogBannerCopyWithImpl<$Res>
    implements $CatalogBannerCopyWith<$Res> {
  _$CatalogBannerCopyWithImpl(this._self, this._then);

  final CatalogBanner _self;
  final $Res Function(CatalogBanner) _then;

/// Create a copy of CatalogBanner
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? imageUrl = null,Object? target = null,Object? targetId = freezed,Object? targetName = freezed,}) {
  return _then(CatalogBanner(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as CatalogBannerTarget,targetId: freezed == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String?,targetName: freezed == targetName ? _self.targetName : targetName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CatalogBanner].
extension CatalogBannerPatterns on CatalogBanner {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogBanner value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogBanner() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogBanner value)  $default,){
final _that = this;
switch (_that) {
case _CatalogBanner():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogBanner value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogBanner() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String imageUrl,  CatalogBannerTarget target,  String? targetId,  String? targetName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogBanner() when $default != null:
return $default(_that.id,_that.name,_that.imageUrl,_that.target,_that.targetId,_that.targetName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String imageUrl,  CatalogBannerTarget target,  String? targetId,  String? targetName)  $default,) {final _that = this;
switch (_that) {
case _CatalogBanner():
return $default(_that.id,_that.name,_that.imageUrl,_that.target,_that.targetId,_that.targetName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String imageUrl,  CatalogBannerTarget target,  String? targetId,  String? targetName)?  $default,) {final _that = this;
switch (_that) {
case _CatalogBanner() when $default != null:
return $default(_that.id,_that.name,_that.imageUrl,_that.target,_that.targetId,_that.targetName);case _:
  return null;

}
}

}

/// @nodoc


class _CatalogBanner implements CatalogBanner {
  const _CatalogBanner({required this.id, required this.name, required this.imageUrl, this.target = CatalogBannerTarget.none, this.targetId, this.targetName});
  

@override final  String id;
@override final  String name;
@override final  String imageUrl;
@override@JsonKey() final  CatalogBannerTarget target;
@override final  String? targetId;
@override final  String? targetName;

/// Create a copy of CatalogBanner
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogBannerCopyWith<_CatalogBanner> get copyWith => __$CatalogBannerCopyWithImpl<_CatalogBanner>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogBanner&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.target, target) || other.target == target)&&(identical(other.targetId, targetId) || other.targetId == targetId)&&(identical(other.targetName, targetName) || other.targetName == targetName));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,imageUrl,target,targetId,targetName);

@override
String toString() {
  return 'CatalogBanner(id: $id, name: $name, imageUrl: $imageUrl, target: $target, targetId: $targetId, targetName: $targetName)';
}


}

/// @nodoc
abstract mixin class _$CatalogBannerCopyWith<$Res> implements $CatalogBannerCopyWith<$Res> {
  factory _$CatalogBannerCopyWith(_CatalogBanner value, $Res Function(_CatalogBanner) _then) = __$CatalogBannerCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String imageUrl, CatalogBannerTarget target, String? targetId, String? targetName
});




}
/// @nodoc
class __$CatalogBannerCopyWithImpl<$Res>
    implements _$CatalogBannerCopyWith<$Res> {
  __$CatalogBannerCopyWithImpl(this._self, this._then);

  final _CatalogBanner _self;
  final $Res Function(_CatalogBanner) _then;

/// Create a copy of CatalogBanner
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? imageUrl = null,Object? target = null,Object? targetId = freezed,Object? targetName = freezed,}) {
  return _then(_CatalogBanner(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as CatalogBannerTarget,targetId: freezed == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String?,targetName: freezed == targetName ? _self.targetName : targetName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
