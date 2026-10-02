// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Product {

 String get id; String get businessId; String get categoryId; String get name; String get description; int get basePriceMinor;/// Cheapest selectable price — min over variant effective prices, base
/// price when the product has none. What grids/cards display.
 int get fromPriceMinor; ProductStatus get status; List<String> get imageUrls;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.basePriceMinor, basePriceMinor) || other.basePriceMinor == basePriceMinor)&&(identical(other.fromPriceMinor, fromPriceMinor) || other.fromPriceMinor == fromPriceMinor)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.imageUrls, imageUrls));
}


@override
int get hashCode => Object.hash(runtimeType,id,businessId,categoryId,name,description,basePriceMinor,fromPriceMinor,status,const DeepCollectionEquality().hash(imageUrls));

@override
String toString() {
  return 'Product(id: $id, businessId: $businessId, categoryId: $categoryId, name: $name, description: $description, basePriceMinor: $basePriceMinor, fromPriceMinor: $fromPriceMinor, status: $status, imageUrls: $imageUrls)';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 String id, String businessId, String categoryId, String name, String description, int basePriceMinor, int fromPriceMinor, ProductStatus status, List<String> imageUrls
});




}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? categoryId = null,Object? name = null,Object? description = null,Object? basePriceMinor = null,Object? fromPriceMinor = null,Object? status = null,Object? imageUrls = null,}) {
  return _then(Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,basePriceMinor: null == basePriceMinor ? _self.basePriceMinor : basePriceMinor // ignore: cast_nullable_to_non_nullable
as int,fromPriceMinor: null == fromPriceMinor ? _self.fromPriceMinor : fromPriceMinor // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProductStatus,imageUrls: null == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String businessId,  String categoryId,  String name,  String description,  int basePriceMinor,  int fromPriceMinor,  ProductStatus status,  List<String> imageUrls)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.businessId,_that.categoryId,_that.name,_that.description,_that.basePriceMinor,_that.fromPriceMinor,_that.status,_that.imageUrls);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String businessId,  String categoryId,  String name,  String description,  int basePriceMinor,  int fromPriceMinor,  ProductStatus status,  List<String> imageUrls)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.businessId,_that.categoryId,_that.name,_that.description,_that.basePriceMinor,_that.fromPriceMinor,_that.status,_that.imageUrls);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String businessId,  String categoryId,  String name,  String description,  int basePriceMinor,  int fromPriceMinor,  ProductStatus status,  List<String> imageUrls)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.businessId,_that.categoryId,_that.name,_that.description,_that.basePriceMinor,_that.fromPriceMinor,_that.status,_that.imageUrls);case _:
  return null;

}
}

}

/// @nodoc


class _Product extends Product {
  const _Product({required this.id, required this.businessId, required this.categoryId, required this.name, this.description = '', required this.basePriceMinor, required this.fromPriceMinor, this.status = ProductStatus.active,  List<String> imageUrls = const []}): _imageUrls = imageUrls,super._();
  

@override final  String id;
@override final  String businessId;
@override final  String categoryId;
@override final  String name;
@override@JsonKey() final  String description;
@override final  int basePriceMinor;
/// Cheapest selectable price — min over variant effective prices, base
/// price when the product has none. What grids/cards display.
@override final  int fromPriceMinor;
@override@JsonKey() final  ProductStatus status;
 final  List<String> _imageUrls;
@override@JsonKey() List<String> get imageUrls {
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageUrls);
}


/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.basePriceMinor, basePriceMinor) || other.basePriceMinor == basePriceMinor)&&(identical(other.fromPriceMinor, fromPriceMinor) || other.fromPriceMinor == fromPriceMinor)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._imageUrls, _imageUrls));
}


@override
int get hashCode => Object.hash(runtimeType,id,businessId,categoryId,name,description,basePriceMinor,fromPriceMinor,status,const DeepCollectionEquality().hash(_imageUrls));

@override
String toString() {
  return 'Product(id: $id, businessId: $businessId, categoryId: $categoryId, name: $name, description: $description, basePriceMinor: $basePriceMinor, fromPriceMinor: $fromPriceMinor, status: $status, imageUrls: $imageUrls)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String businessId, String categoryId, String name, String description, int basePriceMinor, int fromPriceMinor, ProductStatus status, List<String> imageUrls
});




}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? categoryId = null,Object? name = null,Object? description = null,Object? basePriceMinor = null,Object? fromPriceMinor = null,Object? status = null,Object? imageUrls = null,}) {
  return _then(_Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,basePriceMinor: null == basePriceMinor ? _self.basePriceMinor : basePriceMinor // ignore: cast_nullable_to_non_nullable
as int,fromPriceMinor: null == fromPriceMinor ? _self.fromPriceMinor : fromPriceMinor // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProductStatus,imageUrls: null == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
