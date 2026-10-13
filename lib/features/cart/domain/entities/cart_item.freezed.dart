// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CartItem {

 String get id; String get variantId; String get productId; String get productName; String? get variantName; int get unitPriceMinor; int get quantity;/// Product-wide stock snapshot (Section 6): all variants of the product
/// share it; caps the tile's quantity stepper. The server re-validates
/// authoritatively at checkout (§53).
 int get stock; String? get imageUrl;
/// Create a copy of CartItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartItemCopyWith<CartItem> get copyWith => _$CartItemCopyWithImpl<CartItem>(this as CartItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartItem&&(identical(other.id, id) || other.id == id)&&(identical(other.variantId, variantId) || other.variantId == variantId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.variantName, variantName) || other.variantName == variantName)&&(identical(other.unitPriceMinor, unitPriceMinor) || other.unitPriceMinor == unitPriceMinor)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,variantId,productId,productName,variantName,unitPriceMinor,quantity,stock,imageUrl);

@override
String toString() {
  return 'CartItem(id: $id, variantId: $variantId, productId: $productId, productName: $productName, variantName: $variantName, unitPriceMinor: $unitPriceMinor, quantity: $quantity, stock: $stock, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $CartItemCopyWith<$Res>  {
  factory $CartItemCopyWith(CartItem value, $Res Function(CartItem) _then) = _$CartItemCopyWithImpl;
@useResult
$Res call({
 String id, String variantId, String productId, String productName, String? variantName, int unitPriceMinor, int quantity, int stock, String? imageUrl
});




}
/// @nodoc
class _$CartItemCopyWithImpl<$Res>
    implements $CartItemCopyWith<$Res> {
  _$CartItemCopyWithImpl(this._self, this._then);

  final CartItem _self;
  final $Res Function(CartItem) _then;

/// Create a copy of CartItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? variantId = null,Object? productId = null,Object? productName = null,Object? variantName = freezed,Object? unitPriceMinor = null,Object? quantity = null,Object? stock = null,Object? imageUrl = freezed,}) {
  return _then(CartItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,variantId: null == variantId ? _self.variantId : variantId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,variantName: freezed == variantName ? _self.variantName : variantName // ignore: cast_nullable_to_non_nullable
as String?,unitPriceMinor: null == unitPriceMinor ? _self.unitPriceMinor : unitPriceMinor // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CartItem].
extension CartItemPatterns on CartItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CartItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CartItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CartItem value)  $default,){
final _that = this;
switch (_that) {
case _CartItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CartItem value)?  $default,){
final _that = this;
switch (_that) {
case _CartItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String variantId,  String productId,  String productName,  String? variantName,  int unitPriceMinor,  int quantity,  int stock,  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CartItem() when $default != null:
return $default(_that.id,_that.variantId,_that.productId,_that.productName,_that.variantName,_that.unitPriceMinor,_that.quantity,_that.stock,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String variantId,  String productId,  String productName,  String? variantName,  int unitPriceMinor,  int quantity,  int stock,  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _CartItem():
return $default(_that.id,_that.variantId,_that.productId,_that.productName,_that.variantName,_that.unitPriceMinor,_that.quantity,_that.stock,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String variantId,  String productId,  String productName,  String? variantName,  int unitPriceMinor,  int quantity,  int stock,  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _CartItem() when $default != null:
return $default(_that.id,_that.variantId,_that.productId,_that.productName,_that.variantName,_that.unitPriceMinor,_that.quantity,_that.stock,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc


class _CartItem extends CartItem {
  const _CartItem({required this.id, required this.variantId, required this.productId, required this.productName, this.variantName, required this.unitPriceMinor, required this.quantity, this.stock = 0, this.imageUrl}): super._();
  

@override final  String id;
@override final  String variantId;
@override final  String productId;
@override final  String productName;
@override final  String? variantName;
@override final  int unitPriceMinor;
@override final  int quantity;
/// Product-wide stock snapshot (Section 6): all variants of the product
/// share it; caps the tile's quantity stepper. The server re-validates
/// authoritatively at checkout (§53).
@override@JsonKey() final  int stock;
@override final  String? imageUrl;

/// Create a copy of CartItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartItemCopyWith<_CartItem> get copyWith => __$CartItemCopyWithImpl<_CartItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CartItem&&(identical(other.id, id) || other.id == id)&&(identical(other.variantId, variantId) || other.variantId == variantId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.variantName, variantName) || other.variantName == variantName)&&(identical(other.unitPriceMinor, unitPriceMinor) || other.unitPriceMinor == unitPriceMinor)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,variantId,productId,productName,variantName,unitPriceMinor,quantity,stock,imageUrl);

@override
String toString() {
  return 'CartItem(id: $id, variantId: $variantId, productId: $productId, productName: $productName, variantName: $variantName, unitPriceMinor: $unitPriceMinor, quantity: $quantity, stock: $stock, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$CartItemCopyWith<$Res> implements $CartItemCopyWith<$Res> {
  factory _$CartItemCopyWith(_CartItem value, $Res Function(_CartItem) _then) = __$CartItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String variantId, String productId, String productName, String? variantName, int unitPriceMinor, int quantity, int stock, String? imageUrl
});




}
/// @nodoc
class __$CartItemCopyWithImpl<$Res>
    implements _$CartItemCopyWith<$Res> {
  __$CartItemCopyWithImpl(this._self, this._then);

  final _CartItem _self;
  final $Res Function(_CartItem) _then;

/// Create a copy of CartItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? variantId = null,Object? productId = null,Object? productName = null,Object? variantName = freezed,Object? unitPriceMinor = null,Object? quantity = null,Object? stock = null,Object? imageUrl = freezed,}) {
  return _then(_CartItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,variantId: null == variantId ? _self.variantId : variantId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,variantName: freezed == variantName ? _self.variantName : variantName // ignore: cast_nullable_to_non_nullable
as String?,unitPriceMinor: null == unitPriceMinor ? _self.unitPriceMinor : unitPriceMinor // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
