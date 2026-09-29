// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BusinessProfile {

 String get id; String get name; String get description; String? get imageUrl;
/// Create a copy of BusinessProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BusinessProfileCopyWith<BusinessProfile> get copyWith => _$BusinessProfileCopyWithImpl<BusinessProfile>(this as BusinessProfile, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BusinessProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,imageUrl);

@override
String toString() {
  return 'BusinessProfile(id: $id, name: $name, description: $description, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $BusinessProfileCopyWith<$Res>  {
  factory $BusinessProfileCopyWith(BusinessProfile value, $Res Function(BusinessProfile) _then) = _$BusinessProfileCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, String? imageUrl
});




}
/// @nodoc
class _$BusinessProfileCopyWithImpl<$Res>
    implements $BusinessProfileCopyWith<$Res> {
  _$BusinessProfileCopyWithImpl(this._self, this._then);

  final BusinessProfile _self;
  final $Res Function(BusinessProfile) _then;

/// Create a copy of BusinessProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? imageUrl = freezed,}) {
  return _then(BusinessProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BusinessProfile].
extension BusinessProfilePatterns on BusinessProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BusinessProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BusinessProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BusinessProfile value)  $default,){
final _that = this;
switch (_that) {
case _BusinessProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BusinessProfile value)?  $default,){
final _that = this;
switch (_that) {
case _BusinessProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BusinessProfile() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _BusinessProfile():
return $default(_that.id,_that.name,_that.description,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _BusinessProfile() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc


class _BusinessProfile implements BusinessProfile {
  const _BusinessProfile({required this.id, required this.name, this.description = '', this.imageUrl});
  

@override final  String id;
@override final  String name;
@override@JsonKey() final  String description;
@override final  String? imageUrl;

/// Create a copy of BusinessProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BusinessProfileCopyWith<_BusinessProfile> get copyWith => __$BusinessProfileCopyWithImpl<_BusinessProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BusinessProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,imageUrl);

@override
String toString() {
  return 'BusinessProfile(id: $id, name: $name, description: $description, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$BusinessProfileCopyWith<$Res> implements $BusinessProfileCopyWith<$Res> {
  factory _$BusinessProfileCopyWith(_BusinessProfile value, $Res Function(_BusinessProfile) _then) = __$BusinessProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, String? imageUrl
});




}
/// @nodoc
class __$BusinessProfileCopyWithImpl<$Res>
    implements _$BusinessProfileCopyWith<$Res> {
  __$BusinessProfileCopyWithImpl(this._self, this._then);

  final _BusinessProfile _self;
  final $Res Function(_BusinessProfile) _then;

/// Create a copy of BusinessProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? imageUrl = freezed,}) {
  return _then(_BusinessProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$BusinessProduct {

 String get id; String get categoryId; String get name; String get description; int get basePriceMinor; bool get archived; List<ManagementVariant> get variants; List<BusinessProductImage> get images;
/// Create a copy of BusinessProduct
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BusinessProductCopyWith<BusinessProduct> get copyWith => _$BusinessProductCopyWithImpl<BusinessProduct>(this as BusinessProduct, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BusinessProduct&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.basePriceMinor, basePriceMinor) || other.basePriceMinor == basePriceMinor)&&(identical(other.archived, archived) || other.archived == archived)&&const DeepCollectionEquality().equals(other.variants, variants)&&const DeepCollectionEquality().equals(other.images, images));
}


@override
int get hashCode => Object.hash(runtimeType,id,categoryId,name,description,basePriceMinor,archived,const DeepCollectionEquality().hash(variants),const DeepCollectionEquality().hash(images));

@override
String toString() {
  return 'BusinessProduct(id: $id, categoryId: $categoryId, name: $name, description: $description, basePriceMinor: $basePriceMinor, archived: $archived, variants: $variants, images: $images)';
}


}

/// @nodoc
abstract mixin class $BusinessProductCopyWith<$Res>  {
  factory $BusinessProductCopyWith(BusinessProduct value, $Res Function(BusinessProduct) _then) = _$BusinessProductCopyWithImpl;
@useResult
$Res call({
 String id, String categoryId, String name, String description, int basePriceMinor, bool archived, List<ManagementVariant> variants, List<BusinessProductImage> images
});




}
/// @nodoc
class _$BusinessProductCopyWithImpl<$Res>
    implements $BusinessProductCopyWith<$Res> {
  _$BusinessProductCopyWithImpl(this._self, this._then);

  final BusinessProduct _self;
  final $Res Function(BusinessProduct) _then;

/// Create a copy of BusinessProduct
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? categoryId = null,Object? name = null,Object? description = null,Object? basePriceMinor = null,Object? archived = null,Object? variants = null,Object? images = null,}) {
  return _then(BusinessProduct(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,basePriceMinor: null == basePriceMinor ? _self.basePriceMinor : basePriceMinor // ignore: cast_nullable_to_non_nullable
as int,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,variants: null == variants ? _self.variants : variants // ignore: cast_nullable_to_non_nullable
as List<ManagementVariant>,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<BusinessProductImage>,
  ));
}

}


