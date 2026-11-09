// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdminCategory {

 String get id; String get name; String? get imageUrl;/// Raw storage reference (catalog_assets path or http passthrough) —
/// passed back on edit so the display URL is never re-persisted.
 String? get imagePath;/// Parent category id — null for top-level (Section 2c, 2-level
/// taxonomy).
 String? get parentId;
/// Create a copy of AdminCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminCategoryCopyWith<AdminCategory> get copyWith => _$AdminCategoryCopyWithImpl<AdminCategory>(this as AdminCategory, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.parentId, parentId) || other.parentId == parentId));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,imageUrl,imagePath,parentId);

@override
String toString() {
  return 'AdminCategory(id: $id, name: $name, imageUrl: $imageUrl, imagePath: $imagePath, parentId: $parentId)';
}


}

/// @nodoc
abstract mixin class $AdminCategoryCopyWith<$Res>  {
  factory $AdminCategoryCopyWith(AdminCategory value, $Res Function(AdminCategory) _then) = _$AdminCategoryCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? imageUrl, String? imagePath, String? parentId
});




}
/// @nodoc
class _$AdminCategoryCopyWithImpl<$Res>
    implements $AdminCategoryCopyWith<$Res> {
  _$AdminCategoryCopyWithImpl(this._self, this._then);

  final AdminCategory _self;
  final $Res Function(AdminCategory) _then;

/// Create a copy of AdminCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? imageUrl = freezed,Object? imagePath = freezed,Object? parentId = freezed,}) {
  return _then(AdminCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminCategory].
extension AdminCategoryPatterns on AdminCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminCategory value)  $default,){
final _that = this;
switch (_that) {
case _AdminCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminCategory value)?  $default,){
final _that = this;
switch (_that) {
case _AdminCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? imageUrl,  String? imagePath,  String? parentId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminCategory() when $default != null:
return $default(_that.id,_that.name,_that.imageUrl,_that.imagePath,_that.parentId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? imageUrl,  String? imagePath,  String? parentId)  $default,) {final _that = this;
switch (_that) {
case _AdminCategory():
return $default(_that.id,_that.name,_that.imageUrl,_that.imagePath,_that.parentId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? imageUrl,  String? imagePath,  String? parentId)?  $default,) {final _that = this;
switch (_that) {
case _AdminCategory() when $default != null:
return $default(_that.id,_that.name,_that.imageUrl,_that.imagePath,_that.parentId);case _:
  return null;

}
}

}

/// @nodoc


class _AdminCategory implements AdminCategory {
  const _AdminCategory({required this.id, required this.name, this.imageUrl, this.imagePath, this.parentId});
  

@override final  String id;
@override final  String name;
@override final  String? imageUrl;
/// Raw storage reference (catalog_assets path or http passthrough) —
/// passed back on edit so the display URL is never re-persisted.
@override final  String? imagePath;
/// Parent category id — null for top-level (Section 2c, 2-level
/// taxonomy).
@override final  String? parentId;

/// Create a copy of AdminCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminCategoryCopyWith<_AdminCategory> get copyWith => __$AdminCategoryCopyWithImpl<_AdminCategory>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.parentId, parentId) || other.parentId == parentId));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,imageUrl,imagePath,parentId);

@override
String toString() {
  return 'AdminCategory(id: $id, name: $name, imageUrl: $imageUrl, imagePath: $imagePath, parentId: $parentId)';
}


}

/// @nodoc
abstract mixin class _$AdminCategoryCopyWith<$Res> implements $AdminCategoryCopyWith<$Res> {
  factory _$AdminCategoryCopyWith(_AdminCategory value, $Res Function(_AdminCategory) _then) = __$AdminCategoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? imageUrl, String? imagePath, String? parentId
});




}
/// @nodoc
class __$AdminCategoryCopyWithImpl<$Res>
    implements _$AdminCategoryCopyWith<$Res> {
  __$AdminCategoryCopyWithImpl(this._self, this._then);

  final _AdminCategory _self;
  final $Res Function(_AdminCategory) _then;

/// Create a copy of AdminCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? imageUrl = freezed,Object? imagePath = freezed,Object? parentId = freezed,}) {
  return _then(_AdminCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$AdminBrand {

 String get id; String get name; String get description; String? get imageUrl; String? get imagePath; AdminCatalogStatus get status;
/// Create a copy of AdminBrand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminBrandCopyWith<AdminBrand> get copyWith => _$AdminBrandCopyWithImpl<AdminBrand>(this as AdminBrand, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminBrand&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,imageUrl,imagePath,status);

@override
String toString() {
  return 'AdminBrand(id: $id, name: $name, description: $description, imageUrl: $imageUrl, imagePath: $imagePath, status: $status)';
}


}

/// @nodoc
abstract mixin class $AdminBrandCopyWith<$Res>  {
  factory $AdminBrandCopyWith(AdminBrand value, $Res Function(AdminBrand) _then) = _$AdminBrandCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, String? imageUrl, String? imagePath, AdminCatalogStatus status
});




}
/// @nodoc
class _$AdminBrandCopyWithImpl<$Res>
    implements $AdminBrandCopyWith<$Res> {
  _$AdminBrandCopyWithImpl(this._self, this._then);

  final AdminBrand _self;
  final $Res Function(AdminBrand) _then;

/// Create a copy of AdminBrand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? imageUrl = freezed,Object? imagePath = freezed,Object? status = null,}) {
  return _then(AdminBrand(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AdminCatalogStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminBrand].
extension AdminBrandPatterns on AdminBrand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminBrand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminBrand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminBrand value)  $default,){
final _that = this;
switch (_that) {
case _AdminBrand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminBrand value)?  $default,){
final _that = this;
switch (_that) {
case _AdminBrand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String? imageUrl,  String? imagePath,  AdminCatalogStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminBrand() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.imageUrl,_that.imagePath,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String? imageUrl,  String? imagePath,  AdminCatalogStatus status)  $default,) {final _that = this;
switch (_that) {
case _AdminBrand():
return $default(_that.id,_that.name,_that.description,_that.imageUrl,_that.imagePath,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  String? imageUrl,  String? imagePath,  AdminCatalogStatus status)?  $default,) {final _that = this;
switch (_that) {
case _AdminBrand() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.imageUrl,_that.imagePath,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _AdminBrand implements AdminBrand {
  const _AdminBrand({required this.id, required this.name, this.description = '', this.imageUrl, this.imagePath, this.status = AdminCatalogStatus.active});
  

@override final  String id;
@override final  String name;
@override@JsonKey() final  String description;
@override final  String? imageUrl;
@override final  String? imagePath;
@override@JsonKey() final  AdminCatalogStatus status;

/// Create a copy of AdminBrand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminBrandCopyWith<_AdminBrand> get copyWith => __$AdminBrandCopyWithImpl<_AdminBrand>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminBrand&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,imageUrl,imagePath,status);

@override
String toString() {
  return 'AdminBrand(id: $id, name: $name, description: $description, imageUrl: $imageUrl, imagePath: $imagePath, status: $status)';
}


}

/// @nodoc
abstract mixin class _$AdminBrandCopyWith<$Res> implements $AdminBrandCopyWith<$Res> {
  factory _$AdminBrandCopyWith(_AdminBrand value, $Res Function(_AdminBrand) _then) = __$AdminBrandCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, String? imageUrl, String? imagePath, AdminCatalogStatus status
});




}
/// @nodoc
class __$AdminBrandCopyWithImpl<$Res>
    implements _$AdminBrandCopyWith<$Res> {
  __$AdminBrandCopyWithImpl(this._self, this._then);

  final _AdminBrand _self;
  final $Res Function(_AdminBrand) _then;

/// Create a copy of AdminBrand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? imageUrl = freezed,Object? imagePath = freezed,Object? status = null,}) {
  return _then(_AdminBrand(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AdminCatalogStatus,
  ));
}


}

/// @nodoc
mixin _$AdminProductSummary {

 String get id; String get name; String get categoryId; String get categoryName; int get basePriceMinor; int get variantCount; int get stock; String get description; AdminCatalogStatus get status; String? get brandId; String? get brandName; List<AdminProductImageRef> get images;/// Active variants for the edit form's variant editor (Section 2b).
/// Archived variants stay server-side — they are unreachable for
/// purchase and cannot be resurrected from the form.
 List<AdminProductVariantRef> get variants;
/// Create a copy of AdminProductSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminProductSummaryCopyWith<AdminProductSummary> get copyWith => _$AdminProductSummaryCopyWithImpl<AdminProductSummary>(this as AdminProductSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminProductSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.basePriceMinor, basePriceMinor) || other.basePriceMinor == basePriceMinor)&&(identical(other.variantCount, variantCount) || other.variantCount == variantCount)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.brandId, brandId) || other.brandId == brandId)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&const DeepCollectionEquality().equals(other.images, images)&&const DeepCollectionEquality().equals(other.variants, variants));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,categoryId,categoryName,basePriceMinor,variantCount,stock,description,status,brandId,brandName,const DeepCollectionEquality().hash(images),const DeepCollectionEquality().hash(variants));

@override
String toString() {
  return 'AdminProductSummary(id: $id, name: $name, categoryId: $categoryId, categoryName: $categoryName, basePriceMinor: $basePriceMinor, variantCount: $variantCount, stock: $stock, description: $description, status: $status, brandId: $brandId, brandName: $brandName, images: $images, variants: $variants)';
}


}

/// @nodoc
abstract mixin class $AdminProductSummaryCopyWith<$Res>  {
  factory $AdminProductSummaryCopyWith(AdminProductSummary value, $Res Function(AdminProductSummary) _then) = _$AdminProductSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String name, String categoryId, String categoryName, int basePriceMinor, int variantCount, int stock, String description, AdminCatalogStatus status, String? brandId, String? brandName, List<AdminProductImageRef> images, List<AdminProductVariantRef> variants
});




}
/// @nodoc
class _$AdminProductSummaryCopyWithImpl<$Res>
    implements $AdminProductSummaryCopyWith<$Res> {
  _$AdminProductSummaryCopyWithImpl(this._self, this._then);

  final AdminProductSummary _self;
  final $Res Function(AdminProductSummary) _then;

/// Create a copy of AdminProductSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? categoryId = null,Object? categoryName = null,Object? basePriceMinor = null,Object? variantCount = null,Object? stock = null,Object? description = null,Object? status = null,Object? brandId = freezed,Object? brandName = freezed,Object? images = null,Object? variants = null,}) {
  return _then(AdminProductSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,basePriceMinor: null == basePriceMinor ? _self.basePriceMinor : basePriceMinor // ignore: cast_nullable_to_non_nullable
as int,variantCount: null == variantCount ? _self.variantCount : variantCount // ignore: cast_nullable_to_non_nullable
as int,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AdminCatalogStatus,brandId: freezed == brandId ? _self.brandId : brandId // ignore: cast_nullable_to_non_nullable
as String?,brandName: freezed == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String?,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<AdminProductImageRef>,variants: null == variants ? _self.variants : variants // ignore: cast_nullable_to_non_nullable
as List<AdminProductVariantRef>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminProductSummary].
extension AdminProductSummaryPatterns on AdminProductSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminProductSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminProductSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminProductSummary value)  $default,){
final _that = this;
switch (_that) {
case _AdminProductSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminProductSummary value)?  $default,){
final _that = this;
switch (_that) {
case _AdminProductSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String categoryId,  String categoryName,  int basePriceMinor,  int variantCount,  int stock,  String description,  AdminCatalogStatus status,  String? brandId,  String? brandName,  List<AdminProductImageRef> images,  List<AdminProductVariantRef> variants)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminProductSummary() when $default != null:
return $default(_that.id,_that.name,_that.categoryId,_that.categoryName,_that.basePriceMinor,_that.variantCount,_that.stock,_that.description,_that.status,_that.brandId,_that.brandName,_that.images,_that.variants);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String categoryId,  String categoryName,  int basePriceMinor,  int variantCount,  int stock,  String description,  AdminCatalogStatus status,  String? brandId,  String? brandName,  List<AdminProductImageRef> images,  List<AdminProductVariantRef> variants)  $default,) {final _that = this;
switch (_that) {
case _AdminProductSummary():
return $default(_that.id,_that.name,_that.categoryId,_that.categoryName,_that.basePriceMinor,_that.variantCount,_that.stock,_that.description,_that.status,_that.brandId,_that.brandName,_that.images,_that.variants);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String categoryId,  String categoryName,  int basePriceMinor,  int variantCount,  int stock,  String description,  AdminCatalogStatus status,  String? brandId,  String? brandName,  List<AdminProductImageRef> images,  List<AdminProductVariantRef> variants)?  $default,) {final _that = this;
switch (_that) {
case _AdminProductSummary() when $default != null:
return $default(_that.id,_that.name,_that.categoryId,_that.categoryName,_that.basePriceMinor,_that.variantCount,_that.stock,_that.description,_that.status,_that.brandId,_that.brandName,_that.images,_that.variants);case _:
  return null;

}
}

}

/// @nodoc


class _AdminProductSummary implements AdminProductSummary {
  const _AdminProductSummary({required this.id, required this.name, required this.categoryId, required this.categoryName, required this.basePriceMinor, required this.variantCount, required this.stock, this.description = '', this.status = AdminCatalogStatus.active, this.brandId, this.brandName,  List<AdminProductImageRef> images = const [],  List<AdminProductVariantRef> variants = const []}): _images = images,_variants = variants;
  

@override final  String id;
@override final  String name;
@override final  String categoryId;
@override final  String categoryName;
@override final  int basePriceMinor;
@override final  int variantCount;
@override final  int stock;
@override@JsonKey() final  String description;
@override@JsonKey() final  AdminCatalogStatus status;
@override final  String? brandId;
@override final  String? brandName;
 final  List<AdminProductImageRef> _images;
@override@JsonKey() List<AdminProductImageRef> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

/// Active variants for the edit form's variant editor (Section 2b).
/// Archived variants stay server-side — they are unreachable for
/// purchase and cannot be resurrected from the form.
 final  List<AdminProductVariantRef> _variants;
/// Active variants for the edit form's variant editor (Section 2b).
/// Archived variants stay server-side — they are unreachable for
/// purchase and cannot be resurrected from the form.
@override@JsonKey() List<AdminProductVariantRef> get variants {
  if (_variants is EqualUnmodifiableListView) return _variants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_variants);
}


/// Create a copy of AdminProductSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminProductSummaryCopyWith<_AdminProductSummary> get copyWith => __$AdminProductSummaryCopyWithImpl<_AdminProductSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminProductSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.basePriceMinor, basePriceMinor) || other.basePriceMinor == basePriceMinor)&&(identical(other.variantCount, variantCount) || other.variantCount == variantCount)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.brandId, brandId) || other.brandId == brandId)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&const DeepCollectionEquality().equals(other._images, _images)&&const DeepCollectionEquality().equals(other._variants, _variants));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,categoryId,categoryName,basePriceMinor,variantCount,stock,description,status,brandId,brandName,const DeepCollectionEquality().hash(_images),const DeepCollectionEquality().hash(_variants));

@override
String toString() {
  return 'AdminProductSummary(id: $id, name: $name, categoryId: $categoryId, categoryName: $categoryName, basePriceMinor: $basePriceMinor, variantCount: $variantCount, stock: $stock, description: $description, status: $status, brandId: $brandId, brandName: $brandName, images: $images, variants: $variants)';
}


}

/// @nodoc
abstract mixin class _$AdminProductSummaryCopyWith<$Res> implements $AdminProductSummaryCopyWith<$Res> {
  factory _$AdminProductSummaryCopyWith(_AdminProductSummary value, $Res Function(_AdminProductSummary) _then) = __$AdminProductSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String categoryId, String categoryName, int basePriceMinor, int variantCount, int stock, String description, AdminCatalogStatus status, String? brandId, String? brandName, List<AdminProductImageRef> images, List<AdminProductVariantRef> variants
});




}
/// @nodoc
class __$AdminProductSummaryCopyWithImpl<$Res>
    implements _$AdminProductSummaryCopyWith<$Res> {
  __$AdminProductSummaryCopyWithImpl(this._self, this._then);

  final _AdminProductSummary _self;
  final $Res Function(_AdminProductSummary) _then;

/// Create a copy of AdminProductSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? categoryId = null,Object? categoryName = null,Object? basePriceMinor = null,Object? variantCount = null,Object? stock = null,Object? description = null,Object? status = null,Object? brandId = freezed,Object? brandName = freezed,Object? images = null,Object? variants = null,}) {
  return _then(_AdminProductSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,basePriceMinor: null == basePriceMinor ? _self.basePriceMinor : basePriceMinor // ignore: cast_nullable_to_non_nullable
as int,variantCount: null == variantCount ? _self.variantCount : variantCount // ignore: cast_nullable_to_non_nullable
as int,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AdminCatalogStatus,brandId: freezed == brandId ? _self.brandId : brandId // ignore: cast_nullable_to_non_nullable
as String?,brandName: freezed == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String?,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<AdminProductImageRef>,variants: null == variants ? _self._variants : variants // ignore: cast_nullable_to_non_nullable
as List<AdminProductVariantRef>,
  ));
}


}

/// @nodoc
mixin _$AdminProductImageRef {

 String get id; String get storagePath; String get url;
/// Create a copy of AdminProductImageRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminProductImageRefCopyWith<AdminProductImageRef> get copyWith => _$AdminProductImageRefCopyWithImpl<AdminProductImageRef>(this as AdminProductImageRef, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminProductImageRef&&(identical(other.id, id) || other.id == id)&&(identical(other.storagePath, storagePath) || other.storagePath == storagePath)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,id,storagePath,url);

@override
String toString() {
  return 'AdminProductImageRef(id: $id, storagePath: $storagePath, url: $url)';
}


}

/// @nodoc
abstract mixin class $AdminProductImageRefCopyWith<$Res>  {
  factory $AdminProductImageRefCopyWith(AdminProductImageRef value, $Res Function(AdminProductImageRef) _then) = _$AdminProductImageRefCopyWithImpl;
@useResult
$Res call({
 String id, String storagePath, String url
});




}
/// @nodoc
class _$AdminProductImageRefCopyWithImpl<$Res>
    implements $AdminProductImageRefCopyWith<$Res> {
  _$AdminProductImageRefCopyWithImpl(this._self, this._then);

  final AdminProductImageRef _self;
  final $Res Function(AdminProductImageRef) _then;

/// Create a copy of AdminProductImageRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? storagePath = null,Object? url = null,}) {
  return _then(AdminProductImageRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storagePath: null == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminProductImageRef].
extension AdminProductImageRefPatterns on AdminProductImageRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminProductImageRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminProductImageRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminProductImageRef value)  $default,){
final _that = this;
switch (_that) {
case _AdminProductImageRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminProductImageRef value)?  $default,){
final _that = this;
switch (_that) {
case _AdminProductImageRef() when $default != null:
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
case _AdminProductImageRef() when $default != null:
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
case _AdminProductImageRef():
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
case _AdminProductImageRef() when $default != null:
return $default(_that.id,_that.storagePath,_that.url);case _:
  return null;

}
}

}

