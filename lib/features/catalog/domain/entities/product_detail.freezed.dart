// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductDetail {

 Product get product; List<ProductVariant> get variants; String get businessName; String get brandName; List<ProductReviewInfo> get reviews;
/// Create a copy of ProductDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductDetailCopyWith<ProductDetail> get copyWith => _$ProductDetailCopyWithImpl<ProductDetail>(this as ProductDetail, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductDetail&&(identical(other.product, product) || other.product == product)&&const DeepCollectionEquality().equals(other.variants, variants)&&(identical(other.businessName, businessName) || other.businessName == businessName)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&const DeepCollectionEquality().equals(other.reviews, reviews));
}


@override
int get hashCode => Object.hash(runtimeType,product,const DeepCollectionEquality().hash(variants),businessName,brandName,const DeepCollectionEquality().hash(reviews));

@override
String toString() {
  return 'ProductDetail(product: $product, variants: $variants, businessName: $businessName, brandName: $brandName, reviews: $reviews)';
}


}

/// @nodoc
abstract mixin class $ProductDetailCopyWith<$Res>  {
  factory $ProductDetailCopyWith(ProductDetail value, $Res Function(ProductDetail) _then) = _$ProductDetailCopyWithImpl;
@useResult
$Res call({
 Product product, List<ProductVariant> variants, String businessName, String brandName, List<ProductReviewInfo> reviews
});


$ProductCopyWith<$Res> get product;

}
/// @nodoc
class _$ProductDetailCopyWithImpl<$Res>
    implements $ProductDetailCopyWith<$Res> {
  _$ProductDetailCopyWithImpl(this._self, this._then);

  final ProductDetail _self;
  final $Res Function(ProductDetail) _then;

/// Create a copy of ProductDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? product = null,Object? variants = null,Object? businessName = null,Object? brandName = null,Object? reviews = null,}) {
  return _then(ProductDetail(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as Product,variants: null == variants ? _self.variants : variants // ignore: cast_nullable_to_non_nullable
as List<ProductVariant>,businessName: null == businessName ? _self.businessName : businessName // ignore: cast_nullable_to_non_nullable
as String,brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,reviews: null == reviews ? _self.reviews : reviews // ignore: cast_nullable_to_non_nullable
as List<ProductReviewInfo>,
  ));
}
/// Create a copy of ProductDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductCopyWith<$Res> get product {
  
  return $ProductCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProductDetail].
extension ProductDetailPatterns on ProductDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductDetail value)  $default,){
final _that = this;
switch (_that) {
case _ProductDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductDetail value)?  $default,){
final _that = this;
switch (_that) {
case _ProductDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Product product,  List<ProductVariant> variants,  String businessName,  String brandName,  List<ProductReviewInfo> reviews)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductDetail() when $default != null:
return $default(_that.product,_that.variants,_that.businessName,_that.brandName,_that.reviews);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Product product,  List<ProductVariant> variants,  String businessName,  String brandName,  List<ProductReviewInfo> reviews)  $default,) {final _that = this;
switch (_that) {
case _ProductDetail():
return $default(_that.product,_that.variants,_that.businessName,_that.brandName,_that.reviews);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Product product,  List<ProductVariant> variants,  String businessName,  String brandName,  List<ProductReviewInfo> reviews)?  $default,) {final _that = this;
switch (_that) {
case _ProductDetail() when $default != null:
return $default(_that.product,_that.variants,_that.businessName,_that.brandName,_that.reviews);case _:
  return null;

}
}

}

/// @nodoc


class _ProductDetail extends ProductDetail {
  const _ProductDetail({required this.product, required  List<ProductVariant> variants, this.businessName = '', this.brandName = '',  List<ProductReviewInfo> reviews = const []}): _variants = variants,_reviews = reviews,super._();
  

@override final  Product product;
 final  List<ProductVariant> _variants;
@override List<ProductVariant> get variants {
  if (_variants is EqualUnmodifiableListView) return _variants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_variants);
}

@override@JsonKey() final  String businessName;
@override@JsonKey() final  String brandName;
 final  List<ProductReviewInfo> _reviews;
@override@JsonKey() List<ProductReviewInfo> get reviews {
  if (_reviews is EqualUnmodifiableListView) return _reviews;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reviews);
}


/// Create a copy of ProductDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductDetailCopyWith<_ProductDetail> get copyWith => __$ProductDetailCopyWithImpl<_ProductDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductDetail&&(identical(other.product, product) || other.product == product)&&const DeepCollectionEquality().equals(other._variants, _variants)&&(identical(other.businessName, businessName) || other.businessName == businessName)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&const DeepCollectionEquality().equals(other._reviews, _reviews));
}


@override
int get hashCode => Object.hash(runtimeType,product,const DeepCollectionEquality().hash(_variants),businessName,brandName,const DeepCollectionEquality().hash(_reviews));

@override
String toString() {
  return 'ProductDetail(product: $product, variants: $variants, businessName: $businessName, brandName: $brandName, reviews: $reviews)';
}


}