/// Adds pattern-matching-related methods to [BusinessProduct].
extension BusinessProductPatterns on BusinessProduct {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BusinessProduct value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BusinessProduct() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BusinessProduct value)  $default,){
final _that = this;
switch (_that) {
case _BusinessProduct():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BusinessProduct value)?  $default,){
final _that = this;
switch (_that) {
case _BusinessProduct() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String categoryId,  String name,  String description,  int basePriceMinor,  bool archived,  List<ManagementVariant> variants,  List<BusinessProductImage> images)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BusinessProduct() when $default != null:
return $default(_that.id,_that.categoryId,_that.name,_that.description,_that.basePriceMinor,_that.archived,_that.variants,_that.images);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String categoryId,  String name,  String description,  int basePriceMinor,  bool archived,  List<ManagementVariant> variants,  List<BusinessProductImage> images)  $default,) {final _that = this;
switch (_that) {
case _BusinessProduct():
return $default(_that.id,_that.categoryId,_that.name,_that.description,_that.basePriceMinor,_that.archived,_that.variants,_that.images);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String categoryId,  String name,  String description,  int basePriceMinor,  bool archived,  List<ManagementVariant> variants,  List<BusinessProductImage> images)?  $default,) {final _that = this;
switch (_that) {
case _BusinessProduct() when $default != null:
return $default(_that.id,_that.categoryId,_that.name,_that.description,_that.basePriceMinor,_that.archived,_that.variants,_that.images);case _:
  return null;

}
}

}

/// @nodoc


class _BusinessProduct implements BusinessProduct {
  const _BusinessProduct({required this.id, required this.categoryId, required this.name, this.description = '', required this.basePriceMinor, required this.archived, required  List<ManagementVariant> variants,  List<BusinessProductImage> images = const []}): _variants = variants,_images = images;
  

@override final  String id;
@override final  String categoryId;
@override final  String name;
@override@JsonKey() final  String description;
@override final  int basePriceMinor;
@override final  bool archived;
 final  List<ManagementVariant> _variants;
@override List<ManagementVariant> get variants {
  if (_variants is EqualUnmodifiableListView) return _variants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_variants);
}

 final  List<BusinessProductImage> _images;
@override@JsonKey() List<BusinessProductImage> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}


/// Create a copy of BusinessProduct
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BusinessProductCopyWith<_BusinessProduct> get copyWith => __$BusinessProductCopyWithImpl<_BusinessProduct>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BusinessProduct&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.basePriceMinor, basePriceMinor) || other.basePriceMinor == basePriceMinor)&&(identical(other.archived, archived) || other.archived == archived)&&const DeepCollectionEquality().equals(other._variants, _variants)&&const DeepCollectionEquality().equals(other._images, _images));
}


@override
int get hashCode => Object.hash(runtimeType,id,categoryId,name,description,basePriceMinor,archived,const DeepCollectionEquality().hash(_variants),const DeepCollectionEquality().hash(_images));

@override
String toString() {
  return 'BusinessProduct(id: $id, categoryId: $categoryId, name: $name, description: $description, basePriceMinor: $basePriceMinor, archived: $archived, variants: $variants, images: $images)';
}


}