/// @nodoc


class _AdminProductImageRef implements AdminProductImageRef {
  const _AdminProductImageRef({required this.id, required this.storagePath, required this.url});
  

@override final  String id;
@override final  String storagePath;
@override final  String url;

/// Create a copy of AdminProductImageRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminProductImageRefCopyWith<_AdminProductImageRef> get copyWith => __$AdminProductImageRefCopyWithImpl<_AdminProductImageRef>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminProductImageRef&&(identical(other.id, id) || other.id == id)&&(identical(other.storagePath, storagePath) || other.storagePath == storagePath)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,id,storagePath,url);

@override
String toString() {
  return 'AdminProductImageRef(id: $id, storagePath: $storagePath, url: $url)';
}


}

/// @nodoc
abstract mixin class _$AdminProductImageRefCopyWith<$Res> implements $AdminProductImageRefCopyWith<$Res> {
  factory _$AdminProductImageRefCopyWith(_AdminProductImageRef value, $Res Function(_AdminProductImageRef) _then) = __$AdminProductImageRefCopyWithImpl;
@override @useResult
$Res call({
 String id, String storagePath, String url
});




}
/// @nodoc
class __$AdminProductImageRefCopyWithImpl<$Res>
    implements _$AdminProductImageRefCopyWith<$Res> {
  __$AdminProductImageRefCopyWithImpl(this._self, this._then);

  final _AdminProductImageRef _self;
  final $Res Function(_AdminProductImageRef) _then;

/// Create a copy of AdminProductImageRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? storagePath = null,Object? url = null,}) {
  return _then(_AdminProductImageRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storagePath: null == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$AdminProductVariantRef {

 String get id; String get name;/// Null tracks the product's base price (server rule §1.2).
 int? get priceMinor;/// Raw `product_variants.image_path` (sent back untouched on save) and
/// its resolved public URL for the row's image preview.
 String? get imagePath; String? get imageUrl;
/// Create a copy of AdminProductVariantRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminProductVariantRefCopyWith<AdminProductVariantRef> get copyWith => _$AdminProductVariantRefCopyWithImpl<AdminProductVariantRef>(this as AdminProductVariantRef, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminProductVariantRef&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.priceMinor, priceMinor) || other.priceMinor == priceMinor)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,priceMinor,imagePath,imageUrl);

@override
String toString() {
  return 'AdminProductVariantRef(id: $id, name: $name, priceMinor: $priceMinor, imagePath: $imagePath, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $AdminProductVariantRefCopyWith<$Res>  {
  factory $AdminProductVariantRefCopyWith(AdminProductVariantRef value, $Res Function(AdminProductVariantRef) _then) = _$AdminProductVariantRefCopyWithImpl;
@useResult
$Res call({
 String id, String name, int? priceMinor, String? imagePath, String? imageUrl
});




}
/// @nodoc
class _$AdminProductVariantRefCopyWithImpl<$Res>
    implements $AdminProductVariantRefCopyWith<$Res> {
  _$AdminProductVariantRefCopyWithImpl(this._self, this._then);

  final AdminProductVariantRef _self;
  final $Res Function(AdminProductVariantRef) _then;

/// Create a copy of AdminProductVariantRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? priceMinor = freezed,Object? imagePath = freezed,Object? imageUrl = freezed,}) {
  return _then(AdminProductVariantRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceMinor: freezed == priceMinor ? _self.priceMinor : priceMinor // ignore: cast_nullable_to_non_nullable
as int?,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminProductVariantRef].
extension AdminProductVariantRefPatterns on AdminProductVariantRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminProductVariantRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminProductVariantRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminProductVariantRef value)  $default,){
final _that = this;
switch (_that) {
case _AdminProductVariantRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminProductVariantRef value)?  $default,){
final _that = this;
switch (_that) {
case _AdminProductVariantRef() when $default != null:
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
case _AdminProductVariantRef() when $default != null:
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
case _AdminProductVariantRef():
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
case _AdminProductVariantRef() when $default != null:
return $default(_that.id,_that.name,_that.priceMinor,_that.imagePath,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc


class _AdminProductVariantRef extends AdminProductVariantRef {
  const _AdminProductVariantRef({required this.id, required this.name, this.priceMinor, this.imagePath, this.imageUrl}): super._();
  

@override final  String id;
@override final  String name;
/// Null tracks the product's base price (server rule §1.2).
@override final  int? priceMinor;
/// Raw `product_variants.image_path` (sent back untouched on save) and
/// its resolved public URL for the row's image preview.
@override final  String? imagePath;
@override final  String? imageUrl;

/// Create a copy of AdminProductVariantRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminProductVariantRefCopyWith<_AdminProductVariantRef> get copyWith => __$AdminProductVariantRefCopyWithImpl<_AdminProductVariantRef>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminProductVariantRef&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.priceMinor, priceMinor) || other.priceMinor == priceMinor)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,priceMinor,imagePath,imageUrl);

@override
String toString() {
  return 'AdminProductVariantRef(id: $id, name: $name, priceMinor: $priceMinor, imagePath: $imagePath, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$AdminProductVariantRefCopyWith<$Res> implements $AdminProductVariantRefCopyWith<$Res> {
  factory _$AdminProductVariantRefCopyWith(_AdminProductVariantRef value, $Res Function(_AdminProductVariantRef) _then) = __$AdminProductVariantRefCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int? priceMinor, String? imagePath, String? imageUrl
});




}
/// @nodoc
class __$AdminProductVariantRefCopyWithImpl<$Res>
    implements _$AdminProductVariantRefCopyWith<$Res> {
  __$AdminProductVariantRefCopyWithImpl(this._self, this._then);

  final _AdminProductVariantRef _self;
  final $Res Function(_AdminProductVariantRef) _then;

/// Create a copy of AdminProductVariantRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? priceMinor = freezed,Object? imagePath = freezed,Object? imageUrl = freezed,}) {
  return _then(_AdminProductVariantRef(
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
mixin _$AdminProductDraft {

 String? get id;/// Null on create — the server resolves (or provisions) the singleton
/// prototype business (DESIGN.md §1.1); edits carry the product's
/// existing business.
 String get categoryId; String? get brandId; String get name; String get description; int get stock;/// Every product needs at least one explicit variant. Rows with an
/// [AdminProductVariantDraft.id] update in place, id-less rows are
/// inserted, and missing active variants are archived server-side. The
/// server derives `products.base_price_minor` from the cheapest row.
 List<AdminProductVariantDraft> get variants;
/// Create a copy of AdminProductDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminProductDraftCopyWith<AdminProductDraft> get copyWith => _$AdminProductDraftCopyWithImpl<AdminProductDraft>(this as AdminProductDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminProductDraft&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.brandId, brandId) || other.brandId == brandId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.stock, stock) || other.stock == stock)&&const DeepCollectionEquality().equals(other.variants, variants));
}


@override
int get hashCode => Object.hash(runtimeType,id,categoryId,brandId,name,description,stock,const DeepCollectionEquality().hash(variants));

@override
String toString() {
  return 'AdminProductDraft(id: $id, categoryId: $categoryId, brandId: $brandId, name: $name, description: $description, stock: $stock, variants: $variants)';
}


}

/// @nodoc
abstract mixin class $AdminProductDraftCopyWith<$Res>  {
  factory $AdminProductDraftCopyWith(AdminProductDraft value, $Res Function(AdminProductDraft) _then) = _$AdminProductDraftCopyWithImpl;
@useResult
$Res call({
 String? id, String categoryId, String? brandId, String name, String description, int stock, List<AdminProductVariantDraft> variants
});




}
/// @nodoc
class _$AdminProductDraftCopyWithImpl<$Res>
    implements $AdminProductDraftCopyWith<$Res> {
  _$AdminProductDraftCopyWithImpl(this._self, this._then);

  final AdminProductDraft _self;
  final $Res Function(AdminProductDraft) _then;

/// Create a copy of AdminProductDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? categoryId = null,Object? brandId = freezed,Object? name = null,Object? description = null,Object? stock = null,Object? variants = null,}) {
  return _then(AdminProductDraft(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,brandId: freezed == brandId ? _self.brandId : brandId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,variants: null == variants ? _self.variants : variants // ignore: cast_nullable_to_non_nullable
as List<AdminProductVariantDraft>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminProductDraft].
extension AdminProductDraftPatterns on AdminProductDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminProductDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminProductDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminProductDraft value)  $default,){
final _that = this;
switch (_that) {
case _AdminProductDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminProductDraft value)?  $default,){
final _that = this;
switch (_that) {
case _AdminProductDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String categoryId,  String? brandId,  String name,  String description,  int stock,  List<AdminProductVariantDraft> variants)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminProductDraft() when $default != null:
return $default(_that.id,_that.categoryId,_that.brandId,_that.name,_that.description,_that.stock,_that.variants);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String categoryId,  String? brandId,  String name,  String description,  int stock,  List<AdminProductVariantDraft> variants)  $default,) {final _that = this;
switch (_that) {
case _AdminProductDraft():
return $default(_that.id,_that.categoryId,_that.brandId,_that.name,_that.description,_that.stock,_that.variants);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String categoryId,  String? brandId,  String name,  String description,  int stock,  List<AdminProductVariantDraft> variants)?  $default,) {final _that = this;
switch (_that) {
case _AdminProductDraft() when $default != null:
return $default(_that.id,_that.categoryId,_that.brandId,_that.name,_that.description,_that.stock,_that.variants);case _:
  return null;

}
}

}

/// @nodoc


class _AdminProductDraft implements AdminProductDraft {
  const _AdminProductDraft({this.id, required this.categoryId, this.brandId, required this.name, this.description = '', this.stock = 0,  List<AdminProductVariantDraft> variants = const []}): _variants = variants;
  

@override final  String? id;
/// Null on create — the server resolves (or provisions) the singleton
/// prototype business (DESIGN.md §1.1); edits carry the product's
/// existing business.
@override final  String categoryId;
@override final  String? brandId;
@override final  String name;
@override@JsonKey() final  String description;
@override@JsonKey() final  int stock;
/// Every product needs at least one explicit variant. Rows with an
/// [AdminProductVariantDraft.id] update in place, id-less rows are
/// inserted, and missing active variants are archived server-side. The
/// server derives `products.base_price_minor` from the cheapest row.
 final  List<AdminProductVariantDraft> _variants;
/// Every product needs at least one explicit variant. Rows with an
/// [AdminProductVariantDraft.id] update in place, id-less rows are
/// inserted, and missing active variants are archived server-side. The
/// server derives `products.base_price_minor` from the cheapest row.
@override@JsonKey() List<AdminProductVariantDraft> get variants {
  if (_variants is EqualUnmodifiableListView) return _variants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_variants);
}


/// Create a copy of AdminProductDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminProductDraftCopyWith<_AdminProductDraft> get copyWith => __$AdminProductDraftCopyWithImpl<_AdminProductDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminProductDraft&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.brandId, brandId) || other.brandId == brandId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.stock, stock) || other.stock == stock)&&const DeepCollectionEquality().equals(other._variants, _variants));
}


@override
int get hashCode => Object.hash(runtimeType,id,categoryId,brandId,name,description,stock,const DeepCollectionEquality().hash(_variants));

@override
String toString() {
  return 'AdminProductDraft(id: $id, categoryId: $categoryId, brandId: $brandId, name: $name, description: $description, stock: $stock, variants: $variants)';
}


}

/// @nodoc
abstract mixin class _$AdminProductDraftCopyWith<$Res> implements $AdminProductDraftCopyWith<$Res> {
  factory _$AdminProductDraftCopyWith(_AdminProductDraft value, $Res Function(_AdminProductDraft) _then) = __$AdminProductDraftCopyWithImpl;
@override @useResult
$Res call({
 String? id, String categoryId, String? brandId, String name, String description, int stock, List<AdminProductVariantDraft> variants
});




}
/// @nodoc
class __$AdminProductDraftCopyWithImpl<$Res>
    implements _$AdminProductDraftCopyWith<$Res> {
  __$AdminProductDraftCopyWithImpl(this._self, this._then);

  final _AdminProductDraft _self;
  final $Res Function(_AdminProductDraft) _then;

/// Create a copy of AdminProductDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? categoryId = null,Object? brandId = freezed,Object? name = null,Object? description = null,Object? stock = null,Object? variants = null,}) {
  return _then(_AdminProductDraft(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,brandId: freezed == brandId ? _self.brandId : brandId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,variants: null == variants ? _self._variants : variants // ignore: cast_nullable_to_non_nullable
as List<AdminProductVariantDraft>,
  ));
}


}

/// @nodoc
mixin _$AdminProductVariantDraft {

 String? get id; String get name;/// Required for authored variants. The form never sends the null-price
/// single-price placeholder (the server manages it).
 int? get priceMinor; String? get imagePath; PickedFile? get imagePick;
/// Create a copy of AdminProductVariantDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminProductVariantDraftCopyWith<AdminProductVariantDraft> get copyWith => _$AdminProductVariantDraftCopyWithImpl<AdminProductVariantDraft>(this as AdminProductVariantDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminProductVariantDraft&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.priceMinor, priceMinor) || other.priceMinor == priceMinor)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.imagePick, imagePick) || other.imagePick == imagePick));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,priceMinor,imagePath,imagePick);

@override
String toString() {
  return 'AdminProductVariantDraft(id: $id, name: $name, priceMinor: $priceMinor, imagePath: $imagePath, imagePick: $imagePick)';
}


}

/// @nodoc
abstract mixin class $AdminProductVariantDraftCopyWith<$Res>  {
  factory $AdminProductVariantDraftCopyWith(AdminProductVariantDraft value, $Res Function(AdminProductVariantDraft) _then) = _$AdminProductVariantDraftCopyWithImpl;
@useResult
$Res call({
 String? id, String name, int? priceMinor, String? imagePath, PickedFile? imagePick
});




}
/// @nodoc
class _$AdminProductVariantDraftCopyWithImpl<$Res>
    implements $AdminProductVariantDraftCopyWith<$Res> {
  _$AdminProductVariantDraftCopyWithImpl(this._self, this._then);

  final AdminProductVariantDraft _self;
  final $Res Function(AdminProductVariantDraft) _then;

/// Create a copy of AdminProductVariantDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? priceMinor = freezed,Object? imagePath = freezed,Object? imagePick = freezed,}) {
  return _then(AdminProductVariantDraft(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceMinor: freezed == priceMinor ? _self.priceMinor : priceMinor // ignore: cast_nullable_to_non_nullable
as int?,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,imagePick: freezed == imagePick ? _self.imagePick : imagePick // ignore: cast_nullable_to_non_nullable
as PickedFile?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminProductVariantDraft].
extension AdminProductVariantDraftPatterns on AdminProductVariantDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminProductVariantDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminProductVariantDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminProductVariantDraft value)  $default,){
final _that = this;
switch (_that) {
case _AdminProductVariantDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminProductVariantDraft value)?  $default,){
final _that = this;
switch (_that) {
case _AdminProductVariantDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String name,  int? priceMinor,  String? imagePath,  PickedFile? imagePick)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminProductVariantDraft() when $default != null:
return $default(_that.id,_that.name,_that.priceMinor,_that.imagePath,_that.imagePick);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String name,  int? priceMinor,  String? imagePath,  PickedFile? imagePick)  $default,) {final _that = this;
switch (_that) {
case _AdminProductVariantDraft():
return $default(_that.id,_that.name,_that.priceMinor,_that.imagePath,_that.imagePick);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String name,  int? priceMinor,  String? imagePath,  PickedFile? imagePick)?  $default,) {final _that = this;
switch (_that) {
case _AdminProductVariantDraft() when $default != null:
return $default(_that.id,_that.name,_that.priceMinor,_that.imagePath,_that.imagePick);case _:
  return null;

}
}

}

/// @nodoc


class _AdminProductVariantDraft implements AdminProductVariantDraft {
  const _AdminProductVariantDraft({this.id, required this.name, this.priceMinor, this.imagePath, this.imagePick});
  

@override final  String? id;
@override final  String name;
/// Required for authored variants. The form never sends the null-price
/// single-price placeholder (the server manages it).
@override final  int? priceMinor;
@override final  String? imagePath;
@override final  PickedFile? imagePick;

/// Create a copy of AdminProductVariantDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminProductVariantDraftCopyWith<_AdminProductVariantDraft> get copyWith => __$AdminProductVariantDraftCopyWithImpl<_AdminProductVariantDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminProductVariantDraft&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.priceMinor, priceMinor) || other.priceMinor == priceMinor)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.imagePick, imagePick) || other.imagePick == imagePick));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,priceMinor,imagePath,imagePick);

@override
String toString() {
  return 'AdminProductVariantDraft(id: $id, name: $name, priceMinor: $priceMinor, imagePath: $imagePath, imagePick: $imagePick)';
}


}

/// @nodoc
abstract mixin class _$AdminProductVariantDraftCopyWith<$Res> implements $AdminProductVariantDraftCopyWith<$Res> {
  factory _$AdminProductVariantDraftCopyWith(_AdminProductVariantDraft value, $Res Function(_AdminProductVariantDraft) _then) = __$AdminProductVariantDraftCopyWithImpl;
@override @useResult
$Res call({
 String? id, String name, int? priceMinor, String? imagePath, PickedFile? imagePick
});




}
/// @nodoc
class __$AdminProductVariantDraftCopyWithImpl<$Res>
    implements _$AdminProductVariantDraftCopyWith<$Res> {
  __$AdminProductVariantDraftCopyWithImpl(this._self, this._then);

  final _AdminProductVariantDraft _self;
  final $Res Function(_AdminProductVariantDraft) _then;

/// Create a copy of AdminProductVariantDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? priceMinor = freezed,Object? imagePath = freezed,Object? imagePick = freezed,}) {
  return _then(_AdminProductVariantDraft(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceMinor: freezed == priceMinor ? _self.priceMinor : priceMinor // ignore: cast_nullable_to_non_nullable
as int?,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,imagePick: freezed == imagePick ? _self.imagePick : imagePick // ignore: cast_nullable_to_non_nullable
as PickedFile?,
  ));
}


}