/// @nodoc
abstract mixin class _$ProductDetailCopyWith<$Res> implements $ProductDetailCopyWith<$Res> {
  factory _$ProductDetailCopyWith(_ProductDetail value, $Res Function(_ProductDetail) _then) = __$ProductDetailCopyWithImpl;
@override @useResult
$Res call({
 Product product, List<ProductVariant> variants, String businessName, String brandName, List<ProductReviewInfo> reviews
});


@override $ProductCopyWith<$Res> get product;

}
/// @nodoc
class __$ProductDetailCopyWithImpl<$Res>
    implements _$ProductDetailCopyWith<$Res> {
  __$ProductDetailCopyWithImpl(this._self, this._then);

  final _ProductDetail _self;
  final $Res Function(_ProductDetail) _then;

/// Create a copy of ProductDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? product = null,Object? variants = null,Object? businessName = null,Object? brandName = null,Object? reviews = null,}) {
  return _then(_ProductDetail(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as Product,variants: null == variants ? _self._variants : variants // ignore: cast_nullable_to_non_nullable
as List<ProductVariant>,businessName: null == businessName ? _self.businessName : businessName // ignore: cast_nullable_to_non_nullable
as String,brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,reviews: null == reviews ? _self._reviews : reviews // ignore: cast_nullable_to_non_nullable
as List<ProductReviewInfo>,
  ));
}

/// Create a copy of ProductDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductCopyWith<$Res> get product {
  
  return $ProductCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}

/// @nodoc
mixin _$ProductReviewInfo {

 String get authorName; int get rating; String get text; DateTime get createdAt;
/// Create a copy of ProductReviewInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductReviewInfoCopyWith<ProductReviewInfo> get copyWith => _$ProductReviewInfoCopyWithImpl<ProductReviewInfo>(this as ProductReviewInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductReviewInfo&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,authorName,rating,text,createdAt);

@override
String toString() {
  return 'ProductReviewInfo(authorName: $authorName, rating: $rating, text: $text, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ProductReviewInfoCopyWith<$Res>  {
  factory $ProductReviewInfoCopyWith(ProductReviewInfo value, $Res Function(ProductReviewInfo) _then) = _$ProductReviewInfoCopyWithImpl;
@useResult
$Res call({
 String authorName, int rating, String text, DateTime createdAt
});




}
/// @nodoc
class _$ProductReviewInfoCopyWithImpl<$Res>
    implements $ProductReviewInfoCopyWith<$Res> {
  _$ProductReviewInfoCopyWithImpl(this._self, this._then);

  final ProductReviewInfo _self;
  final $Res Function(ProductReviewInfo) _then;

/// Create a copy of ProductReviewInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? authorName = null,Object? rating = null,Object? text = null,Object? createdAt = null,}) {
  return _then(ProductReviewInfo(
authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductReviewInfo].
extension ProductReviewInfoPatterns on ProductReviewInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductReviewInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductReviewInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductReviewInfo value)  $default,){
final _that = this;
switch (_that) {
case _ProductReviewInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductReviewInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ProductReviewInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String authorName,  int rating,  String text,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductReviewInfo() when $default != null:
return $default(_that.authorName,_that.rating,_that.text,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String authorName,  int rating,  String text,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ProductReviewInfo():
return $default(_that.authorName,_that.rating,_that.text,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String authorName,  int rating,  String text,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ProductReviewInfo() when $default != null:
return $default(_that.authorName,_that.rating,_that.text,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _ProductReviewInfo implements ProductReviewInfo {
  const _ProductReviewInfo({required this.authorName, required this.rating, this.text = '', required this.createdAt});
  

@override final  String authorName;
@override final  int rating;
@override@JsonKey() final  String text;
@override final  DateTime createdAt;

/// Create a copy of ProductReviewInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductReviewInfoCopyWith<_ProductReviewInfo> get copyWith => __$ProductReviewInfoCopyWithImpl<_ProductReviewInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductReviewInfo&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,authorName,rating,text,createdAt);

@override
String toString() {
  return 'ProductReviewInfo(authorName: $authorName, rating: $rating, text: $text, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ProductReviewInfoCopyWith<$Res> implements $ProductReviewInfoCopyWith<$Res> {
  factory _$ProductReviewInfoCopyWith(_ProductReviewInfo value, $Res Function(_ProductReviewInfo) _then) = __$ProductReviewInfoCopyWithImpl;
@override @useResult
$Res call({
 String authorName, int rating, String text, DateTime createdAt
});




}
/// @nodoc
class __$ProductReviewInfoCopyWithImpl<$Res>
    implements _$ProductReviewInfoCopyWith<$Res> {
  __$ProductReviewInfoCopyWithImpl(this._self, this._then);

  final _ProductReviewInfo _self;
  final $Res Function(_ProductReviewInfo) _then;

/// Create a copy of ProductReviewInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? authorName = null,Object? rating = null,Object? text = null,Object? createdAt = null,}) {
  return _then(_ProductReviewInfo(
authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