/// @nodoc
abstract mixin class _$BusinessProductCopyWith<$Res> implements $BusinessProductCopyWith<$Res> {
  factory _$BusinessProductCopyWith(_BusinessProduct value, $Res Function(_BusinessProduct) _then) = __$BusinessProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String categoryId, String name, String description, int basePriceMinor, bool archived, List<ManagementVariant> variants, List<BusinessProductImage> images
});




}
/// @nodoc
class __$BusinessProductCopyWithImpl<$Res>
    implements _$BusinessProductCopyWith<$Res> {
  __$BusinessProductCopyWithImpl(this._self, this._then);

  final _BusinessProduct _self;
  final $Res Function(_BusinessProduct) _then;

/// Create a copy of BusinessProduct
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? categoryId = null,Object? name = null,Object? description = null,Object? basePriceMinor = null,Object? archived = null,Object? variants = null,Object? images = null,}) {
  return _then(_BusinessProduct(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,basePriceMinor: null == basePriceMinor ? _self.basePriceMinor : basePriceMinor // ignore: cast_nullable_to_non_nullable
as int,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,variants: null == variants ? _self._variants : variants // ignore: cast_nullable_to_non_nullable
as List<ManagementVariant>,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<BusinessProductImage>,
  ));
}


}

/// @nodoc
mixin _$BusinessProductImage {

 String get id; String get storagePath; String get url;
/// Create a copy of BusinessProductImage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BusinessProductImageCopyWith<BusinessProductImage> get copyWith => _$BusinessProductImageCopyWithImpl<BusinessProductImage>(this as BusinessProductImage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BusinessProductImage&&(identical(other.id, id) || other.id == id)&&(identical(other.storagePath, storagePath) || other.storagePath == storagePath)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,id,storagePath,url);

@override
String toString() {
  return 'BusinessProductImage(id: $id, storagePath: $storagePath, url: $url)';
}


}