/// @nodoc
mixin _$AdminOrderSummary {

 String get id; String get customerName; int get subtotalMinor; int get discountMinor; int get deliveryFeeMinor; int get totalMinor; DateTime get createdAt; AdminOrderStatus get status; String get cancellationReason; String? get paymentMethod; String? get paymentStatus; List<AdminOrderItem> get items; String get customerPhone; String get shippingRecipientName; String get shippingPhone; String get shippingLine1; String? get shippingLine2; String get shippingCity;
/// Create a copy of AdminOrderSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminOrderSummaryCopyWith<AdminOrderSummary> get copyWith => _$AdminOrderSummaryCopyWithImpl<AdminOrderSummary>(this as AdminOrderSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminOrderSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.subtotalMinor, subtotalMinor) || other.subtotalMinor == subtotalMinor)&&(identical(other.discountMinor, discountMinor) || other.discountMinor == discountMinor)&&(identical(other.deliveryFeeMinor, deliveryFeeMinor) || other.deliveryFeeMinor == deliveryFeeMinor)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.cancellationReason, cancellationReason) || other.cancellationReason == cancellationReason)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.customerPhone, customerPhone) || other.customerPhone == customerPhone)&&(identical(other.shippingRecipientName, shippingRecipientName) || other.shippingRecipientName == shippingRecipientName)&&(identical(other.shippingPhone, shippingPhone) || other.shippingPhone == shippingPhone)&&(identical(other.shippingLine1, shippingLine1) || other.shippingLine1 == shippingLine1)&&(identical(other.shippingLine2, shippingLine2) || other.shippingLine2 == shippingLine2)&&(identical(other.shippingCity, shippingCity) || other.shippingCity == shippingCity));
}


@override
int get hashCode => Object.hash(runtimeType,id,customerName,subtotalMinor,discountMinor,deliveryFeeMinor,totalMinor,createdAt,status,cancellationReason,paymentMethod,paymentStatus,const DeepCollectionEquality().hash(items),customerPhone,shippingRecipientName,shippingPhone,shippingLine1,shippingLine2,shippingCity);

@override
String toString() {
  return 'AdminOrderSummary(id: $id, customerName: $customerName, subtotalMinor: $subtotalMinor, discountMinor: $discountMinor, deliveryFeeMinor: $deliveryFeeMinor, totalMinor: $totalMinor, createdAt: $createdAt, status: $status, cancellationReason: $cancellationReason, paymentMethod: $paymentMethod, paymentStatus: $paymentStatus, items: $items, customerPhone: $customerPhone, shippingRecipientName: $shippingRecipientName, shippingPhone: $shippingPhone, shippingLine1: $shippingLine1, shippingLine2: $shippingLine2, shippingCity: $shippingCity)';
}


}

/// @nodoc
abstract mixin class $AdminOrderSummaryCopyWith<$Res>  {
  factory $AdminOrderSummaryCopyWith(AdminOrderSummary value, $Res Function(AdminOrderSummary) _then) = _$AdminOrderSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String customerName, int subtotalMinor, int discountMinor, int deliveryFeeMinor, int totalMinor, DateTime createdAt, AdminOrderStatus status, String cancellationReason, String? paymentMethod, String? paymentStatus, List<AdminOrderItem> items, String customerPhone, String shippingRecipientName, String shippingPhone, String shippingLine1, String? shippingLine2, String shippingCity
});




}
/// @nodoc
class _$AdminOrderSummaryCopyWithImpl<$Res>
    implements $AdminOrderSummaryCopyWith<$Res> {
  _$AdminOrderSummaryCopyWithImpl(this._self, this._then);

  final AdminOrderSummary _self;
  final $Res Function(AdminOrderSummary) _then;

/// Create a copy of AdminOrderSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? customerName = null,Object? subtotalMinor = null,Object? discountMinor = null,Object? deliveryFeeMinor = null,Object? totalMinor = null,Object? createdAt = null,Object? status = null,Object? cancellationReason = null,Object? paymentMethod = freezed,Object? paymentStatus = freezed,Object? items = null,Object? customerPhone = null,Object? shippingRecipientName = null,Object? shippingPhone = null,Object? shippingLine1 = null,Object? shippingLine2 = freezed,Object? shippingCity = null,}) {
  return _then(AdminOrderSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,subtotalMinor: null == subtotalMinor ? _self.subtotalMinor : subtotalMinor // ignore: cast_nullable_to_non_nullable
as int,discountMinor: null == discountMinor ? _self.discountMinor : discountMinor // ignore: cast_nullable_to_non_nullable
as int,deliveryFeeMinor: null == deliveryFeeMinor ? _self.deliveryFeeMinor : deliveryFeeMinor // ignore: cast_nullable_to_non_nullable
as int,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AdminOrderStatus,cancellationReason: null == cancellationReason ? _self.cancellationReason : cancellationReason // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,paymentStatus: freezed == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<AdminOrderItem>,customerPhone: null == customerPhone ? _self.customerPhone : customerPhone // ignore: cast_nullable_to_non_nullable
as String,shippingRecipientName: null == shippingRecipientName ? _self.shippingRecipientName : shippingRecipientName // ignore: cast_nullable_to_non_nullable
as String,shippingPhone: null == shippingPhone ? _self.shippingPhone : shippingPhone // ignore: cast_nullable_to_non_nullable
as String,shippingLine1: null == shippingLine1 ? _self.shippingLine1 : shippingLine1 // ignore: cast_nullable_to_non_nullable
as String,shippingLine2: freezed == shippingLine2 ? _self.shippingLine2 : shippingLine2 // ignore: cast_nullable_to_non_nullable
as String?,shippingCity: null == shippingCity ? _self.shippingCity : shippingCity // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminOrderSummary].
extension AdminOrderSummaryPatterns on AdminOrderSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminOrderSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminOrderSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminOrderSummary value)  $default,){
final _that = this;
switch (_that) {
case _AdminOrderSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminOrderSummary value)?  $default,){
final _that = this;
switch (_that) {
case _AdminOrderSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String customerName,  int subtotalMinor,  int discountMinor,  int deliveryFeeMinor,  int totalMinor,  DateTime createdAt,  AdminOrderStatus status,  String cancellationReason,  String? paymentMethod,  String? paymentStatus,  List<AdminOrderItem> items,  String customerPhone,  String shippingRecipientName,  String shippingPhone,  String shippingLine1,  String? shippingLine2,  String shippingCity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminOrderSummary() when $default != null:
return $default(_that.id,_that.customerName,_that.subtotalMinor,_that.discountMinor,_that.deliveryFeeMinor,_that.totalMinor,_that.createdAt,_that.status,_that.cancellationReason,_that.paymentMethod,_that.paymentStatus,_that.items,_that.customerPhone,_that.shippingRecipientName,_that.shippingPhone,_that.shippingLine1,_that.shippingLine2,_that.shippingCity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String customerName,  int subtotalMinor,  int discountMinor,  int deliveryFeeMinor,  int totalMinor,  DateTime createdAt,  AdminOrderStatus status,  String cancellationReason,  String? paymentMethod,  String? paymentStatus,  List<AdminOrderItem> items,  String customerPhone,  String shippingRecipientName,  String shippingPhone,  String shippingLine1,  String? shippingLine2,  String shippingCity)  $default,) {final _that = this;
switch (_that) {
case _AdminOrderSummary():
return $default(_that.id,_that.customerName,_that.subtotalMinor,_that.discountMinor,_that.deliveryFeeMinor,_that.totalMinor,_that.createdAt,_that.status,_that.cancellationReason,_that.paymentMethod,_that.paymentStatus,_that.items,_that.customerPhone,_that.shippingRecipientName,_that.shippingPhone,_that.shippingLine1,_that.shippingLine2,_that.shippingCity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String customerName,  int subtotalMinor,  int discountMinor,  int deliveryFeeMinor,  int totalMinor,  DateTime createdAt,  AdminOrderStatus status,  String cancellationReason,  String? paymentMethod,  String? paymentStatus,  List<AdminOrderItem> items,  String customerPhone,  String shippingRecipientName,  String shippingPhone,  String shippingLine1,  String? shippingLine2,  String shippingCity)?  $default,) {final _that = this;
switch (_that) {
case _AdminOrderSummary() when $default != null:
return $default(_that.id,_that.customerName,_that.subtotalMinor,_that.discountMinor,_that.deliveryFeeMinor,_that.totalMinor,_that.createdAt,_that.status,_that.cancellationReason,_that.paymentMethod,_that.paymentStatus,_that.items,_that.customerPhone,_that.shippingRecipientName,_that.shippingPhone,_that.shippingLine1,_that.shippingLine2,_that.shippingCity);case _:
  return null;

}
}

}

/// @nodoc


class _AdminOrderSummary extends AdminOrderSummary {
  const _AdminOrderSummary({required this.id, required this.customerName, required this.subtotalMinor, required this.discountMinor, required this.deliveryFeeMinor, required this.totalMinor, required this.createdAt, required this.status, this.cancellationReason = '', this.paymentMethod, this.paymentStatus,  List<AdminOrderItem> items = const [], this.customerPhone = '', this.shippingRecipientName = '', this.shippingPhone = '', this.shippingLine1 = '', this.shippingLine2, this.shippingCity = ''}): _items = items,super._();
  

@override final  String id;
@override final  String customerName;
@override final  int subtotalMinor;
@override final  int discountMinor;
@override final  int deliveryFeeMinor;
@override final  int totalMinor;
@override final  DateTime createdAt;
@override final  AdminOrderStatus status;
@override@JsonKey() final  String cancellationReason;
@override final  String? paymentMethod;
@override final  String? paymentStatus;
 final  List<AdminOrderItem> _items;
@override@JsonKey() List<AdminOrderItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  String customerPhone;
@override@JsonKey() final  String shippingRecipientName;
@override@JsonKey() final  String shippingPhone;
@override@JsonKey() final  String shippingLine1;
@override final  String? shippingLine2;
@override@JsonKey() final  String shippingCity;

/// Create a copy of AdminOrderSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminOrderSummaryCopyWith<_AdminOrderSummary> get copyWith => __$AdminOrderSummaryCopyWithImpl<_AdminOrderSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminOrderSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.subtotalMinor, subtotalMinor) || other.subtotalMinor == subtotalMinor)&&(identical(other.discountMinor, discountMinor) || other.discountMinor == discountMinor)&&(identical(other.deliveryFeeMinor, deliveryFeeMinor) || other.deliveryFeeMinor == deliveryFeeMinor)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.cancellationReason, cancellationReason) || other.cancellationReason == cancellationReason)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.customerPhone, customerPhone) || other.customerPhone == customerPhone)&&(identical(other.shippingRecipientName, shippingRecipientName) || other.shippingRecipientName == shippingRecipientName)&&(identical(other.shippingPhone, shippingPhone) || other.shippingPhone == shippingPhone)&&(identical(other.shippingLine1, shippingLine1) || other.shippingLine1 == shippingLine1)&&(identical(other.shippingLine2, shippingLine2) || other.shippingLine2 == shippingLine2)&&(identical(other.shippingCity, shippingCity) || other.shippingCity == shippingCity));
}


@override
int get hashCode => Object.hash(runtimeType,id,customerName,subtotalMinor,discountMinor,deliveryFeeMinor,totalMinor,createdAt,status,cancellationReason,paymentMethod,paymentStatus,const DeepCollectionEquality().hash(_items),customerPhone,shippingRecipientName,shippingPhone,shippingLine1,shippingLine2,shippingCity);

@override
String toString() {
  return 'AdminOrderSummary(id: $id, customerName: $customerName, subtotalMinor: $subtotalMinor, discountMinor: $discountMinor, deliveryFeeMinor: $deliveryFeeMinor, totalMinor: $totalMinor, createdAt: $createdAt, status: $status, cancellationReason: $cancellationReason, paymentMethod: $paymentMethod, paymentStatus: $paymentStatus, items: $items, customerPhone: $customerPhone, shippingRecipientName: $shippingRecipientName, shippingPhone: $shippingPhone, shippingLine1: $shippingLine1, shippingLine2: $shippingLine2, shippingCity: $shippingCity)';
}


}

/// @nodoc
abstract mixin class _$AdminOrderSummaryCopyWith<$Res> implements $AdminOrderSummaryCopyWith<$Res> {
  factory _$AdminOrderSummaryCopyWith(_AdminOrderSummary value, $Res Function(_AdminOrderSummary) _then) = __$AdminOrderSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String customerName, int subtotalMinor, int discountMinor, int deliveryFeeMinor, int totalMinor, DateTime createdAt, AdminOrderStatus status, String cancellationReason, String? paymentMethod, String? paymentStatus, List<AdminOrderItem> items, String customerPhone, String shippingRecipientName, String shippingPhone, String shippingLine1, String? shippingLine2, String shippingCity
});




}
/// @nodoc
class __$AdminOrderSummaryCopyWithImpl<$Res>
    implements _$AdminOrderSummaryCopyWith<$Res> {
  __$AdminOrderSummaryCopyWithImpl(this._self, this._then);

  final _AdminOrderSummary _self;
  final $Res Function(_AdminOrderSummary) _then;

/// Create a copy of AdminOrderSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? customerName = null,Object? subtotalMinor = null,Object? discountMinor = null,Object? deliveryFeeMinor = null,Object? totalMinor = null,Object? createdAt = null,Object? status = null,Object? cancellationReason = null,Object? paymentMethod = freezed,Object? paymentStatus = freezed,Object? items = null,Object? customerPhone = null,Object? shippingRecipientName = null,Object? shippingPhone = null,Object? shippingLine1 = null,Object? shippingLine2 = freezed,Object? shippingCity = null,}) {
  return _then(_AdminOrderSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,subtotalMinor: null == subtotalMinor ? _self.subtotalMinor : subtotalMinor // ignore: cast_nullable_to_non_nullable
as int,discountMinor: null == discountMinor ? _self.discountMinor : discountMinor // ignore: cast_nullable_to_non_nullable
as int,deliveryFeeMinor: null == deliveryFeeMinor ? _self.deliveryFeeMinor : deliveryFeeMinor // ignore: cast_nullable_to_non_nullable
as int,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AdminOrderStatus,cancellationReason: null == cancellationReason ? _self.cancellationReason : cancellationReason // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,paymentStatus: freezed == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<AdminOrderItem>,customerPhone: null == customerPhone ? _self.customerPhone : customerPhone // ignore: cast_nullable_to_non_nullable
as String,shippingRecipientName: null == shippingRecipientName ? _self.shippingRecipientName : shippingRecipientName // ignore: cast_nullable_to_non_nullable
as String,shippingPhone: null == shippingPhone ? _self.shippingPhone : shippingPhone // ignore: cast_nullable_to_non_nullable
as String,shippingLine1: null == shippingLine1 ? _self.shippingLine1 : shippingLine1 // ignore: cast_nullable_to_non_nullable
as String,shippingLine2: freezed == shippingLine2 ? _self.shippingLine2 : shippingLine2 // ignore: cast_nullable_to_non_nullable
as String?,shippingCity: null == shippingCity ? _self.shippingCity : shippingCity // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$AdminOrderItem {

 String get productName; int get quantity; int get lineTotalMinor; String? get variantName; int? get unitPriceMinor; int? get discountMinor; String? get imageUrl;
/// Create a copy of AdminOrderItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminOrderItemCopyWith<AdminOrderItem> get copyWith => _$AdminOrderItemCopyWithImpl<AdminOrderItem>(this as AdminOrderItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminOrderItem&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.lineTotalMinor, lineTotalMinor) || other.lineTotalMinor == lineTotalMinor)&&(identical(other.variantName, variantName) || other.variantName == variantName)&&(identical(other.unitPriceMinor, unitPriceMinor) || other.unitPriceMinor == unitPriceMinor)&&(identical(other.discountMinor, discountMinor) || other.discountMinor == discountMinor)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,productName,quantity,lineTotalMinor,variantName,unitPriceMinor,discountMinor,imageUrl);

@override
String toString() {
  return 'AdminOrderItem(productName: $productName, quantity: $quantity, lineTotalMinor: $lineTotalMinor, variantName: $variantName, unitPriceMinor: $unitPriceMinor, discountMinor: $discountMinor, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $AdminOrderItemCopyWith<$Res>  {
  factory $AdminOrderItemCopyWith(AdminOrderItem value, $Res Function(AdminOrderItem) _then) = _$AdminOrderItemCopyWithImpl;
@useResult
$Res call({
 String productName, int quantity, int lineTotalMinor, String? variantName, int? unitPriceMinor, int? discountMinor, String? imageUrl
});




}
/// @nodoc
class _$AdminOrderItemCopyWithImpl<$Res>
    implements $AdminOrderItemCopyWith<$Res> {
  _$AdminOrderItemCopyWithImpl(this._self, this._then);

  final AdminOrderItem _self;
  final $Res Function(AdminOrderItem) _then;

/// Create a copy of AdminOrderItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productName = null,Object? quantity = null,Object? lineTotalMinor = null,Object? variantName = freezed,Object? unitPriceMinor = freezed,Object? discountMinor = freezed,Object? imageUrl = freezed,}) {
  return _then(AdminOrderItem(
productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,lineTotalMinor: null == lineTotalMinor ? _self.lineTotalMinor : lineTotalMinor // ignore: cast_nullable_to_non_nullable
as int,variantName: freezed == variantName ? _self.variantName : variantName // ignore: cast_nullable_to_non_nullable
as String?,unitPriceMinor: freezed == unitPriceMinor ? _self.unitPriceMinor : unitPriceMinor // ignore: cast_nullable_to_non_nullable
as int?,discountMinor: freezed == discountMinor ? _self.discountMinor : discountMinor // ignore: cast_nullable_to_non_nullable
as int?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminOrderItem].
extension AdminOrderItemPatterns on AdminOrderItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminOrderItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminOrderItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminOrderItem value)  $default,){
final _that = this;
switch (_that) {
case _AdminOrderItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminOrderItem value)?  $default,){
final _that = this;
switch (_that) {
case _AdminOrderItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productName,  int quantity,  int lineTotalMinor,  String? variantName,  int? unitPriceMinor,  int? discountMinor,  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminOrderItem() when $default != null:
return $default(_that.productName,_that.quantity,_that.lineTotalMinor,_that.variantName,_that.unitPriceMinor,_that.discountMinor,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productName,  int quantity,  int lineTotalMinor,  String? variantName,  int? unitPriceMinor,  int? discountMinor,  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _AdminOrderItem():
return $default(_that.productName,_that.quantity,_that.lineTotalMinor,_that.variantName,_that.unitPriceMinor,_that.discountMinor,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productName,  int quantity,  int lineTotalMinor,  String? variantName,  int? unitPriceMinor,  int? discountMinor,  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _AdminOrderItem() when $default != null:
return $default(_that.productName,_that.quantity,_that.lineTotalMinor,_that.variantName,_that.unitPriceMinor,_that.discountMinor,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc


class _AdminOrderItem implements AdminOrderItem {
  const _AdminOrderItem({required this.productName, required this.quantity, required this.lineTotalMinor, this.variantName, this.unitPriceMinor, this.discountMinor, this.imageUrl});
  

@override final  String productName;
@override final  int quantity;
@override final  int lineTotalMinor;
@override final  String? variantName;
@override final  int? unitPriceMinor;
@override final  int? discountMinor;
@override final  String? imageUrl;

/// Create a copy of AdminOrderItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminOrderItemCopyWith<_AdminOrderItem> get copyWith => __$AdminOrderItemCopyWithImpl<_AdminOrderItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminOrderItem&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.lineTotalMinor, lineTotalMinor) || other.lineTotalMinor == lineTotalMinor)&&(identical(other.variantName, variantName) || other.variantName == variantName)&&(identical(other.unitPriceMinor, unitPriceMinor) || other.unitPriceMinor == unitPriceMinor)&&(identical(other.discountMinor, discountMinor) || other.discountMinor == discountMinor)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,productName,quantity,lineTotalMinor,variantName,unitPriceMinor,discountMinor,imageUrl);

@override
String toString() {
  return 'AdminOrderItem(productName: $productName, quantity: $quantity, lineTotalMinor: $lineTotalMinor, variantName: $variantName, unitPriceMinor: $unitPriceMinor, discountMinor: $discountMinor, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$AdminOrderItemCopyWith<$Res> implements $AdminOrderItemCopyWith<$Res> {
  factory _$AdminOrderItemCopyWith(_AdminOrderItem value, $Res Function(_AdminOrderItem) _then) = __$AdminOrderItemCopyWithImpl;
@override @useResult
$Res call({
 String productName, int quantity, int lineTotalMinor, String? variantName, int? unitPriceMinor, int? discountMinor, String? imageUrl
});




}
/// @nodoc
class __$AdminOrderItemCopyWithImpl<$Res>
    implements _$AdminOrderItemCopyWith<$Res> {
  __$AdminOrderItemCopyWithImpl(this._self, this._then);

  final _AdminOrderItem _self;
  final $Res Function(_AdminOrderItem) _then;

/// Create a copy of AdminOrderItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productName = null,Object? quantity = null,Object? lineTotalMinor = null,Object? variantName = freezed,Object? unitPriceMinor = freezed,Object? discountMinor = freezed,Object? imageUrl = freezed,}) {
  return _then(_AdminOrderItem(
productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,lineTotalMinor: null == lineTotalMinor ? _self.lineTotalMinor : lineTotalMinor // ignore: cast_nullable_to_non_nullable
as int,variantName: freezed == variantName ? _self.variantName : variantName // ignore: cast_nullable_to_non_nullable
as String?,unitPriceMinor: freezed == unitPriceMinor ? _self.unitPriceMinor : unitPriceMinor // ignore: cast_nullable_to_non_nullable
as int?,discountMinor: freezed == discountMinor ? _self.discountMinor : discountMinor // ignore: cast_nullable_to_non_nullable
as int?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$AdminOrderQuery {

 String get search; DateTime? get from; DateTime? get to; Set<String> get statuses; Set<String> get paymentStatuses; Set<String> get paymentMethods; String? get brandId; String? get categoryId; int? get minTotalMinor; int? get maxTotalMinor; bool get excludeCancelled; bool get needsAttention; AdminOrderSort get sort;
/// Create a copy of AdminOrderQuery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminOrderQueryCopyWith<AdminOrderQuery> get copyWith => _$AdminOrderQueryCopyWithImpl<AdminOrderQuery>(this as AdminOrderQuery, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminOrderQuery&&(identical(other.search, search) || other.search == search)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&const DeepCollectionEquality().equals(other.statuses, statuses)&&const DeepCollectionEquality().equals(other.paymentStatuses, paymentStatuses)&&const DeepCollectionEquality().equals(other.paymentMethods, paymentMethods)&&(identical(other.brandId, brandId) || other.brandId == brandId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.minTotalMinor, minTotalMinor) || other.minTotalMinor == minTotalMinor)&&(identical(other.maxTotalMinor, maxTotalMinor) || other.maxTotalMinor == maxTotalMinor)&&(identical(other.excludeCancelled, excludeCancelled) || other.excludeCancelled == excludeCancelled)&&(identical(other.needsAttention, needsAttention) || other.needsAttention == needsAttention)&&(identical(other.sort, sort) || other.sort == sort));
}


@override
int get hashCode => Object.hash(runtimeType,search,from,to,const DeepCollectionEquality().hash(statuses),const DeepCollectionEquality().hash(paymentStatuses),const DeepCollectionEquality().hash(paymentMethods),brandId,categoryId,minTotalMinor,maxTotalMinor,excludeCancelled,needsAttention,sort);

@override
String toString() {
  return 'AdminOrderQuery(search: $search, from: $from, to: $to, statuses: $statuses, paymentStatuses: $paymentStatuses, paymentMethods: $paymentMethods, brandId: $brandId, categoryId: $categoryId, minTotalMinor: $minTotalMinor, maxTotalMinor: $maxTotalMinor, excludeCancelled: $excludeCancelled, needsAttention: $needsAttention, sort: $sort)';
}


}

/// @nodoc
abstract mixin class $AdminOrderQueryCopyWith<$Res>  {
  factory $AdminOrderQueryCopyWith(AdminOrderQuery value, $Res Function(AdminOrderQuery) _then) = _$AdminOrderQueryCopyWithImpl;
@useResult
$Res call({
 String search, DateTime? from, DateTime? to, Set<String> statuses, Set<String> paymentStatuses, Set<String> paymentMethods, String? brandId, String? categoryId, int? minTotalMinor, int? maxTotalMinor, bool excludeCancelled, bool needsAttention, AdminOrderSort sort
});




}
/// @nodoc
class _$AdminOrderQueryCopyWithImpl<$Res>
    implements $AdminOrderQueryCopyWith<$Res> {
  _$AdminOrderQueryCopyWithImpl(this._self, this._then);

  final AdminOrderQuery _self;
  final $Res Function(AdminOrderQuery) _then;

/// Create a copy of AdminOrderQuery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? search = null,Object? from = freezed,Object? to = freezed,Object? statuses = null,Object? paymentStatuses = null,Object? paymentMethods = null,Object? brandId = freezed,Object? categoryId = freezed,Object? minTotalMinor = freezed,Object? maxTotalMinor = freezed,Object? excludeCancelled = null,Object? needsAttention = null,Object? sort = null,}) {
  return _then(AdminOrderQuery(
search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime?,to: freezed == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime?,statuses: null == statuses ? _self.statuses : statuses // ignore: cast_nullable_to_non_nullable
as Set<String>,paymentStatuses: null == paymentStatuses ? _self.paymentStatuses : paymentStatuses // ignore: cast_nullable_to_non_nullable
as Set<String>,paymentMethods: null == paymentMethods ? _self.paymentMethods : paymentMethods // ignore: cast_nullable_to_non_nullable
as Set<String>,brandId: freezed == brandId ? _self.brandId : brandId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,minTotalMinor: freezed == minTotalMinor ? _self.minTotalMinor : minTotalMinor // ignore: cast_nullable_to_non_nullable
as int?,maxTotalMinor: freezed == maxTotalMinor ? _self.maxTotalMinor : maxTotalMinor // ignore: cast_nullable_to_non_nullable
as int?,excludeCancelled: null == excludeCancelled ? _self.excludeCancelled : excludeCancelled // ignore: cast_nullable_to_non_nullable
as bool,needsAttention: null == needsAttention ? _self.needsAttention : needsAttention // ignore: cast_nullable_to_non_nullable
as bool,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as AdminOrderSort,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminOrderQuery].
extension AdminOrderQueryPatterns on AdminOrderQuery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminOrderQuery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminOrderQuery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminOrderQuery value)  $default,){
final _that = this;
switch (_that) {
case _AdminOrderQuery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminOrderQuery value)?  $default,){
final _that = this;
switch (_that) {
case _AdminOrderQuery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String search,  DateTime? from,  DateTime? to,  Set<String> statuses,  Set<String> paymentStatuses,  Set<String> paymentMethods,  String? brandId,  String? categoryId,  int? minTotalMinor,  int? maxTotalMinor,  bool excludeCancelled,  bool needsAttention,  AdminOrderSort sort)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminOrderQuery() when $default != null:
return $default(_that.search,_that.from,_that.to,_that.statuses,_that.paymentStatuses,_that.paymentMethods,_that.brandId,_that.categoryId,_that.minTotalMinor,_that.maxTotalMinor,_that.excludeCancelled,_that.needsAttention,_that.sort);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String search,  DateTime? from,  DateTime? to,  Set<String> statuses,  Set<String> paymentStatuses,  Set<String> paymentMethods,  String? brandId,  String? categoryId,  int? minTotalMinor,  int? maxTotalMinor,  bool excludeCancelled,  bool needsAttention,  AdminOrderSort sort)  $default,) {final _that = this;
switch (_that) {
case _AdminOrderQuery():
return $default(_that.search,_that.from,_that.to,_that.statuses,_that.paymentStatuses,_that.paymentMethods,_that.brandId,_that.categoryId,_that.minTotalMinor,_that.maxTotalMinor,_that.excludeCancelled,_that.needsAttention,_that.sort);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String search,  DateTime? from,  DateTime? to,  Set<String> statuses,  Set<String> paymentStatuses,  Set<String> paymentMethods,  String? brandId,  String? categoryId,  int? minTotalMinor,  int? maxTotalMinor,  bool excludeCancelled,  bool needsAttention,  AdminOrderSort sort)?  $default,) {final _that = this;
switch (_that) {
case _AdminOrderQuery() when $default != null:
return $default(_that.search,_that.from,_that.to,_that.statuses,_that.paymentStatuses,_that.paymentMethods,_that.brandId,_that.categoryId,_that.minTotalMinor,_that.maxTotalMinor,_that.excludeCancelled,_that.needsAttention,_that.sort);case _:
  return null;

}
}

}

/// @nodoc


class _AdminOrderQuery extends AdminOrderQuery {
  const _AdminOrderQuery({this.search = '', this.from, this.to,  Set<String> statuses = const <String>{},  Set<String> paymentStatuses = const <String>{},  Set<String> paymentMethods = const <String>{}, this.brandId, this.categoryId, this.minTotalMinor, this.maxTotalMinor, this.excludeCancelled = false, this.needsAttention = false, this.sort = AdminOrderSort.newest}): _statuses = statuses,_paymentStatuses = paymentStatuses,_paymentMethods = paymentMethods,super._();
  

@override@JsonKey() final  String search;
@override final  DateTime? from;
@override final  DateTime? to;
 final  Set<String> _statuses;
@override@JsonKey() Set<String> get statuses {
  if (_statuses is EqualUnmodifiableSetView) return _statuses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_statuses);
}

 final  Set<String> _paymentStatuses;
@override@JsonKey() Set<String> get paymentStatuses {
  if (_paymentStatuses is EqualUnmodifiableSetView) return _paymentStatuses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_paymentStatuses);
}

 final  Set<String> _paymentMethods;
@override@JsonKey() Set<String> get paymentMethods {
  if (_paymentMethods is EqualUnmodifiableSetView) return _paymentMethods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_paymentMethods);
}

@override final  String? brandId;
@override final  String? categoryId;
@override final  int? minTotalMinor;
@override final  int? maxTotalMinor;
@override@JsonKey() final  bool excludeCancelled;
@override@JsonKey() final  bool needsAttention;
@override@JsonKey() final  AdminOrderSort sort;

/// Create a copy of AdminOrderQuery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminOrderQueryCopyWith<_AdminOrderQuery> get copyWith => __$AdminOrderQueryCopyWithImpl<_AdminOrderQuery>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminOrderQuery&&(identical(other.search, search) || other.search == search)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&const DeepCollectionEquality().equals(other._statuses, _statuses)&&const DeepCollectionEquality().equals(other._paymentStatuses, _paymentStatuses)&&const DeepCollectionEquality().equals(other._paymentMethods, _paymentMethods)&&(identical(other.brandId, brandId) || other.brandId == brandId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.minTotalMinor, minTotalMinor) || other.minTotalMinor == minTotalMinor)&&(identical(other.maxTotalMinor, maxTotalMinor) || other.maxTotalMinor == maxTotalMinor)&&(identical(other.excludeCancelled, excludeCancelled) || other.excludeCancelled == excludeCancelled)&&(identical(other.needsAttention, needsAttention) || other.needsAttention == needsAttention)&&(identical(other.sort, sort) || other.sort == sort));
}


@override
int get hashCode => Object.hash(runtimeType,search,from,to,const DeepCollectionEquality().hash(_statuses),const DeepCollectionEquality().hash(_paymentStatuses),const DeepCollectionEquality().hash(_paymentMethods),brandId,categoryId,minTotalMinor,maxTotalMinor,excludeCancelled,needsAttention,sort);

@override
String toString() {
  return 'AdminOrderQuery(search: $search, from: $from, to: $to, statuses: $statuses, paymentStatuses: $paymentStatuses, paymentMethods: $paymentMethods, brandId: $brandId, categoryId: $categoryId, minTotalMinor: $minTotalMinor, maxTotalMinor: $maxTotalMinor, excludeCancelled: $excludeCancelled, needsAttention: $needsAttention, sort: $sort)';
}


}

/// @nodoc
abstract mixin class _$AdminOrderQueryCopyWith<$Res> implements $AdminOrderQueryCopyWith<$Res> {
  factory _$AdminOrderQueryCopyWith(_AdminOrderQuery value, $Res Function(_AdminOrderQuery) _then) = __$AdminOrderQueryCopyWithImpl;
@override @useResult
$Res call({
 String search, DateTime? from, DateTime? to, Set<String> statuses, Set<String> paymentStatuses, Set<String> paymentMethods, String? brandId, String? categoryId, int? minTotalMinor, int? maxTotalMinor, bool excludeCancelled, bool needsAttention, AdminOrderSort sort
});




}
/// @nodoc
class __$AdminOrderQueryCopyWithImpl<$Res>
    implements _$AdminOrderQueryCopyWith<$Res> {
  __$AdminOrderQueryCopyWithImpl(this._self, this._then);

  final _AdminOrderQuery _self;
  final $Res Function(_AdminOrderQuery) _then;

/// Create a copy of AdminOrderQuery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? search = null,Object? from = freezed,Object? to = freezed,Object? statuses = null,Object? paymentStatuses = null,Object? paymentMethods = null,Object? brandId = freezed,Object? categoryId = freezed,Object? minTotalMinor = freezed,Object? maxTotalMinor = freezed,Object? excludeCancelled = null,Object? needsAttention = null,Object? sort = null,}) {
  return _then(_AdminOrderQuery(
search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime?,to: freezed == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime?,statuses: null == statuses ? _self._statuses : statuses // ignore: cast_nullable_to_non_nullable
as Set<String>,paymentStatuses: null == paymentStatuses ? _self._paymentStatuses : paymentStatuses // ignore: cast_nullable_to_non_nullable
as Set<String>,paymentMethods: null == paymentMethods ? _self._paymentMethods : paymentMethods // ignore: cast_nullable_to_non_nullable
as Set<String>,brandId: freezed == brandId ? _self.brandId : brandId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,minTotalMinor: freezed == minTotalMinor ? _self.minTotalMinor : minTotalMinor // ignore: cast_nullable_to_non_nullable
as int?,maxTotalMinor: freezed == maxTotalMinor ? _self.maxTotalMinor : maxTotalMinor // ignore: cast_nullable_to_non_nullable
as int?,excludeCancelled: null == excludeCancelled ? _self.excludeCancelled : excludeCancelled // ignore: cast_nullable_to_non_nullable
as bool,needsAttention: null == needsAttention ? _self.needsAttention : needsAttention // ignore: cast_nullable_to_non_nullable
as bool,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as AdminOrderSort,
  ));
}


}

/// @nodoc
mixin _$AdminOrderPage {

 List<AdminOrderSummary> get orders; int get totalCount; int get totalMinor;
/// Create a copy of AdminOrderPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminOrderPageCopyWith<AdminOrderPage> get copyWith => _$AdminOrderPageCopyWithImpl<AdminOrderPage>(this as AdminOrderPage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminOrderPage&&const DeepCollectionEquality().equals(other.orders, orders)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(orders),totalCount,totalMinor);

@override
String toString() {
  return 'AdminOrderPage(orders: $orders, totalCount: $totalCount, totalMinor: $totalMinor)';
}


}

/// @nodoc
abstract mixin class $AdminOrderPageCopyWith<$Res>  {
  factory $AdminOrderPageCopyWith(AdminOrderPage value, $Res Function(AdminOrderPage) _then) = _$AdminOrderPageCopyWithImpl;
@useResult
$Res call({
 List<AdminOrderSummary> orders, int totalCount, int totalMinor
});




}
/// @nodoc
class _$AdminOrderPageCopyWithImpl<$Res>
    implements $AdminOrderPageCopyWith<$Res> {
  _$AdminOrderPageCopyWithImpl(this._self, this._then);

  final AdminOrderPage _self;
  final $Res Function(AdminOrderPage) _then;

/// Create a copy of AdminOrderPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orders = null,Object? totalCount = null,Object? totalMinor = null,}) {
  return _then(AdminOrderPage(
orders: null == orders ? _self.orders : orders // ignore: cast_nullable_to_non_nullable
as List<AdminOrderSummary>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminOrderPage].
extension AdminOrderPagePatterns on AdminOrderPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminOrderPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminOrderPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminOrderPage value)  $default,){
final _that = this;
switch (_that) {
case _AdminOrderPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminOrderPage value)?  $default,){
final _that = this;
switch (_that) {
case _AdminOrderPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AdminOrderSummary> orders,  int totalCount,  int totalMinor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminOrderPage() when $default != null:
return $default(_that.orders,_that.totalCount,_that.totalMinor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AdminOrderSummary> orders,  int totalCount,  int totalMinor)  $default,) {final _that = this;
switch (_that) {
case _AdminOrderPage():
return $default(_that.orders,_that.totalCount,_that.totalMinor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AdminOrderSummary> orders,  int totalCount,  int totalMinor)?  $default,) {final _that = this;
switch (_that) {
case _AdminOrderPage() when $default != null:
return $default(_that.orders,_that.totalCount,_that.totalMinor);case _:
  return null;

}
}

}

/// @nodoc


class _AdminOrderPage implements AdminOrderPage {
  const _AdminOrderPage({ List<AdminOrderSummary> orders = const <AdminOrderSummary>[], this.totalCount = 0, this.totalMinor = 0}): _orders = orders;
  

 final  List<AdminOrderSummary> _orders;
@override@JsonKey() List<AdminOrderSummary> get orders {
  if (_orders is EqualUnmodifiableListView) return _orders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_orders);
}

@override@JsonKey() final  int totalCount;
@override@JsonKey() final  int totalMinor;

/// Create a copy of AdminOrderPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminOrderPageCopyWith<_AdminOrderPage> get copyWith => __$AdminOrderPageCopyWithImpl<_AdminOrderPage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminOrderPage&&const DeepCollectionEquality().equals(other._orders, _orders)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_orders),totalCount,totalMinor);

@override
String toString() {
  return 'AdminOrderPage(orders: $orders, totalCount: $totalCount, totalMinor: $totalMinor)';
}


}

/// @nodoc
abstract mixin class _$AdminOrderPageCopyWith<$Res> implements $AdminOrderPageCopyWith<$Res> {
  factory _$AdminOrderPageCopyWith(_AdminOrderPage value, $Res Function(_AdminOrderPage) _then) = __$AdminOrderPageCopyWithImpl;
@override @useResult
$Res call({
 List<AdminOrderSummary> orders, int totalCount, int totalMinor
});




}
/// @nodoc
class __$AdminOrderPageCopyWithImpl<$Res>
    implements _$AdminOrderPageCopyWith<$Res> {
  __$AdminOrderPageCopyWithImpl(this._self, this._then);

  final _AdminOrderPage _self;
  final $Res Function(_AdminOrderPage) _then;

/// Create a copy of AdminOrderPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orders = null,Object? totalCount = null,Object? totalMinor = null,}) {
  return _then(_AdminOrderPage(
orders: null == orders ? _self._orders : orders // ignore: cast_nullable_to_non_nullable
as List<AdminOrderSummary>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$AuditEntry {

 String get id; String get action; String get targetType; DateTime get createdAt; String? get actor; String? get targetId;
/// Create a copy of AuditEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditEntryCopyWith<AuditEntry> get copyWith => _$AuditEntryCopyWithImpl<AuditEntry>(this as AuditEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.action, action) || other.action == action)&&(identical(other.targetType, targetType) || other.targetType == targetType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.actor, actor) || other.actor == actor)&&(identical(other.targetId, targetId) || other.targetId == targetId));
}


@override
int get hashCode => Object.hash(runtimeType,id,action,targetType,createdAt,actor,targetId);

@override
String toString() {
  return 'AuditEntry(id: $id, action: $action, targetType: $targetType, createdAt: $createdAt, actor: $actor, targetId: $targetId)';
}


}

/// @nodoc
abstract mixin class $AuditEntryCopyWith<$Res>  {
  factory $AuditEntryCopyWith(AuditEntry value, $Res Function(AuditEntry) _then) = _$AuditEntryCopyWithImpl;
@useResult
$Res call({
 String id, String action, String targetType, DateTime createdAt, String? actor, String? targetId
});




}
/// @nodoc
class _$AuditEntryCopyWithImpl<$Res>
    implements $AuditEntryCopyWith<$Res> {
  _$AuditEntryCopyWithImpl(this._self, this._then);

  final AuditEntry _self;
  final $Res Function(AuditEntry) _then;

/// Create a copy of AuditEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? action = null,Object? targetType = null,Object? createdAt = null,Object? actor = freezed,Object? targetId = freezed,}) {
  return _then(AuditEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,targetType: null == targetType ? _self.targetType : targetType // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,actor: freezed == actor ? _self.actor : actor // ignore: cast_nullable_to_non_nullable
as String?,targetId: freezed == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditEntry].
extension AuditEntryPatterns on AuditEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditEntry value)  $default,){
final _that = this;
switch (_that) {
case _AuditEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditEntry value)?  $default,){
final _that = this;
switch (_that) {
case _AuditEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String action,  String targetType,  DateTime createdAt,  String? actor,  String? targetId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditEntry() when $default != null:
return $default(_that.id,_that.action,_that.targetType,_that.createdAt,_that.actor,_that.targetId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String action,  String targetType,  DateTime createdAt,  String? actor,  String? targetId)  $default,) {final _that = this;
switch (_that) {
case _AuditEntry():
return $default(_that.id,_that.action,_that.targetType,_that.createdAt,_that.actor,_that.targetId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String action,  String targetType,  DateTime createdAt,  String? actor,  String? targetId)?  $default,) {final _that = this;
switch (_that) {
case _AuditEntry() when $default != null:
return $default(_that.id,_that.action,_that.targetType,_that.createdAt,_that.actor,_that.targetId);case _:
  return null;

}
}

}

/// @nodoc


class _AuditEntry implements AuditEntry {
  const _AuditEntry({required this.id, required this.action, required this.targetType, required this.createdAt, this.actor, this.targetId});
  

@override final  String id;
@override final  String action;
@override final  String targetType;
@override final  DateTime createdAt;
@override final  String? actor;
@override final  String? targetId;

/// Create a copy of AuditEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditEntryCopyWith<_AuditEntry> get copyWith => __$AuditEntryCopyWithImpl<_AuditEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.action, action) || other.action == action)&&(identical(other.targetType, targetType) || other.targetType == targetType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.actor, actor) || other.actor == actor)&&(identical(other.targetId, targetId) || other.targetId == targetId));
}


@override
int get hashCode => Object.hash(runtimeType,id,action,targetType,createdAt,actor,targetId);

@override
String toString() {
  return 'AuditEntry(id: $id, action: $action, targetType: $targetType, createdAt: $createdAt, actor: $actor, targetId: $targetId)';
}


}

/// @nodoc
abstract mixin class _$AuditEntryCopyWith<$Res> implements $AuditEntryCopyWith<$Res> {
  factory _$AuditEntryCopyWith(_AuditEntry value, $Res Function(_AuditEntry) _then) = __$AuditEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String action, String targetType, DateTime createdAt, String? actor, String? targetId
});




}
/// @nodoc
class __$AuditEntryCopyWithImpl<$Res>
    implements _$AuditEntryCopyWith<$Res> {
  __$AuditEntryCopyWithImpl(this._self, this._then);

  final _AuditEntry _self;
  final $Res Function(_AuditEntry) _then;

/// Create a copy of AuditEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? action = null,Object? targetType = null,Object? createdAt = null,Object? actor = freezed,Object? targetId = freezed,}) {
  return _then(_AuditEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,targetType: null == targetType ? _self.targetType : targetType // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,actor: freezed == actor ? _self.actor : actor // ignore: cast_nullable_to_non_nullable
as String?,targetId: freezed == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$PlatformAnalyticsReport {

 int get orderCount; int get gmvMinor; int get deliveryFeesMinor; int get activeProducts;
/// Create a copy of PlatformAnalyticsReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlatformAnalyticsReportCopyWith<PlatformAnalyticsReport> get copyWith => _$PlatformAnalyticsReportCopyWithImpl<PlatformAnalyticsReport>(this as PlatformAnalyticsReport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlatformAnalyticsReport&&(identical(other.orderCount, orderCount) || other.orderCount == orderCount)&&(identical(other.gmvMinor, gmvMinor) || other.gmvMinor == gmvMinor)&&(identical(other.deliveryFeesMinor, deliveryFeesMinor) || other.deliveryFeesMinor == deliveryFeesMinor)&&(identical(other.activeProducts, activeProducts) || other.activeProducts == activeProducts));
}


@override
int get hashCode => Object.hash(runtimeType,orderCount,gmvMinor,deliveryFeesMinor,activeProducts);

@override
String toString() {
  return 'PlatformAnalyticsReport(orderCount: $orderCount, gmvMinor: $gmvMinor, deliveryFeesMinor: $deliveryFeesMinor, activeProducts: $activeProducts)';
}


}

/// @nodoc
abstract mixin class $PlatformAnalyticsReportCopyWith<$Res>  {
  factory $PlatformAnalyticsReportCopyWith(PlatformAnalyticsReport value, $Res Function(PlatformAnalyticsReport) _then) = _$PlatformAnalyticsReportCopyWithImpl;
@useResult
$Res call({
 int orderCount, int gmvMinor, int deliveryFeesMinor, int activeProducts
});




}
/// @nodoc
class _$PlatformAnalyticsReportCopyWithImpl<$Res>
    implements $PlatformAnalyticsReportCopyWith<$Res> {
  _$PlatformAnalyticsReportCopyWithImpl(this._self, this._then);

  final PlatformAnalyticsReport _self;
  final $Res Function(PlatformAnalyticsReport) _then;

/// Create a copy of PlatformAnalyticsReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderCount = null,Object? gmvMinor = null,Object? deliveryFeesMinor = null,Object? activeProducts = null,}) {
  return _then(PlatformAnalyticsReport(
orderCount: null == orderCount ? _self.orderCount : orderCount // ignore: cast_nullable_to_non_nullable
as int,gmvMinor: null == gmvMinor ? _self.gmvMinor : gmvMinor // ignore: cast_nullable_to_non_nullable
as int,deliveryFeesMinor: null == deliveryFeesMinor ? _self.deliveryFeesMinor : deliveryFeesMinor // ignore: cast_nullable_to_non_nullable
as int,activeProducts: null == activeProducts ? _self.activeProducts : activeProducts // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PlatformAnalyticsReport].
extension PlatformAnalyticsReportPatterns on PlatformAnalyticsReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlatformAnalyticsReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlatformAnalyticsReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlatformAnalyticsReport value)  $default,){
final _that = this;
switch (_that) {
case _PlatformAnalyticsReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlatformAnalyticsReport value)?  $default,){
final _that = this;
switch (_that) {
case _PlatformAnalyticsReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int orderCount,  int gmvMinor,  int deliveryFeesMinor,  int activeProducts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlatformAnalyticsReport() when $default != null:
return $default(_that.orderCount,_that.gmvMinor,_that.deliveryFeesMinor,_that.activeProducts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int orderCount,  int gmvMinor,  int deliveryFeesMinor,  int activeProducts)  $default,) {final _that = this;
switch (_that) {
case _PlatformAnalyticsReport():
return $default(_that.orderCount,_that.gmvMinor,_that.deliveryFeesMinor,_that.activeProducts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int orderCount,  int gmvMinor,  int deliveryFeesMinor,  int activeProducts)?  $default,) {final _that = this;
switch (_that) {
case _PlatformAnalyticsReport() when $default != null:
return $default(_that.orderCount,_that.gmvMinor,_that.deliveryFeesMinor,_that.activeProducts);case _:
  return null;

}
}

}

/// @nodoc


class _PlatformAnalyticsReport implements PlatformAnalyticsReport {
  const _PlatformAnalyticsReport({required this.orderCount, required this.gmvMinor, required this.deliveryFeesMinor, required this.activeProducts});
  

@override final  int orderCount;
@override final  int gmvMinor;
@override final  int deliveryFeesMinor;
@override final  int activeProducts;

/// Create a copy of PlatformAnalyticsReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlatformAnalyticsReportCopyWith<_PlatformAnalyticsReport> get copyWith => __$PlatformAnalyticsReportCopyWithImpl<_PlatformAnalyticsReport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlatformAnalyticsReport&&(identical(other.orderCount, orderCount) || other.orderCount == orderCount)&&(identical(other.gmvMinor, gmvMinor) || other.gmvMinor == gmvMinor)&&(identical(other.deliveryFeesMinor, deliveryFeesMinor) || other.deliveryFeesMinor == deliveryFeesMinor)&&(identical(other.activeProducts, activeProducts) || other.activeProducts == activeProducts));
}


@override
int get hashCode => Object.hash(runtimeType,orderCount,gmvMinor,deliveryFeesMinor,activeProducts);

@override
String toString() {
  return 'PlatformAnalyticsReport(orderCount: $orderCount, gmvMinor: $gmvMinor, deliveryFeesMinor: $deliveryFeesMinor, activeProducts: $activeProducts)';
}


}

/// @nodoc
abstract mixin class _$PlatformAnalyticsReportCopyWith<$Res> implements $PlatformAnalyticsReportCopyWith<$Res> {
  factory _$PlatformAnalyticsReportCopyWith(_PlatformAnalyticsReport value, $Res Function(_PlatformAnalyticsReport) _then) = __$PlatformAnalyticsReportCopyWithImpl;
@override @useResult
$Res call({
 int orderCount, int gmvMinor, int deliveryFeesMinor, int activeProducts
});




}
/// @nodoc
class __$PlatformAnalyticsReportCopyWithImpl<$Res>
    implements _$PlatformAnalyticsReportCopyWith<$Res> {
  __$PlatformAnalyticsReportCopyWithImpl(this._self, this._then);

  final _PlatformAnalyticsReport _self;
  final $Res Function(_PlatformAnalyticsReport) _then;

/// Create a copy of PlatformAnalyticsReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderCount = null,Object? gmvMinor = null,Object? deliveryFeesMinor = null,Object? activeProducts = null,}) {
  return _then(_PlatformAnalyticsReport(
orderCount: null == orderCount ? _self.orderCount : orderCount // ignore: cast_nullable_to_non_nullable
as int,gmvMinor: null == gmvMinor ? _self.gmvMinor : gmvMinor // ignore: cast_nullable_to_non_nullable
as int,deliveryFeesMinor: null == deliveryFeesMinor ? _self.deliveryFeesMinor : deliveryFeesMinor // ignore: cast_nullable_to_non_nullable
as int,activeProducts: null == activeProducts ? _self.activeProducts : activeProducts // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$AdminKpis {

 int get totalProducts; int get activeProducts; int get totalOrders; int get totalCustomers; int get totalSalesMinor; int get lowStockProducts; int get outOfStockProducts; List<AdminBestSeller> get bestSellers; List<AdminTrendPoint> get salesTrend;
/// Create a copy of AdminKpis
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminKpisCopyWith<AdminKpis> get copyWith => _$AdminKpisCopyWithImpl<AdminKpis>(this as AdminKpis, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminKpis&&(identical(other.totalProducts, totalProducts) || other.totalProducts == totalProducts)&&(identical(other.activeProducts, activeProducts) || other.activeProducts == activeProducts)&&(identical(other.totalOrders, totalOrders) || other.totalOrders == totalOrders)&&(identical(other.totalCustomers, totalCustomers) || other.totalCustomers == totalCustomers)&&(identical(other.totalSalesMinor, totalSalesMinor) || other.totalSalesMinor == totalSalesMinor)&&(identical(other.lowStockProducts, lowStockProducts) || other.lowStockProducts == lowStockProducts)&&(identical(other.outOfStockProducts, outOfStockProducts) || other.outOfStockProducts == outOfStockProducts)&&const DeepCollectionEquality().equals(other.bestSellers, bestSellers)&&const DeepCollectionEquality().equals(other.salesTrend, salesTrend));
}


@override
int get hashCode => Object.hash(runtimeType,totalProducts,activeProducts,totalOrders,totalCustomers,totalSalesMinor,lowStockProducts,outOfStockProducts,const DeepCollectionEquality().hash(bestSellers),const DeepCollectionEquality().hash(salesTrend));

@override
String toString() {
  return 'AdminKpis(totalProducts: $totalProducts, activeProducts: $activeProducts, totalOrders: $totalOrders, totalCustomers: $totalCustomers, totalSalesMinor: $totalSalesMinor, lowStockProducts: $lowStockProducts, outOfStockProducts: $outOfStockProducts, bestSellers: $bestSellers, salesTrend: $salesTrend)';
}


}

/// @nodoc
abstract mixin class $AdminKpisCopyWith<$Res>  {
  factory $AdminKpisCopyWith(AdminKpis value, $Res Function(AdminKpis) _then) = _$AdminKpisCopyWithImpl;
@useResult
$Res call({
 int totalProducts, int activeProducts, int totalOrders, int totalCustomers, int totalSalesMinor, int lowStockProducts, int outOfStockProducts, List<AdminBestSeller> bestSellers, List<AdminTrendPoint> salesTrend
});




}
/// @nodoc
class _$AdminKpisCopyWithImpl<$Res>
    implements $AdminKpisCopyWith<$Res> {
  _$AdminKpisCopyWithImpl(this._self, this._then);

  final AdminKpis _self;
  final $Res Function(AdminKpis) _then;

/// Create a copy of AdminKpis
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalProducts = null,Object? activeProducts = null,Object? totalOrders = null,Object? totalCustomers = null,Object? totalSalesMinor = null,Object? lowStockProducts = null,Object? outOfStockProducts = null,Object? bestSellers = null,Object? salesTrend = null,}) {
  return _then(AdminKpis(
totalProducts: null == totalProducts ? _self.totalProducts : totalProducts // ignore: cast_nullable_to_non_nullable
as int,activeProducts: null == activeProducts ? _self.activeProducts : activeProducts // ignore: cast_nullable_to_non_nullable
as int,totalOrders: null == totalOrders ? _self.totalOrders : totalOrders // ignore: cast_nullable_to_non_nullable
as int,totalCustomers: null == totalCustomers ? _self.totalCustomers : totalCustomers // ignore: cast_nullable_to_non_nullable
as int,totalSalesMinor: null == totalSalesMinor ? _self.totalSalesMinor : totalSalesMinor // ignore: cast_nullable_to_non_nullable
as int,lowStockProducts: null == lowStockProducts ? _self.lowStockProducts : lowStockProducts // ignore: cast_nullable_to_non_nullable
as int,outOfStockProducts: null == outOfStockProducts ? _self.outOfStockProducts : outOfStockProducts // ignore: cast_nullable_to_non_nullable
as int,bestSellers: null == bestSellers ? _self.bestSellers : bestSellers // ignore: cast_nullable_to_non_nullable
as List<AdminBestSeller>,salesTrend: null == salesTrend ? _self.salesTrend : salesTrend // ignore: cast_nullable_to_non_nullable
as List<AdminTrendPoint>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminKpis].
extension AdminKpisPatterns on AdminKpis {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminKpis value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminKpis() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminKpis value)  $default,){
final _that = this;
switch (_that) {
case _AdminKpis():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminKpis value)?  $default,){
final _that = this;
switch (_that) {
case _AdminKpis() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalProducts,  int activeProducts,  int totalOrders,  int totalCustomers,  int totalSalesMinor,  int lowStockProducts,  int outOfStockProducts,  List<AdminBestSeller> bestSellers,  List<AdminTrendPoint> salesTrend)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminKpis() when $default != null:
return $default(_that.totalProducts,_that.activeProducts,_that.totalOrders,_that.totalCustomers,_that.totalSalesMinor,_that.lowStockProducts,_that.outOfStockProducts,_that.bestSellers,_that.salesTrend);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalProducts,  int activeProducts,  int totalOrders,  int totalCustomers,  int totalSalesMinor,  int lowStockProducts,  int outOfStockProducts,  List<AdminBestSeller> bestSellers,  List<AdminTrendPoint> salesTrend)  $default,) {final _that = this;
switch (_that) {
case _AdminKpis():
return $default(_that.totalProducts,_that.activeProducts,_that.totalOrders,_that.totalCustomers,_that.totalSalesMinor,_that.lowStockProducts,_that.outOfStockProducts,_that.bestSellers,_that.salesTrend);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalProducts,  int activeProducts,  int totalOrders,  int totalCustomers,  int totalSalesMinor,  int lowStockProducts,  int outOfStockProducts,  List<AdminBestSeller> bestSellers,  List<AdminTrendPoint> salesTrend)?  $default,) {final _that = this;
switch (_that) {
case _AdminKpis() when $default != null:
return $default(_that.totalProducts,_that.activeProducts,_that.totalOrders,_that.totalCustomers,_that.totalSalesMinor,_that.lowStockProducts,_that.outOfStockProducts,_that.bestSellers,_that.salesTrend);case _:
  return null;

}
}

}

/// @nodoc


class _AdminKpis implements AdminKpis {
  const _AdminKpis({required this.totalProducts, required this.activeProducts, required this.totalOrders, required this.totalCustomers, required this.totalSalesMinor, required this.lowStockProducts, required this.outOfStockProducts,  List<AdminBestSeller> bestSellers = const [],  List<AdminTrendPoint> salesTrend = const []}): _bestSellers = bestSellers,_salesTrend = salesTrend;
  

@override final  int totalProducts;
@override final  int activeProducts;
@override final  int totalOrders;
@override final  int totalCustomers;
@override final  int totalSalesMinor;
@override final  int lowStockProducts;
@override final  int outOfStockProducts;
 final  List<AdminBestSeller> _bestSellers;
@override@JsonKey() List<AdminBestSeller> get bestSellers {
  if (_bestSellers is EqualUnmodifiableListView) return _bestSellers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bestSellers);
}

 final  List<AdminTrendPoint> _salesTrend;
@override@JsonKey() List<AdminTrendPoint> get salesTrend {
  if (_salesTrend is EqualUnmodifiableListView) return _salesTrend;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_salesTrend);
}


/// Create a copy of AdminKpis
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminKpisCopyWith<_AdminKpis> get copyWith => __$AdminKpisCopyWithImpl<_AdminKpis>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminKpis&&(identical(other.totalProducts, totalProducts) || other.totalProducts == totalProducts)&&(identical(other.activeProducts, activeProducts) || other.activeProducts == activeProducts)&&(identical(other.totalOrders, totalOrders) || other.totalOrders == totalOrders)&&(identical(other.totalCustomers, totalCustomers) || other.totalCustomers == totalCustomers)&&(identical(other.totalSalesMinor, totalSalesMinor) || other.totalSalesMinor == totalSalesMinor)&&(identical(other.lowStockProducts, lowStockProducts) || other.lowStockProducts == lowStockProducts)&&(identical(other.outOfStockProducts, outOfStockProducts) || other.outOfStockProducts == outOfStockProducts)&&const DeepCollectionEquality().equals(other._bestSellers, _bestSellers)&&const DeepCollectionEquality().equals(other._salesTrend, _salesTrend));
}