/// @nodoc
abstract mixin class $BusinessProductImageCopyWith<$Res>  {
  factory $BusinessProductImageCopyWith(BusinessProductImage value, $Res Function(BusinessProductImage) _then) = _$BusinessProductImageCopyWithImpl;
@useResult
$Res call({
 String id, String storagePath, String url
});




}
/// @nodoc
class _$BusinessProductImageCopyWithImpl<$Res>
    implements $BusinessProductImageCopyWith<$Res> {
  _$BusinessProductImageCopyWithImpl(this._self, this._then);

  final BusinessProductImage _self;
  final $Res Function(BusinessProductImage) _then;

/// Create a copy of BusinessProductImage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? storagePath = null,Object? url = null,}) {
  return _then(BusinessProductImage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storagePath: null == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BusinessProductImage].
extension BusinessProductImagePatterns on BusinessProductImage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BusinessProductImage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BusinessProductImage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BusinessProductImage value)  $default,){
final _that = this;
switch (_that) {
case _BusinessProductImage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BusinessProductImage value)?  $default,){
final _that = this;
switch (_that) {
case _BusinessProductImage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String storagePath,  String url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BusinessProductImage() when $default != null:
return $default(_that.id,_that.storagePath,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String storagePath,  String url)  $default,) {final _that = this;
switch (_that) {
case _BusinessProductImage():
return $default(_that.id,_that.storagePath,_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String storagePath,  String url)?  $default,) {final _that = this;
switch (_that) {
case _BusinessProductImage() when $default != null:
return $default(_that.id,_that.storagePath,_that.url);case _:
  return null;

}
}

}

/// @nodoc


class _BusinessProductImage implements BusinessProductImage {
  const _BusinessProductImage({required this.id, required this.storagePath, required this.url});
  

@override final  String id;
@override final  String storagePath;
@override final  String url;

/// Create a copy of BusinessProductImage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BusinessProductImageCopyWith<_BusinessProductImage> get copyWith => __$BusinessProductImageCopyWithImpl<_BusinessProductImage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BusinessProductImage&&(identical(other.id, id) || other.id == id)&&(identical(other.storagePath, storagePath) || other.storagePath == storagePath)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,id,storagePath,url);

@override
String toString() {
  return 'BusinessProductImage(id: $id, storagePath: $storagePath, url: $url)';
}


}

/// @nodoc
abstract mixin class _$BusinessProductImageCopyWith<$Res> implements $BusinessProductImageCopyWith<$Res> {
  factory _$BusinessProductImageCopyWith(_BusinessProductImage value, $Res Function(_BusinessProductImage) _then) = __$BusinessProductImageCopyWithImpl;
@override @useResult
$Res call({
 String id, String storagePath, String url
});




}
/// @nodoc
class __$BusinessProductImageCopyWithImpl<$Res>
    implements _$BusinessProductImageCopyWith<$Res> {
  __$BusinessProductImageCopyWithImpl(this._self, this._then);

  final _BusinessProductImage _self;
  final $Res Function(_BusinessProductImage) _then;

/// Create a copy of BusinessProductImage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? storagePath = null,Object? url = null,}) {
  return _then(_BusinessProductImage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storagePath: null == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ImagePickDraft {

 String get filePath; String get fileName;
/// Create a copy of ImagePickDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImagePickDraftCopyWith<ImagePickDraft> get copyWith => _$ImagePickDraftCopyWithImpl<ImagePickDraft>(this as ImagePickDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImagePickDraft&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.fileName, fileName) || other.fileName == fileName));
}


@override
int get hashCode => Object.hash(runtimeType,filePath,fileName);

@override
String toString() {
  return 'ImagePickDraft(filePath: $filePath, fileName: $fileName)';
}


}

/// @nodoc
abstract mixin class $ImagePickDraftCopyWith<$Res>  {
  factory $ImagePickDraftCopyWith(ImagePickDraft value, $Res Function(ImagePickDraft) _then) = _$ImagePickDraftCopyWithImpl;
@useResult
$Res call({
 String filePath, String fileName
});




}
/// @nodoc
class _$ImagePickDraftCopyWithImpl<$Res>
    implements $ImagePickDraftCopyWith<$Res> {
  _$ImagePickDraftCopyWithImpl(this._self, this._then);

  final ImagePickDraft _self;
  final $Res Function(ImagePickDraft) _then;

/// Create a copy of ImagePickDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? filePath = null,Object? fileName = null,}) {
  return _then(ImagePickDraft(
filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ImagePickDraft].
extension ImagePickDraftPatterns on ImagePickDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImagePickDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImagePickDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImagePickDraft value)  $default,){
final _that = this;
switch (_that) {
case _ImagePickDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImagePickDraft value)?  $default,){
final _that = this;
switch (_that) {
case _ImagePickDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String filePath,  String fileName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImagePickDraft() when $default != null:
return $default(_that.filePath,_that.fileName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String filePath,  String fileName)  $default,) {final _that = this;
switch (_that) {
case _ImagePickDraft():
return $default(_that.filePath,_that.fileName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String filePath,  String fileName)?  $default,) {final _that = this;
switch (_that) {
case _ImagePickDraft() when $default != null:
return $default(_that.filePath,_that.fileName);case _:
  return null;

}
}

}

/// @nodoc


class _ImagePickDraft implements ImagePickDraft {
  const _ImagePickDraft({required this.filePath, required this.fileName});
  

@override final  String filePath;
@override final  String fileName;

/// Create a copy of ImagePickDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImagePickDraftCopyWith<_ImagePickDraft> get copyWith => __$ImagePickDraftCopyWithImpl<_ImagePickDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImagePickDraft&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.fileName, fileName) || other.fileName == fileName));
}


@override
int get hashCode => Object.hash(runtimeType,filePath,fileName);

@override
String toString() {
  return 'ImagePickDraft(filePath: $filePath, fileName: $fileName)';
}


}

/// @nodoc
abstract mixin class _$ImagePickDraftCopyWith<$Res> implements $ImagePickDraftCopyWith<$Res> {
  factory _$ImagePickDraftCopyWith(_ImagePickDraft value, $Res Function(_ImagePickDraft) _then) = __$ImagePickDraftCopyWithImpl;
@override @useResult
$Res call({
 String filePath, String fileName
});




}
/// @nodoc
class __$ImagePickDraftCopyWithImpl<$Res>
    implements _$ImagePickDraftCopyWith<$Res> {
  __$ImagePickDraftCopyWithImpl(this._self, this._then);

  final _ImagePickDraft _self;
  final $Res Function(_ImagePickDraft) _then;

/// Create a copy of ImagePickDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? filePath = null,Object? fileName = null,}) {
  return _then(_ImagePickDraft(
filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ManagementVariant {

 String get id; String get name; int? get priceMinor; String? get imagePath; String? get imageUrl;
/// Create a copy of ManagementVariant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ManagementVariantCopyWith<ManagementVariant> get copyWith => _$ManagementVariantCopyWithImpl<ManagementVariant>(this as ManagementVariant, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ManagementVariant&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.priceMinor, priceMinor) || other.priceMinor == priceMinor)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,priceMinor,imagePath,imageUrl);

@override
String toString() {
  return 'ManagementVariant(id: $id, name: $name, priceMinor: $priceMinor, imagePath: $imagePath, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $ManagementVariantCopyWith<$Res>  {
  factory $ManagementVariantCopyWith(ManagementVariant value, $Res Function(ManagementVariant) _then) = _$ManagementVariantCopyWithImpl;
@useResult
$Res call({
 String id, String name, int? priceMinor, String? imagePath, String? imageUrl
});




}
/// @nodoc
class _$ManagementVariantCopyWithImpl<$Res>
    implements $ManagementVariantCopyWith<$Res> {
  _$ManagementVariantCopyWithImpl(this._self, this._then);

  final ManagementVariant _self;
  final $Res Function(ManagementVariant) _then;

/// Create a copy of ManagementVariant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? priceMinor = freezed,Object? imagePath = freezed,Object? imageUrl = freezed,}) {
  return _then(ManagementVariant(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceMinor: freezed == priceMinor ? _self.priceMinor : priceMinor // ignore: cast_nullable_to_non_nullable
as int?,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ManagementVariant].
extension ManagementVariantPatterns on ManagementVariant {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ManagementVariant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ManagementVariant() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ManagementVariant value)  $default,){
final _that = this;
switch (_that) {
case _ManagementVariant():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ManagementVariant value)?  $default,){
final _that = this;
switch (_that) {
case _ManagementVariant() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int? priceMinor,  String? imagePath,  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ManagementVariant() when $default != null:
return $default(_that.id,_that.name,_that.priceMinor,_that.imagePath,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int? priceMinor,  String? imagePath,  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _ManagementVariant():
return $default(_that.id,_that.name,_that.priceMinor,_that.imagePath,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int? priceMinor,  String? imagePath,  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _ManagementVariant() when $default != null:
return $default(_that.id,_that.name,_that.priceMinor,_that.imagePath,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc


class _ManagementVariant implements ManagementVariant {
  const _ManagementVariant({required this.id, required this.name, required this.priceMinor, this.imagePath, this.imageUrl});
  

@override final  String id;
@override final  String name;
@override final  int? priceMinor;
@override final  String? imagePath;
@override final  String? imageUrl;

/// Create a copy of ManagementVariant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ManagementVariantCopyWith<_ManagementVariant> get copyWith => __$ManagementVariantCopyWithImpl<_ManagementVariant>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ManagementVariant&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.priceMinor, priceMinor) || other.priceMinor == priceMinor)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,priceMinor,imagePath,imageUrl);

@override
String toString() {
  return 'ManagementVariant(id: $id, name: $name, priceMinor: $priceMinor, imagePath: $imagePath, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$ManagementVariantCopyWith<$Res> implements $ManagementVariantCopyWith<$Res> {
  factory _$ManagementVariantCopyWith(_ManagementVariant value, $Res Function(_ManagementVariant) _then) = __$ManagementVariantCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int? priceMinor, String? imagePath, String? imageUrl
});




}
/// @nodoc
class __$ManagementVariantCopyWithImpl<$Res>
    implements _$ManagementVariantCopyWith<$Res> {
  __$ManagementVariantCopyWithImpl(this._self, this._then);

  final _ManagementVariant _self;
  final $Res Function(_ManagementVariant) _then;

/// Create a copy of ManagementVariant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? priceMinor = freezed,Object? imagePath = freezed,Object? imageUrl = freezed,}) {
  return _then(_ManagementVariant(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceMinor: freezed == priceMinor ? _self.priceMinor : priceMinor // ignore: cast_nullable_to_non_nullable
as int?,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$VariantDraft {

 String get name; int? get priceMinor;
/// Create a copy of VariantDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VariantDraftCopyWith<VariantDraft> get copyWith => _$VariantDraftCopyWithImpl<VariantDraft>(this as VariantDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VariantDraft&&(identical(other.name, name) || other.name == name)&&(identical(other.priceMinor, priceMinor) || other.priceMinor == priceMinor));
}


@override
int get hashCode => Object.hash(runtimeType,name,priceMinor);

@override
String toString() {
  return 'VariantDraft(name: $name, priceMinor: $priceMinor)';
}


}

/// @nodoc
abstract mixin class $VariantDraftCopyWith<$Res>  {
  factory $VariantDraftCopyWith(VariantDraft value, $Res Function(VariantDraft) _then) = _$VariantDraftCopyWithImpl;
@useResult
$Res call({
 String name, int? priceMinor
});




}
/// @nodoc
class _$VariantDraftCopyWithImpl<$Res>
    implements $VariantDraftCopyWith<$Res> {
  _$VariantDraftCopyWithImpl(this._self, this._then);

  final VariantDraft _self;
  final $Res Function(VariantDraft) _then;

/// Create a copy of VariantDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? priceMinor = freezed,}) {
  return _then(VariantDraft(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceMinor: freezed == priceMinor ? _self.priceMinor : priceMinor // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [VariantDraft].
extension VariantDraftPatterns on VariantDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VariantDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VariantDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VariantDraft value)  $default,){
final _that = this;
switch (_that) {
case _VariantDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VariantDraft value)?  $default,){
final _that = this;
switch (_that) {
case _VariantDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int? priceMinor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VariantDraft() when $default != null:
return $default(_that.name,_that.priceMinor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int? priceMinor)  $default,) {final _that = this;
switch (_that) {
case _VariantDraft():
return $default(_that.name,_that.priceMinor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int? priceMinor)?  $default,) {final _that = this;
switch (_that) {
case _VariantDraft() when $default != null:
return $default(_that.name,_that.priceMinor);case _:
  return null;

}
}

}

/// @nodoc


class _VariantDraft implements VariantDraft {
  const _VariantDraft({required this.name, required this.priceMinor});
  

@override final  String name;
@override final  int? priceMinor;

/// Create a copy of VariantDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VariantDraftCopyWith<_VariantDraft> get copyWith => __$VariantDraftCopyWithImpl<_VariantDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VariantDraft&&(identical(other.name, name) || other.name == name)&&(identical(other.priceMinor, priceMinor) || other.priceMinor == priceMinor));
}


@override
int get hashCode => Object.hash(runtimeType,name,priceMinor);

@override
String toString() {
  return 'VariantDraft(name: $name, priceMinor: $priceMinor)';
}


}

/// @nodoc
abstract mixin class _$VariantDraftCopyWith<$Res> implements $VariantDraftCopyWith<$Res> {
  factory _$VariantDraftCopyWith(_VariantDraft value, $Res Function(_VariantDraft) _then) = __$VariantDraftCopyWithImpl;
@override @useResult
$Res call({
 String name, int? priceMinor
});




}
/// @nodoc
class __$VariantDraftCopyWithImpl<$Res>
    implements _$VariantDraftCopyWith<$Res> {
  __$VariantDraftCopyWithImpl(this._self, this._then);

  final _VariantDraft _self;
  final $Res Function(_VariantDraft) _then;

/// Create a copy of VariantDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? priceMinor = freezed,}) {
  return _then(_VariantDraft(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceMinor: freezed == priceMinor ? _self.priceMinor : priceMinor // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$CategoryOption {

 String get id; String get name;
/// Create a copy of CategoryOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryOptionCopyWith<CategoryOption> get copyWith => _$CategoryOptionCopyWithImpl<CategoryOption>(this as CategoryOption, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryOption&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'CategoryOption(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $CategoryOptionCopyWith<$Res>  {
  factory $CategoryOptionCopyWith(CategoryOption value, $Res Function(CategoryOption) _then) = _$CategoryOptionCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$CategoryOptionCopyWithImpl<$Res>
    implements $CategoryOptionCopyWith<$Res> {
  _$CategoryOptionCopyWithImpl(this._self, this._then);

  final CategoryOption _self;
  final $Res Function(CategoryOption) _then;

/// Create a copy of CategoryOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(CategoryOption(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryOption].
extension CategoryOptionPatterns on CategoryOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryOption value)  $default,){
final _that = this;
switch (_that) {
case _CategoryOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryOption value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryOption() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name)  $default,) {final _that = this;
switch (_that) {
case _CategoryOption():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _CategoryOption() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _CategoryOption implements CategoryOption {
  const _CategoryOption({required this.id, required this.name});
  

@override final  String id;
@override final  String name;

/// Create a copy of CategoryOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryOptionCopyWith<_CategoryOption> get copyWith => __$CategoryOptionCopyWithImpl<_CategoryOption>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryOption&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'CategoryOption(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$CategoryOptionCopyWith<$Res> implements $CategoryOptionCopyWith<$Res> {
  factory _$CategoryOptionCopyWith(_CategoryOption value, $Res Function(_CategoryOption) _then) = __$CategoryOptionCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$CategoryOptionCopyWithImpl<$Res>
    implements _$CategoryOptionCopyWith<$Res> {
  __$CategoryOptionCopyWithImpl(this._self, this._then);

  final _CategoryOption _self;
  final $Res Function(_CategoryOption) _then;

/// Create a copy of CategoryOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_CategoryOption(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