@override
int get hashCode => Object.hash(runtimeType,totalProducts,activeProducts,totalOrders,totalCustomers,totalSalesMinor,lowStockProducts,outOfStockProducts,const DeepCollectionEquality().hash(_bestSellers),const DeepCollectionEquality().hash(_salesTrend));

@override
String toString() {
  return 'AdminKpis(totalProducts: $totalProducts, activeProducts: $activeProducts, totalOrders: $totalOrders, totalCustomers: $totalCustomers, totalSalesMinor: $totalSalesMinor, lowStockProducts: $lowStockProducts, outOfStockProducts: $outOfStockProducts, bestSellers: $bestSellers, salesTrend: $salesTrend)';
}


}

/// @nodoc
abstract mixin class _$AdminKpisCopyWith<$Res> implements $AdminKpisCopyWith<$Res> {
  factory _$AdminKpisCopyWith(_AdminKpis value, $Res Function(_AdminKpis) _then) = __$AdminKpisCopyWithImpl;
@override @useResult
$Res call({
 int totalProducts, int activeProducts, int totalOrders, int totalCustomers, int totalSalesMinor, int lowStockProducts, int outOfStockProducts, List<AdminBestSeller> bestSellers, List<AdminTrendPoint> salesTrend
});




}
/// @nodoc
class __$AdminKpisCopyWithImpl<$Res>
    implements _$AdminKpisCopyWith<$Res> {
  __$AdminKpisCopyWithImpl(this._self, this._then);

  final _AdminKpis _self;
  final $Res Function(_AdminKpis) _then;

/// Create a copy of AdminKpis
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalProducts = null,Object? activeProducts = null,Object? totalOrders = null,Object? totalCustomers = null,Object? totalSalesMinor = null,Object? lowStockProducts = null,Object? outOfStockProducts = null,Object? bestSellers = null,Object? salesTrend = null,}) {
  return _then(_AdminKpis(
totalProducts: null == totalProducts ? _self.totalProducts : totalProducts // ignore: cast_nullable_to_non_nullable
as int,activeProducts: null == activeProducts ? _self.activeProducts : activeProducts // ignore: cast_nullable_to_non_nullable
as int,totalOrders: null == totalOrders ? _self.totalOrders : totalOrders // ignore: cast_nullable_to_non_nullable
as int,totalCustomers: null == totalCustomers ? _self.totalCustomers : totalCustomers // ignore: cast_nullable_to_non_nullable
as int,totalSalesMinor: null == totalSalesMinor ? _self.totalSalesMinor : totalSalesMinor // ignore: cast_nullable_to_non_nullable
as int,lowStockProducts: null == lowStockProducts ? _self.lowStockProducts : lowStockProducts // ignore: cast_nullable_to_non_nullable
as int,outOfStockProducts: null == outOfStockProducts ? _self.outOfStockProducts : outOfStockProducts // ignore: cast_nullable_to_non_nullable
as int,bestSellers: null == bestSellers ? _self._bestSellers : bestSellers // ignore: cast_nullable_to_non_nullable
as List<AdminBestSeller>,salesTrend: null == salesTrend ? _self._salesTrend : salesTrend // ignore: cast_nullable_to_non_nullable
as List<AdminTrendPoint>,
  ));
}


}

/// @nodoc
mixin _$AdminSalesReport {

 DateTime get from; DateTime get to; int get totalOrders; int get completedOrders; int get cancelledOrders; int get totalSalesMinor; int get averageOrderValueMinor; int get lowStockProducts; int get outOfStockProducts; List<AdminBestSeller> get bestSellers; List<AdminCategoryUnits> get topCategories; List<AdminCustomerFrequency> get purchaseFrequency; int get netSettledMinor; int get inventoryValuationMinor; AdminPaymentSplit get paymentSplit; List<AdminBrandRevenue> get brandRevenue;
/// Create a copy of AdminSalesReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminSalesReportCopyWith<AdminSalesReport> get copyWith => _$AdminSalesReportCopyWithImpl<AdminSalesReport>(this as AdminSalesReport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminSalesReport&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.totalOrders, totalOrders) || other.totalOrders == totalOrders)&&(identical(other.completedOrders, completedOrders) || other.completedOrders == completedOrders)&&(identical(other.cancelledOrders, cancelledOrders) || other.cancelledOrders == cancelledOrders)&&(identical(other.totalSalesMinor, totalSalesMinor) || other.totalSalesMinor == totalSalesMinor)&&(identical(other.averageOrderValueMinor, averageOrderValueMinor) || other.averageOrderValueMinor == averageOrderValueMinor)&&(identical(other.lowStockProducts, lowStockProducts) || other.lowStockProducts == lowStockProducts)&&(identical(other.outOfStockProducts, outOfStockProducts) || other.outOfStockProducts == outOfStockProducts)&&const DeepCollectionEquality().equals(other.bestSellers, bestSellers)&&const DeepCollectionEquality().equals(other.topCategories, topCategories)&&const DeepCollectionEquality().equals(other.purchaseFrequency, purchaseFrequency)&&(identical(other.netSettledMinor, netSettledMinor) || other.netSettledMinor == netSettledMinor)&&(identical(other.inventoryValuationMinor, inventoryValuationMinor) || other.inventoryValuationMinor == inventoryValuationMinor)&&(identical(other.paymentSplit, paymentSplit) || other.paymentSplit == paymentSplit)&&const DeepCollectionEquality().equals(other.brandRevenue, brandRevenue));
}


@override
int get hashCode => Object.hash(runtimeType,from,to,totalOrders,completedOrders,cancelledOrders,totalSalesMinor,averageOrderValueMinor,lowStockProducts,outOfStockProducts,const DeepCollectionEquality().hash(bestSellers),const DeepCollectionEquality().hash(topCategories),const DeepCollectionEquality().hash(purchaseFrequency),netSettledMinor,inventoryValuationMinor,paymentSplit,const DeepCollectionEquality().hash(brandRevenue));

@override
String toString() {
  return 'AdminSalesReport(from: $from, to: $to, totalOrders: $totalOrders, completedOrders: $completedOrders, cancelledOrders: $cancelledOrders, totalSalesMinor: $totalSalesMinor, averageOrderValueMinor: $averageOrderValueMinor, lowStockProducts: $lowStockProducts, outOfStockProducts: $outOfStockProducts, bestSellers: $bestSellers, topCategories: $topCategories, purchaseFrequency: $purchaseFrequency, netSettledMinor: $netSettledMinor, inventoryValuationMinor: $inventoryValuationMinor, paymentSplit: $paymentSplit, brandRevenue: $brandRevenue)';
}


}

/// @nodoc
abstract mixin class $AdminSalesReportCopyWith<$Res>  {
  factory $AdminSalesReportCopyWith(AdminSalesReport value, $Res Function(AdminSalesReport) _then) = _$AdminSalesReportCopyWithImpl;
@useResult
$Res call({
 DateTime from, DateTime to, int totalOrders, int completedOrders, int cancelledOrders, int totalSalesMinor, int averageOrderValueMinor, int lowStockProducts, int outOfStockProducts, List<AdminBestSeller> bestSellers, List<AdminCategoryUnits> topCategories, List<AdminCustomerFrequency> purchaseFrequency, int netSettledMinor, int inventoryValuationMinor, AdminPaymentSplit paymentSplit, List<AdminBrandRevenue> brandRevenue
});


$AdminPaymentSplitCopyWith<$Res> get paymentSplit;

}
/// @nodoc
class _$AdminSalesReportCopyWithImpl<$Res>
    implements $AdminSalesReportCopyWith<$Res> {
  _$AdminSalesReportCopyWithImpl(this._self, this._then);

  final AdminSalesReport _self;
  final $Res Function(AdminSalesReport) _then;

/// Create a copy of AdminSalesReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? to = null,Object? totalOrders = null,Object? completedOrders = null,Object? cancelledOrders = null,Object? totalSalesMinor = null,Object? averageOrderValueMinor = null,Object? lowStockProducts = null,Object? outOfStockProducts = null,Object? bestSellers = null,Object? topCategories = null,Object? purchaseFrequency = null,Object? netSettledMinor = null,Object? inventoryValuationMinor = null,Object? paymentSplit = null,Object? brandRevenue = null,}) {
  return _then(AdminSalesReport(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime,totalOrders: null == totalOrders ? _self.totalOrders : totalOrders // ignore: cast_nullable_to_non_nullable
as int,completedOrders: null == completedOrders ? _self.completedOrders : completedOrders // ignore: cast_nullable_to_non_nullable
as int,cancelledOrders: null == cancelledOrders ? _self.cancelledOrders : cancelledOrders // ignore: cast_nullable_to_non_nullable
as int,totalSalesMinor: null == totalSalesMinor ? _self.totalSalesMinor : totalSalesMinor // ignore: cast_nullable_to_non_nullable
as int,averageOrderValueMinor: null == averageOrderValueMinor ? _self.averageOrderValueMinor : averageOrderValueMinor // ignore: cast_nullable_to_non_nullable
as int,lowStockProducts: null == lowStockProducts ? _self.lowStockProducts : lowStockProducts // ignore: cast_nullable_to_non_nullable
as int,outOfStockProducts: null == outOfStockProducts ? _self.outOfStockProducts : outOfStockProducts // ignore: cast_nullable_to_non_nullable
as int,bestSellers: null == bestSellers ? _self.bestSellers : bestSellers // ignore: cast_nullable_to_non_nullable
as List<AdminBestSeller>,topCategories: null == topCategories ? _self.topCategories : topCategories // ignore: cast_nullable_to_non_nullable
as List<AdminCategoryUnits>,purchaseFrequency: null == purchaseFrequency ? _self.purchaseFrequency : purchaseFrequency // ignore: cast_nullable_to_non_nullable
as List<AdminCustomerFrequency>,netSettledMinor: null == netSettledMinor ? _self.netSettledMinor : netSettledMinor // ignore: cast_nullable_to_non_nullable
as int,inventoryValuationMinor: null == inventoryValuationMinor ? _self.inventoryValuationMinor : inventoryValuationMinor // ignore: cast_nullable_to_non_nullable
as int,paymentSplit: null == paymentSplit ? _self.paymentSplit : paymentSplit // ignore: cast_nullable_to_non_nullable
as AdminPaymentSplit,brandRevenue: null == brandRevenue ? _self.brandRevenue : brandRevenue // ignore: cast_nullable_to_non_nullable
as List<AdminBrandRevenue>,
  ));
}
/// Create a copy of AdminSalesReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminPaymentSplitCopyWith<$Res> get paymentSplit {
  
  return $AdminPaymentSplitCopyWith<$Res>(_self.paymentSplit, (value) {
    return _then(_self.copyWith(paymentSplit: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdminSalesReport].
extension AdminSalesReportPatterns on AdminSalesReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminSalesReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminSalesReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminSalesReport value)  $default,){
final _that = this;
switch (_that) {
case _AdminSalesReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminSalesReport value)?  $default,){
final _that = this;
switch (_that) {
case _AdminSalesReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime from,  DateTime to,  int totalOrders,  int completedOrders,  int cancelledOrders,  int totalSalesMinor,  int averageOrderValueMinor,  int lowStockProducts,  int outOfStockProducts,  List<AdminBestSeller> bestSellers,  List<AdminCategoryUnits> topCategories,  List<AdminCustomerFrequency> purchaseFrequency,  int netSettledMinor,  int inventoryValuationMinor,  AdminPaymentSplit paymentSplit,  List<AdminBrandRevenue> brandRevenue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminSalesReport() when $default != null:
return $default(_that.from,_that.to,_that.totalOrders,_that.completedOrders,_that.cancelledOrders,_that.totalSalesMinor,_that.averageOrderValueMinor,_that.lowStockProducts,_that.outOfStockProducts,_that.bestSellers,_that.topCategories,_that.purchaseFrequency,_that.netSettledMinor,_that.inventoryValuationMinor,_that.paymentSplit,_that.brandRevenue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime from,  DateTime to,  int totalOrders,  int completedOrders,  int cancelledOrders,  int totalSalesMinor,  int averageOrderValueMinor,  int lowStockProducts,  int outOfStockProducts,  List<AdminBestSeller> bestSellers,  List<AdminCategoryUnits> topCategories,  List<AdminCustomerFrequency> purchaseFrequency,  int netSettledMinor,  int inventoryValuationMinor,  AdminPaymentSplit paymentSplit,  List<AdminBrandRevenue> brandRevenue)  $default,) {final _that = this;
switch (_that) {
case _AdminSalesReport():
return $default(_that.from,_that.to,_that.totalOrders,_that.completedOrders,_that.cancelledOrders,_that.totalSalesMinor,_that.averageOrderValueMinor,_that.lowStockProducts,_that.outOfStockProducts,_that.bestSellers,_that.topCategories,_that.purchaseFrequency,_that.netSettledMinor,_that.inventoryValuationMinor,_that.paymentSplit,_that.brandRevenue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime from,  DateTime to,  int totalOrders,  int completedOrders,  int cancelledOrders,  int totalSalesMinor,  int averageOrderValueMinor,  int lowStockProducts,  int outOfStockProducts,  List<AdminBestSeller> bestSellers,  List<AdminCategoryUnits> topCategories,  List<AdminCustomerFrequency> purchaseFrequency,  int netSettledMinor,  int inventoryValuationMinor,  AdminPaymentSplit paymentSplit,  List<AdminBrandRevenue> brandRevenue)?  $default,) {final _that = this;
switch (_that) {
case _AdminSalesReport() when $default != null:
return $default(_that.from,_that.to,_that.totalOrders,_that.completedOrders,_that.cancelledOrders,_that.totalSalesMinor,_that.averageOrderValueMinor,_that.lowStockProducts,_that.outOfStockProducts,_that.bestSellers,_that.topCategories,_that.purchaseFrequency,_that.netSettledMinor,_that.inventoryValuationMinor,_that.paymentSplit,_that.brandRevenue);case _:
  return null;

}
}

}

/// @nodoc


class _AdminSalesReport implements AdminSalesReport {
  const _AdminSalesReport({required this.from, required this.to, required this.totalOrders, required this.completedOrders, required this.cancelledOrders, required this.totalSalesMinor, required this.averageOrderValueMinor, required this.lowStockProducts, required this.outOfStockProducts,  List<AdminBestSeller> bestSellers = const [],  List<AdminCategoryUnits> topCategories = const [],  List<AdminCustomerFrequency> purchaseFrequency = const [], this.netSettledMinor = 0, this.inventoryValuationMinor = 0, this.paymentSplit = const AdminPaymentSplit(),  List<AdminBrandRevenue> brandRevenue = const []}): _bestSellers = bestSellers,_topCategories = topCategories,_purchaseFrequency = purchaseFrequency,_brandRevenue = brandRevenue;
  

@override final  DateTime from;
@override final  DateTime to;
@override final  int totalOrders;
@override final  int completedOrders;
@override final  int cancelledOrders;
@override final  int totalSalesMinor;
@override final  int averageOrderValueMinor;
@override final  int lowStockProducts;
@override final  int outOfStockProducts;
 final  List<AdminBestSeller> _bestSellers;
@override@JsonKey() List<AdminBestSeller> get bestSellers {
  if (_bestSellers is EqualUnmodifiableListView) return _bestSellers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bestSellers);
}

 final  List<AdminCategoryUnits> _topCategories;
@override@JsonKey() List<AdminCategoryUnits> get topCategories {
  if (_topCategories is EqualUnmodifiableListView) return _topCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topCategories);
}

 final  List<AdminCustomerFrequency> _purchaseFrequency;
@override@JsonKey() List<AdminCustomerFrequency> get purchaseFrequency {
  if (_purchaseFrequency is EqualUnmodifiableListView) return _purchaseFrequency;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_purchaseFrequency);
}

@override@JsonKey() final  int netSettledMinor;
@override@JsonKey() final  int inventoryValuationMinor;
@override@JsonKey() final  AdminPaymentSplit paymentSplit;
 final  List<AdminBrandRevenue> _brandRevenue;
@override@JsonKey() List<AdminBrandRevenue> get brandRevenue {
  if (_brandRevenue is EqualUnmodifiableListView) return _brandRevenue;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_brandRevenue);
}


/// Create a copy of AdminSalesReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminSalesReportCopyWith<_AdminSalesReport> get copyWith => __$AdminSalesReportCopyWithImpl<_AdminSalesReport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminSalesReport&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.totalOrders, totalOrders) || other.totalOrders == totalOrders)&&(identical(other.completedOrders, completedOrders) || other.completedOrders == completedOrders)&&(identical(other.cancelledOrders, cancelledOrders) || other.cancelledOrders == cancelledOrders)&&(identical(other.totalSalesMinor, totalSalesMinor) || other.totalSalesMinor == totalSalesMinor)&&(identical(other.averageOrderValueMinor, averageOrderValueMinor) || other.averageOrderValueMinor == averageOrderValueMinor)&&(identical(other.lowStockProducts, lowStockProducts) || other.lowStockProducts == lowStockProducts)&&(identical(other.outOfStockProducts, outOfStockProducts) || other.outOfStockProducts == outOfStockProducts)&&const DeepCollectionEquality().equals(other._bestSellers, _bestSellers)&&const DeepCollectionEquality().equals(other._topCategories, _topCategories)&&const DeepCollectionEquality().equals(other._purchaseFrequency, _purchaseFrequency)&&(identical(other.netSettledMinor, netSettledMinor) || other.netSettledMinor == netSettledMinor)&&(identical(other.inventoryValuationMinor, inventoryValuationMinor) || other.inventoryValuationMinor == inventoryValuationMinor)&&(identical(other.paymentSplit, paymentSplit) || other.paymentSplit == paymentSplit)&&const DeepCollectionEquality().equals(other._brandRevenue, _brandRevenue));
}


@override
int get hashCode => Object.hash(runtimeType,from,to,totalOrders,completedOrders,cancelledOrders,totalSalesMinor,averageOrderValueMinor,lowStockProducts,outOfStockProducts,const DeepCollectionEquality().hash(_bestSellers),const DeepCollectionEquality().hash(_topCategories),const DeepCollectionEquality().hash(_purchaseFrequency),netSettledMinor,inventoryValuationMinor,paymentSplit,const DeepCollectionEquality().hash(_brandRevenue));

@override
String toString() {
  return 'AdminSalesReport(from: $from, to: $to, totalOrders: $totalOrders, completedOrders: $completedOrders, cancelledOrders: $cancelledOrders, totalSalesMinor: $totalSalesMinor, averageOrderValueMinor: $averageOrderValueMinor, lowStockProducts: $lowStockProducts, outOfStockProducts: $outOfStockProducts, bestSellers: $bestSellers, topCategories: $topCategories, purchaseFrequency: $purchaseFrequency, netSettledMinor: $netSettledMinor, inventoryValuationMinor: $inventoryValuationMinor, paymentSplit: $paymentSplit, brandRevenue: $brandRevenue)';
}


}

/// @nodoc
abstract mixin class _$AdminSalesReportCopyWith<$Res> implements $AdminSalesReportCopyWith<$Res> {
  factory _$AdminSalesReportCopyWith(_AdminSalesReport value, $Res Function(_AdminSalesReport) _then) = __$AdminSalesReportCopyWithImpl;
@override @useResult
$Res call({
 DateTime from, DateTime to, int totalOrders, int completedOrders, int cancelledOrders, int totalSalesMinor, int averageOrderValueMinor, int lowStockProducts, int outOfStockProducts, List<AdminBestSeller> bestSellers, List<AdminCategoryUnits> topCategories, List<AdminCustomerFrequency> purchaseFrequency, int netSettledMinor, int inventoryValuationMinor, AdminPaymentSplit paymentSplit, List<AdminBrandRevenue> brandRevenue
});


@override $AdminPaymentSplitCopyWith<$Res> get paymentSplit;

}
/// @nodoc
class __$AdminSalesReportCopyWithImpl<$Res>
    implements _$AdminSalesReportCopyWith<$Res> {
  __$AdminSalesReportCopyWithImpl(this._self, this._then);

  final _AdminSalesReport _self;
  final $Res Function(_AdminSalesReport) _then;

/// Create a copy of AdminSalesReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,Object? totalOrders = null,Object? completedOrders = null,Object? cancelledOrders = null,Object? totalSalesMinor = null,Object? averageOrderValueMinor = null,Object? lowStockProducts = null,Object? outOfStockProducts = null,Object? bestSellers = null,Object? topCategories = null,Object? purchaseFrequency = null,Object? netSettledMinor = null,Object? inventoryValuationMinor = null,Object? paymentSplit = null,Object? brandRevenue = null,}) {
  return _then(_AdminSalesReport(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime,totalOrders: null == totalOrders ? _self.totalOrders : totalOrders // ignore: cast_nullable_to_non_nullable
as int,completedOrders: null == completedOrders ? _self.completedOrders : completedOrders // ignore: cast_nullable_to_non_nullable
as int,cancelledOrders: null == cancelledOrders ? _self.cancelledOrders : cancelledOrders // ignore: cast_nullable_to_non_nullable
as int,totalSalesMinor: null == totalSalesMinor ? _self.totalSalesMinor : totalSalesMinor // ignore: cast_nullable_to_non_nullable
as int,averageOrderValueMinor: null == averageOrderValueMinor ? _self.averageOrderValueMinor : averageOrderValueMinor // ignore: cast_nullable_to_non_nullable
as int,lowStockProducts: null == lowStockProducts ? _self.lowStockProducts : lowStockProducts // ignore: cast_nullable_to_non_nullable
as int,outOfStockProducts: null == outOfStockProducts ? _self.outOfStockProducts : outOfStockProducts // ignore: cast_nullable_to_non_nullable
as int,bestSellers: null == bestSellers ? _self._bestSellers : bestSellers // ignore: cast_nullable_to_non_nullable
as List<AdminBestSeller>,topCategories: null == topCategories ? _self._topCategories : topCategories // ignore: cast_nullable_to_non_nullable
as List<AdminCategoryUnits>,purchaseFrequency: null == purchaseFrequency ? _self._purchaseFrequency : purchaseFrequency // ignore: cast_nullable_to_non_nullable
as List<AdminCustomerFrequency>,netSettledMinor: null == netSettledMinor ? _self.netSettledMinor : netSettledMinor // ignore: cast_nullable_to_non_nullable
as int,inventoryValuationMinor: null == inventoryValuationMinor ? _self.inventoryValuationMinor : inventoryValuationMinor // ignore: cast_nullable_to_non_nullable
as int,paymentSplit: null == paymentSplit ? _self.paymentSplit : paymentSplit // ignore: cast_nullable_to_non_nullable
as AdminPaymentSplit,brandRevenue: null == brandRevenue ? _self._brandRevenue : brandRevenue // ignore: cast_nullable_to_non_nullable
as List<AdminBrandRevenue>,
  ));
}

/// Create a copy of AdminSalesReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminPaymentSplitCopyWith<$Res> get paymentSplit {
  
  return $AdminPaymentSplitCopyWith<$Res>(_self.paymentSplit, (value) {
    return _then(_self.copyWith(paymentSplit: value));
  });
}
}

/// @nodoc
mixin _$AdminPaymentSplit {

 int get qrCount; int get codCount; int get qrAmountMinor; int get codAmountMinor;
/// Create a copy of AdminPaymentSplit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminPaymentSplitCopyWith<AdminPaymentSplit> get copyWith => _$AdminPaymentSplitCopyWithImpl<AdminPaymentSplit>(this as AdminPaymentSplit, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminPaymentSplit&&(identical(other.qrCount, qrCount) || other.qrCount == qrCount)&&(identical(other.codCount, codCount) || other.codCount == codCount)&&(identical(other.qrAmountMinor, qrAmountMinor) || other.qrAmountMinor == qrAmountMinor)&&(identical(other.codAmountMinor, codAmountMinor) || other.codAmountMinor == codAmountMinor));
}


@override
int get hashCode => Object.hash(runtimeType,qrCount,codCount,qrAmountMinor,codAmountMinor);

@override
String toString() {
  return 'AdminPaymentSplit(qrCount: $qrCount, codCount: $codCount, qrAmountMinor: $qrAmountMinor, codAmountMinor: $codAmountMinor)';
}


}

/// @nodoc
abstract mixin class $AdminPaymentSplitCopyWith<$Res>  {
  factory $AdminPaymentSplitCopyWith(AdminPaymentSplit value, $Res Function(AdminPaymentSplit) _then) = _$AdminPaymentSplitCopyWithImpl;
@useResult
$Res call({
 int qrCount, int codCount, int qrAmountMinor, int codAmountMinor
});




}
/// @nodoc
class _$AdminPaymentSplitCopyWithImpl<$Res>
    implements $AdminPaymentSplitCopyWith<$Res> {
  _$AdminPaymentSplitCopyWithImpl(this._self, this._then);

  final AdminPaymentSplit _self;
  final $Res Function(AdminPaymentSplit) _then;

/// Create a copy of AdminPaymentSplit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? qrCount = null,Object? codCount = null,Object? qrAmountMinor = null,Object? codAmountMinor = null,}) {
  return _then(AdminPaymentSplit(
qrCount: null == qrCount ? _self.qrCount : qrCount // ignore: cast_nullable_to_non_nullable
as int,codCount: null == codCount ? _self.codCount : codCount // ignore: cast_nullable_to_non_nullable
as int,qrAmountMinor: null == qrAmountMinor ? _self.qrAmountMinor : qrAmountMinor // ignore: cast_nullable_to_non_nullable
as int,codAmountMinor: null == codAmountMinor ? _self.codAmountMinor : codAmountMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminPaymentSplit].
extension AdminPaymentSplitPatterns on AdminPaymentSplit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminPaymentSplit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminPaymentSplit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminPaymentSplit value)  $default,){
final _that = this;
switch (_that) {
case _AdminPaymentSplit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminPaymentSplit value)?  $default,){
final _that = this;
switch (_that) {
case _AdminPaymentSplit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int qrCount,  int codCount,  int qrAmountMinor,  int codAmountMinor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminPaymentSplit() when $default != null:
return $default(_that.qrCount,_that.codCount,_that.qrAmountMinor,_that.codAmountMinor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int qrCount,  int codCount,  int qrAmountMinor,  int codAmountMinor)  $default,) {final _that = this;
switch (_that) {
case _AdminPaymentSplit():
return $default(_that.qrCount,_that.codCount,_that.qrAmountMinor,_that.codAmountMinor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int qrCount,  int codCount,  int qrAmountMinor,  int codAmountMinor)?  $default,) {final _that = this;
switch (_that) {
case _AdminPaymentSplit() when $default != null:
return $default(_that.qrCount,_that.codCount,_that.qrAmountMinor,_that.codAmountMinor);case _:
  return null;

}
}

}

/// @nodoc


class _AdminPaymentSplit implements AdminPaymentSplit {
  const _AdminPaymentSplit({this.qrCount = 0, this.codCount = 0, this.qrAmountMinor = 0, this.codAmountMinor = 0});
  

@override@JsonKey() final  int qrCount;
@override@JsonKey() final  int codCount;
@override@JsonKey() final  int qrAmountMinor;
@override@JsonKey() final  int codAmountMinor;

/// Create a copy of AdminPaymentSplit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminPaymentSplitCopyWith<_AdminPaymentSplit> get copyWith => __$AdminPaymentSplitCopyWithImpl<_AdminPaymentSplit>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminPaymentSplit&&(identical(other.qrCount, qrCount) || other.qrCount == qrCount)&&(identical(other.codCount, codCount) || other.codCount == codCount)&&(identical(other.qrAmountMinor, qrAmountMinor) || other.qrAmountMinor == qrAmountMinor)&&(identical(other.codAmountMinor, codAmountMinor) || other.codAmountMinor == codAmountMinor));
}


@override
int get hashCode => Object.hash(runtimeType,qrCount,codCount,qrAmountMinor,codAmountMinor);

@override
String toString() {
  return 'AdminPaymentSplit(qrCount: $qrCount, codCount: $codCount, qrAmountMinor: $qrAmountMinor, codAmountMinor: $codAmountMinor)';
}


}

/// @nodoc
abstract mixin class _$AdminPaymentSplitCopyWith<$Res> implements $AdminPaymentSplitCopyWith<$Res> {
  factory _$AdminPaymentSplitCopyWith(_AdminPaymentSplit value, $Res Function(_AdminPaymentSplit) _then) = __$AdminPaymentSplitCopyWithImpl;
@override @useResult
$Res call({
 int qrCount, int codCount, int qrAmountMinor, int codAmountMinor
});




}
/// @nodoc
class __$AdminPaymentSplitCopyWithImpl<$Res>
    implements _$AdminPaymentSplitCopyWith<$Res> {
  __$AdminPaymentSplitCopyWithImpl(this._self, this._then);

  final _AdminPaymentSplit _self;
  final $Res Function(_AdminPaymentSplit) _then;

/// Create a copy of AdminPaymentSplit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? qrCount = null,Object? codCount = null,Object? qrAmountMinor = null,Object? codAmountMinor = null,}) {
  return _then(_AdminPaymentSplit(
qrCount: null == qrCount ? _self.qrCount : qrCount // ignore: cast_nullable_to_non_nullable
as int,codCount: null == codCount ? _self.codCount : codCount // ignore: cast_nullable_to_non_nullable
as int,qrAmountMinor: null == qrAmountMinor ? _self.qrAmountMinor : qrAmountMinor // ignore: cast_nullable_to_non_nullable
as int,codAmountMinor: null == codAmountMinor ? _self.codAmountMinor : codAmountMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$AdminBrandRevenue {

 String get name; int get revenueMinor; String? get imageUrl;
/// Create a copy of AdminBrandRevenue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminBrandRevenueCopyWith<AdminBrandRevenue> get copyWith => _$AdminBrandRevenueCopyWithImpl<AdminBrandRevenue>(this as AdminBrandRevenue, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminBrandRevenue&&(identical(other.name, name) || other.name == name)&&(identical(other.revenueMinor, revenueMinor) || other.revenueMinor == revenueMinor)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,name,revenueMinor,imageUrl);

@override
String toString() {
  return 'AdminBrandRevenue(name: $name, revenueMinor: $revenueMinor, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $AdminBrandRevenueCopyWith<$Res>  {
  factory $AdminBrandRevenueCopyWith(AdminBrandRevenue value, $Res Function(AdminBrandRevenue) _then) = _$AdminBrandRevenueCopyWithImpl;
@useResult
$Res call({
 String name, int revenueMinor, String? imageUrl
});




}
/// @nodoc
class _$AdminBrandRevenueCopyWithImpl<$Res>
    implements $AdminBrandRevenueCopyWith<$Res> {
  _$AdminBrandRevenueCopyWithImpl(this._self, this._then);

  final AdminBrandRevenue _self;
  final $Res Function(AdminBrandRevenue) _then;

/// Create a copy of AdminBrandRevenue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? revenueMinor = null,Object? imageUrl = freezed,}) {
  return _then(AdminBrandRevenue(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,revenueMinor: null == revenueMinor ? _self.revenueMinor : revenueMinor // ignore: cast_nullable_to_non_nullable
as int,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminBrandRevenue].
extension AdminBrandRevenuePatterns on AdminBrandRevenue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminBrandRevenue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminBrandRevenue() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminBrandRevenue value)  $default,){
final _that = this;
switch (_that) {
case _AdminBrandRevenue():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminBrandRevenue value)?  $default,){
final _that = this;
switch (_that) {
case _AdminBrandRevenue() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int revenueMinor,  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminBrandRevenue() when $default != null:
return $default(_that.name,_that.revenueMinor,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int revenueMinor,  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _AdminBrandRevenue():
return $default(_that.name,_that.revenueMinor,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int revenueMinor,  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _AdminBrandRevenue() when $default != null:
return $default(_that.name,_that.revenueMinor,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc


class _AdminBrandRevenue implements AdminBrandRevenue {
  const _AdminBrandRevenue({required this.name, required this.revenueMinor, this.imageUrl});
  

@override final  String name;
@override final  int revenueMinor;
@override final  String? imageUrl;

/// Create a copy of AdminBrandRevenue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminBrandRevenueCopyWith<_AdminBrandRevenue> get copyWith => __$AdminBrandRevenueCopyWithImpl<_AdminBrandRevenue>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminBrandRevenue&&(identical(other.name, name) || other.name == name)&&(identical(other.revenueMinor, revenueMinor) || other.revenueMinor == revenueMinor)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,name,revenueMinor,imageUrl);

@override
String toString() {
  return 'AdminBrandRevenue(name: $name, revenueMinor: $revenueMinor, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$AdminBrandRevenueCopyWith<$Res> implements $AdminBrandRevenueCopyWith<$Res> {
  factory _$AdminBrandRevenueCopyWith(_AdminBrandRevenue value, $Res Function(_AdminBrandRevenue) _then) = __$AdminBrandRevenueCopyWithImpl;
@override @useResult
$Res call({
 String name, int revenueMinor, String? imageUrl
});




}
/// @nodoc
class __$AdminBrandRevenueCopyWithImpl<$Res>
    implements _$AdminBrandRevenueCopyWith<$Res> {
  __$AdminBrandRevenueCopyWithImpl(this._self, this._then);

  final _AdminBrandRevenue _self;
  final $Res Function(_AdminBrandRevenue) _then;

/// Create a copy of AdminBrandRevenue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? revenueMinor = null,Object? imageUrl = freezed,}) {
  return _then(_AdminBrandRevenue(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,revenueMinor: null == revenueMinor ? _self.revenueMinor : revenueMinor // ignore: cast_nullable_to_non_nullable
as int,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$AdminCategoryUnits {

 String get name; int get units; String? get imageUrl;
/// Create a copy of AdminCategoryUnits
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminCategoryUnitsCopyWith<AdminCategoryUnits> get copyWith => _$AdminCategoryUnitsCopyWithImpl<AdminCategoryUnits>(this as AdminCategoryUnits, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminCategoryUnits&&(identical(other.name, name) || other.name == name)&&(identical(other.units, units) || other.units == units)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,name,units,imageUrl);

@override
String toString() {
  return 'AdminCategoryUnits(name: $name, units: $units, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $AdminCategoryUnitsCopyWith<$Res>  {
  factory $AdminCategoryUnitsCopyWith(AdminCategoryUnits value, $Res Function(AdminCategoryUnits) _then) = _$AdminCategoryUnitsCopyWithImpl;
@useResult
$Res call({
 String name, int units, String? imageUrl
});




}
/// @nodoc
class _$AdminCategoryUnitsCopyWithImpl<$Res>
    implements $AdminCategoryUnitsCopyWith<$Res> {
  _$AdminCategoryUnitsCopyWithImpl(this._self, this._then);

  final AdminCategoryUnits _self;
  final $Res Function(AdminCategoryUnits) _then;

/// Create a copy of AdminCategoryUnits
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? units = null,Object? imageUrl = freezed,}) {
  return _then(AdminCategoryUnits(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as int,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminCategoryUnits].
extension AdminCategoryUnitsPatterns on AdminCategoryUnits {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminCategoryUnits value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminCategoryUnits() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminCategoryUnits value)  $default,){
final _that = this;
switch (_that) {
case _AdminCategoryUnits():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminCategoryUnits value)?  $default,){
final _that = this;
switch (_that) {
case _AdminCategoryUnits() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int units,  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminCategoryUnits() when $default != null:
return $default(_that.name,_that.units,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int units,  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _AdminCategoryUnits():
return $default(_that.name,_that.units,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int units,  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _AdminCategoryUnits() when $default != null:
return $default(_that.name,_that.units,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc


class _AdminCategoryUnits implements AdminCategoryUnits {
  const _AdminCategoryUnits({required this.name, required this.units, this.imageUrl});
  

@override final  String name;
@override final  int units;
@override final  String? imageUrl;

/// Create a copy of AdminCategoryUnits
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminCategoryUnitsCopyWith<_AdminCategoryUnits> get copyWith => __$AdminCategoryUnitsCopyWithImpl<_AdminCategoryUnits>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminCategoryUnits&&(identical(other.name, name) || other.name == name)&&(identical(other.units, units) || other.units == units)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,name,units,imageUrl);

@override
String toString() {
  return 'AdminCategoryUnits(name: $name, units: $units, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$AdminCategoryUnitsCopyWith<$Res> implements $AdminCategoryUnitsCopyWith<$Res> {
  factory _$AdminCategoryUnitsCopyWith(_AdminCategoryUnits value, $Res Function(_AdminCategoryUnits) _then) = __$AdminCategoryUnitsCopyWithImpl;
@override @useResult
$Res call({
 String name, int units, String? imageUrl
});




}
/// @nodoc
class __$AdminCategoryUnitsCopyWithImpl<$Res>
    implements _$AdminCategoryUnitsCopyWith<$Res> {
  __$AdminCategoryUnitsCopyWithImpl(this._self, this._then);

  final _AdminCategoryUnits _self;
  final $Res Function(_AdminCategoryUnits) _then;

/// Create a copy of AdminCategoryUnits
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? units = null,Object? imageUrl = freezed,}) {
  return _then(_AdminCategoryUnits(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as int,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$AdminCustomerFrequency {

 String get name; int get orders; String? get imageUrl;
/// Create a copy of AdminCustomerFrequency
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminCustomerFrequencyCopyWith<AdminCustomerFrequency> get copyWith => _$AdminCustomerFrequencyCopyWithImpl<AdminCustomerFrequency>(this as AdminCustomerFrequency, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminCustomerFrequency&&(identical(other.name, name) || other.name == name)&&(identical(other.orders, orders) || other.orders == orders)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,name,orders,imageUrl);

@override
String toString() {
  return 'AdminCustomerFrequency(name: $name, orders: $orders, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $AdminCustomerFrequencyCopyWith<$Res>  {
  factory $AdminCustomerFrequencyCopyWith(AdminCustomerFrequency value, $Res Function(AdminCustomerFrequency) _then) = _$AdminCustomerFrequencyCopyWithImpl;
@useResult
$Res call({
 String name, int orders, String? imageUrl
});




}
/// @nodoc
class _$AdminCustomerFrequencyCopyWithImpl<$Res>
    implements $AdminCustomerFrequencyCopyWith<$Res> {
  _$AdminCustomerFrequencyCopyWithImpl(this._self, this._then);

  final AdminCustomerFrequency _self;
  final $Res Function(AdminCustomerFrequency) _then;

/// Create a copy of AdminCustomerFrequency
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? orders = null,Object? imageUrl = freezed,}) {
  return _then(AdminCustomerFrequency(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,orders: null == orders ? _self.orders : orders // ignore: cast_nullable_to_non_nullable
as int,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminCustomerFrequency].
extension AdminCustomerFrequencyPatterns on AdminCustomerFrequency {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminCustomerFrequency value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminCustomerFrequency() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminCustomerFrequency value)  $default,){
final _that = this;
switch (_that) {
case _AdminCustomerFrequency():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminCustomerFrequency value)?  $default,){
final _that = this;
switch (_that) {
case _AdminCustomerFrequency() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int orders,  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminCustomerFrequency() when $default != null:
return $default(_that.name,_that.orders,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int orders,  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _AdminCustomerFrequency():
return $default(_that.name,_that.orders,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int orders,  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _AdminCustomerFrequency() when $default != null:
return $default(_that.name,_that.orders,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc


class _AdminCustomerFrequency implements AdminCustomerFrequency {
  const _AdminCustomerFrequency({required this.name, required this.orders, this.imageUrl});
  

@override final  String name;
@override final  int orders;
@override final  String? imageUrl;

/// Create a copy of AdminCustomerFrequency
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminCustomerFrequencyCopyWith<_AdminCustomerFrequency> get copyWith => __$AdminCustomerFrequencyCopyWithImpl<_AdminCustomerFrequency>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminCustomerFrequency&&(identical(other.name, name) || other.name == name)&&(identical(other.orders, orders) || other.orders == orders)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,name,orders,imageUrl);

@override
String toString() {
  return 'AdminCustomerFrequency(name: $name, orders: $orders, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$AdminCustomerFrequencyCopyWith<$Res> implements $AdminCustomerFrequencyCopyWith<$Res> {
  factory _$AdminCustomerFrequencyCopyWith(_AdminCustomerFrequency value, $Res Function(_AdminCustomerFrequency) _then) = __$AdminCustomerFrequencyCopyWithImpl;
@override @useResult
$Res call({
 String name, int orders, String? imageUrl
});




}
/// @nodoc
class __$AdminCustomerFrequencyCopyWithImpl<$Res>
    implements _$AdminCustomerFrequencyCopyWith<$Res> {
  __$AdminCustomerFrequencyCopyWithImpl(this._self, this._then);

  final _AdminCustomerFrequency _self;
  final $Res Function(_AdminCustomerFrequency) _then;

/// Create a copy of AdminCustomerFrequency
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? orders = null,Object? imageUrl = freezed,}) {
  return _then(_AdminCustomerFrequency(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,orders: null == orders ? _self.orders : orders // ignore: cast_nullable_to_non_nullable
as int,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$AdminBestSeller {

 String get name; int get units; String? get productId; String? get imageUrl;
/// Create a copy of AdminBestSeller
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminBestSellerCopyWith<AdminBestSeller> get copyWith => _$AdminBestSellerCopyWithImpl<AdminBestSeller>(this as AdminBestSeller, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminBestSeller&&(identical(other.name, name) || other.name == name)&&(identical(other.units, units) || other.units == units)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,name,units,productId,imageUrl);

@override
String toString() {
  return 'AdminBestSeller(name: $name, units: $units, productId: $productId, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $AdminBestSellerCopyWith<$Res>  {
  factory $AdminBestSellerCopyWith(AdminBestSeller value, $Res Function(AdminBestSeller) _then) = _$AdminBestSellerCopyWithImpl;
@useResult
$Res call({
 String name, int units, String? productId, String? imageUrl
});




}
/// @nodoc
class _$AdminBestSellerCopyWithImpl<$Res>
    implements $AdminBestSellerCopyWith<$Res> {
  _$AdminBestSellerCopyWithImpl(this._self, this._then);

  final AdminBestSeller _self;
  final $Res Function(AdminBestSeller) _then;

/// Create a copy of AdminBestSeller
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? units = null,Object? productId = freezed,Object? imageUrl = freezed,}) {
  return _then(AdminBestSeller(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as int,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminBestSeller].
extension AdminBestSellerPatterns on AdminBestSeller {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminBestSeller value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminBestSeller() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminBestSeller value)  $default,){
final _that = this;
switch (_that) {
case _AdminBestSeller():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminBestSeller value)?  $default,){
final _that = this;
switch (_that) {
case _AdminBestSeller() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int units,  String? productId,  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminBestSeller() when $default != null:
return $default(_that.name,_that.units,_that.productId,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int units,  String? productId,  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _AdminBestSeller():
return $default(_that.name,_that.units,_that.productId,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int units,  String? productId,  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _AdminBestSeller() when $default != null:
return $default(_that.name,_that.units,_that.productId,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc


class _AdminBestSeller implements AdminBestSeller {
  const _AdminBestSeller({required this.name, required this.units, this.productId, this.imageUrl});
  

@override final  String name;
@override final  int units;
@override final  String? productId;
@override final  String? imageUrl;

/// Create a copy of AdminBestSeller
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminBestSellerCopyWith<_AdminBestSeller> get copyWith => __$AdminBestSellerCopyWithImpl<_AdminBestSeller>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminBestSeller&&(identical(other.name, name) || other.name == name)&&(identical(other.units, units) || other.units == units)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,name,units,productId,imageUrl);

@override
String toString() {
  return 'AdminBestSeller(name: $name, units: $units, productId: $productId, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$AdminBestSellerCopyWith<$Res> implements $AdminBestSellerCopyWith<$Res> {
  factory _$AdminBestSellerCopyWith(_AdminBestSeller value, $Res Function(_AdminBestSeller) _then) = __$AdminBestSellerCopyWithImpl;
@override @useResult
$Res call({
 String name, int units, String? productId, String? imageUrl
});




}
/// @nodoc
class __$AdminBestSellerCopyWithImpl<$Res>
    implements _$AdminBestSellerCopyWith<$Res> {
  __$AdminBestSellerCopyWithImpl(this._self, this._then);

  final _AdminBestSeller _self;
  final $Res Function(_AdminBestSeller) _then;

/// Create a copy of AdminBestSeller
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? units = null,Object? productId = freezed,Object? imageUrl = freezed,}) {
  return _then(_AdminBestSeller(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as int,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$AdminTrendPoint {

 DateTime get day; int get orders; int get salesMinor;
/// Create a copy of AdminTrendPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminTrendPointCopyWith<AdminTrendPoint> get copyWith => _$AdminTrendPointCopyWithImpl<AdminTrendPoint>(this as AdminTrendPoint, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminTrendPoint&&(identical(other.day, day) || other.day == day)&&(identical(other.orders, orders) || other.orders == orders)&&(identical(other.salesMinor, salesMinor) || other.salesMinor == salesMinor));
}


@override
int get hashCode => Object.hash(runtimeType,day,orders,salesMinor);

@override
String toString() {
  return 'AdminTrendPoint(day: $day, orders: $orders, salesMinor: $salesMinor)';
}


}

/// @nodoc
abstract mixin class $AdminTrendPointCopyWith<$Res>  {
  factory $AdminTrendPointCopyWith(AdminTrendPoint value, $Res Function(AdminTrendPoint) _then) = _$AdminTrendPointCopyWithImpl;
@useResult
$Res call({
 DateTime day, int orders, int salesMinor
});




}
/// @nodoc
class _$AdminTrendPointCopyWithImpl<$Res>
    implements $AdminTrendPointCopyWith<$Res> {
  _$AdminTrendPointCopyWithImpl(this._self, this._then);

  final AdminTrendPoint _self;
  final $Res Function(AdminTrendPoint) _then;

/// Create a copy of AdminTrendPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? orders = null,Object? salesMinor = null,}) {
  return _then(AdminTrendPoint(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime,orders: null == orders ? _self.orders : orders // ignore: cast_nullable_to_non_nullable
as int,salesMinor: null == salesMinor ? _self.salesMinor : salesMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminTrendPoint].
extension AdminTrendPointPatterns on AdminTrendPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminTrendPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminTrendPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminTrendPoint value)  $default,){
final _that = this;
switch (_that) {
case _AdminTrendPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminTrendPoint value)?  $default,){
final _that = this;
switch (_that) {
case _AdminTrendPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime day,  int orders,  int salesMinor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminTrendPoint() when $default != null:
return $default(_that.day,_that.orders,_that.salesMinor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime day,  int orders,  int salesMinor)  $default,) {final _that = this;
switch (_that) {
case _AdminTrendPoint():
return $default(_that.day,_that.orders,_that.salesMinor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime day,  int orders,  int salesMinor)?  $default,) {final _that = this;
switch (_that) {
case _AdminTrendPoint() when $default != null:
return $default(_that.day,_that.orders,_that.salesMinor);case _:
  return null;

}
}

}

/// @nodoc


class _AdminTrendPoint implements AdminTrendPoint {
  const _AdminTrendPoint({required this.day, required this.orders, required this.salesMinor});
  

@override final  DateTime day;
@override final  int orders;
@override final  int salesMinor;

/// Create a copy of AdminTrendPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminTrendPointCopyWith<_AdminTrendPoint> get copyWith => __$AdminTrendPointCopyWithImpl<_AdminTrendPoint>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminTrendPoint&&(identical(other.day, day) || other.day == day)&&(identical(other.orders, orders) || other.orders == orders)&&(identical(other.salesMinor, salesMinor) || other.salesMinor == salesMinor));
}


@override
int get hashCode => Object.hash(runtimeType,day,orders,salesMinor);

@override
String toString() {
  return 'AdminTrendPoint(day: $day, orders: $orders, salesMinor: $salesMinor)';
}


}

/// @nodoc
abstract mixin class _$AdminTrendPointCopyWith<$Res> implements $AdminTrendPointCopyWith<$Res> {
  factory _$AdminTrendPointCopyWith(_AdminTrendPoint value, $Res Function(_AdminTrendPoint) _then) = __$AdminTrendPointCopyWithImpl;
@override @useResult
$Res call({
 DateTime day, int orders, int salesMinor
});




}
/// @nodoc
class __$AdminTrendPointCopyWithImpl<$Res>
    implements _$AdminTrendPointCopyWith<$Res> {
  __$AdminTrendPointCopyWithImpl(this._self, this._then);

  final _AdminTrendPoint _self;
  final $Res Function(_AdminTrendPoint) _then;

/// Create a copy of AdminTrendPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? orders = null,Object? salesMinor = null,}) {
  return _then(_AdminTrendPoint(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime,orders: null == orders ? _self.orders : orders // ignore: cast_nullable_to_non_nullable
as int,salesMinor: null == salesMinor ? _self.salesMinor : salesMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$PlatformSettings {

 int get deliveryFeeMinor; int get platformCommissionPercent; String get paymentAccount;
/// Create a copy of PlatformSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlatformSettingsCopyWith<PlatformSettings> get copyWith => _$PlatformSettingsCopyWithImpl<PlatformSettings>(this as PlatformSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlatformSettings&&(identical(other.deliveryFeeMinor, deliveryFeeMinor) || other.deliveryFeeMinor == deliveryFeeMinor)&&(identical(other.platformCommissionPercent, platformCommissionPercent) || other.platformCommissionPercent == platformCommissionPercent)&&(identical(other.paymentAccount, paymentAccount) || other.paymentAccount == paymentAccount));
}


@override
int get hashCode => Object.hash(runtimeType,deliveryFeeMinor,platformCommissionPercent,paymentAccount);

@override
String toString() {
  return 'PlatformSettings(deliveryFeeMinor: $deliveryFeeMinor, platformCommissionPercent: $platformCommissionPercent, paymentAccount: $paymentAccount)';
}


}

/// @nodoc
abstract mixin class $PlatformSettingsCopyWith<$Res>  {
  factory $PlatformSettingsCopyWith(PlatformSettings value, $Res Function(PlatformSettings) _then) = _$PlatformSettingsCopyWithImpl;
@useResult
$Res call({
 int deliveryFeeMinor, int platformCommissionPercent, String paymentAccount
});




}
/// @nodoc
class _$PlatformSettingsCopyWithImpl<$Res>
    implements $PlatformSettingsCopyWith<$Res> {
  _$PlatformSettingsCopyWithImpl(this._self, this._then);

  final PlatformSettings _self;
  final $Res Function(PlatformSettings) _then;

/// Create a copy of PlatformSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deliveryFeeMinor = null,Object? platformCommissionPercent = null,Object? paymentAccount = null,}) {
  return _then(PlatformSettings(
deliveryFeeMinor: null == deliveryFeeMinor ? _self.deliveryFeeMinor : deliveryFeeMinor // ignore: cast_nullable_to_non_nullable
as int,platformCommissionPercent: null == platformCommissionPercent ? _self.platformCommissionPercent : platformCommissionPercent // ignore: cast_nullable_to_non_nullable
as int,paymentAccount: null == paymentAccount ? _self.paymentAccount : paymentAccount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PlatformSettings].
extension PlatformSettingsPatterns on PlatformSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlatformSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlatformSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlatformSettings value)  $default,){
final _that = this;
switch (_that) {
case _PlatformSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlatformSettings value)?  $default,){
final _that = this;
switch (_that) {
case _PlatformSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int deliveryFeeMinor,  int platformCommissionPercent,  String paymentAccount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlatformSettings() when $default != null:
return $default(_that.deliveryFeeMinor,_that.platformCommissionPercent,_that.paymentAccount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int deliveryFeeMinor,  int platformCommissionPercent,  String paymentAccount)  $default,) {final _that = this;
switch (_that) {
case _PlatformSettings():
return $default(_that.deliveryFeeMinor,_that.platformCommissionPercent,_that.paymentAccount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int deliveryFeeMinor,  int platformCommissionPercent,  String paymentAccount)?  $default,) {final _that = this;
switch (_that) {
case _PlatformSettings() when $default != null:
return $default(_that.deliveryFeeMinor,_that.platformCommissionPercent,_that.paymentAccount);case _:
  return null;

}
}

}

/// @nodoc


class _PlatformSettings implements PlatformSettings {
  const _PlatformSettings({required this.deliveryFeeMinor, required this.platformCommissionPercent, required this.paymentAccount});
  

@override final  int deliveryFeeMinor;
@override final  int platformCommissionPercent;
@override final  String paymentAccount;

/// Create a copy of PlatformSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlatformSettingsCopyWith<_PlatformSettings> get copyWith => __$PlatformSettingsCopyWithImpl<_PlatformSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlatformSettings&&(identical(other.deliveryFeeMinor, deliveryFeeMinor) || other.deliveryFeeMinor == deliveryFeeMinor)&&(identical(other.platformCommissionPercent, platformCommissionPercent) || other.platformCommissionPercent == platformCommissionPercent)&&(identical(other.paymentAccount, paymentAccount) || other.paymentAccount == paymentAccount));
}


@override
int get hashCode => Object.hash(runtimeType,deliveryFeeMinor,platformCommissionPercent,paymentAccount);

@override
String toString() {
  return 'PlatformSettings(deliveryFeeMinor: $deliveryFeeMinor, platformCommissionPercent: $platformCommissionPercent, paymentAccount: $paymentAccount)';
}


}

/// @nodoc
abstract mixin class _$PlatformSettingsCopyWith<$Res> implements $PlatformSettingsCopyWith<$Res> {
  factory _$PlatformSettingsCopyWith(_PlatformSettings value, $Res Function(_PlatformSettings) _then) = __$PlatformSettingsCopyWithImpl;
@override @useResult
$Res call({
 int deliveryFeeMinor, int platformCommissionPercent, String paymentAccount
});




}
/// @nodoc
class __$PlatformSettingsCopyWithImpl<$Res>
    implements _$PlatformSettingsCopyWith<$Res> {
  __$PlatformSettingsCopyWithImpl(this._self, this._then);

  final _PlatformSettings _self;
  final $Res Function(_PlatformSettings) _then;

/// Create a copy of PlatformSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deliveryFeeMinor = null,Object? platformCommissionPercent = null,Object? paymentAccount = null,}) {
  return _then(_PlatformSettings(
deliveryFeeMinor: null == deliveryFeeMinor ? _self.deliveryFeeMinor : deliveryFeeMinor // ignore: cast_nullable_to_non_nullable
as int,platformCommissionPercent: null == platformCommissionPercent ? _self.platformCommissionPercent : platformCommissionPercent // ignore: cast_nullable_to_non_nullable
as int,paymentAccount: null == paymentAccount ? _self.paymentAccount : paymentAccount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
