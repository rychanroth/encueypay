// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CheckoutItem {

 String get id; String get productName; int get unitPriceMinor; int get quantity; String? get variantName; String? get imageUrl;
/// Create a copy of CheckoutItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckoutItemCopyWith<CheckoutItem> get copyWith => _$CheckoutItemCopyWithImpl<CheckoutItem>(this as CheckoutItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutItem&&(identical(other.id, id) || other.id == id)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.unitPriceMinor, unitPriceMinor) || other.unitPriceMinor == unitPriceMinor)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.variantName, variantName) || other.variantName == variantName)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,productName,unitPriceMinor,quantity,variantName,imageUrl);

@override
String toString() {
  return 'CheckoutItem(id: $id, productName: $productName, unitPriceMinor: $unitPriceMinor, quantity: $quantity, variantName: $variantName, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $CheckoutItemCopyWith<$Res>  {
  factory $CheckoutItemCopyWith(CheckoutItem value, $Res Function(CheckoutItem) _then) = _$CheckoutItemCopyWithImpl;
@useResult
$Res call({
 String id, String productName, int unitPriceMinor, int quantity, String? variantName, String? imageUrl
});




}
/// @nodoc
class _$CheckoutItemCopyWithImpl<$Res>
    implements $CheckoutItemCopyWith<$Res> {
  _$CheckoutItemCopyWithImpl(this._self, this._then);

  final CheckoutItem _self;
  final $Res Function(CheckoutItem) _then;

/// Create a copy of CheckoutItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productName = null,Object? unitPriceMinor = null,Object? quantity = null,Object? variantName = freezed,Object? imageUrl = freezed,}) {
  return _then(CheckoutItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,unitPriceMinor: null == unitPriceMinor ? _self.unitPriceMinor : unitPriceMinor // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,variantName: freezed == variantName ? _self.variantName : variantName // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CheckoutItem].
extension CheckoutItemPatterns on CheckoutItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckoutItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckoutItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckoutItem value)  $default,){
final _that = this;
switch (_that) {
case _CheckoutItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckoutItem value)?  $default,){
final _that = this;
switch (_that) {
case _CheckoutItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String productName,  int unitPriceMinor,  int quantity,  String? variantName,  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckoutItem() when $default != null:
return $default(_that.id,_that.productName,_that.unitPriceMinor,_that.quantity,_that.variantName,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String productName,  int unitPriceMinor,  int quantity,  String? variantName,  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _CheckoutItem():
return $default(_that.id,_that.productName,_that.unitPriceMinor,_that.quantity,_that.variantName,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String productName,  int unitPriceMinor,  int quantity,  String? variantName,  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _CheckoutItem() when $default != null:
return $default(_that.id,_that.productName,_that.unitPriceMinor,_that.quantity,_that.variantName,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc


class _CheckoutItem extends CheckoutItem {
  const _CheckoutItem({required this.id, required this.productName, required this.unitPriceMinor, required this.quantity, this.variantName, this.imageUrl}): super._();
  

@override final  String id;
@override final  String productName;
@override final  int unitPriceMinor;
@override final  int quantity;
@override final  String? variantName;
@override final  String? imageUrl;

/// Create a copy of CheckoutItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckoutItemCopyWith<_CheckoutItem> get copyWith => __$CheckoutItemCopyWithImpl<_CheckoutItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckoutItem&&(identical(other.id, id) || other.id == id)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.unitPriceMinor, unitPriceMinor) || other.unitPriceMinor == unitPriceMinor)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.variantName, variantName) || other.variantName == variantName)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,productName,unitPriceMinor,quantity,variantName,imageUrl);

@override
String toString() {
  return 'CheckoutItem(id: $id, productName: $productName, unitPriceMinor: $unitPriceMinor, quantity: $quantity, variantName: $variantName, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$CheckoutItemCopyWith<$Res> implements $CheckoutItemCopyWith<$Res> {
  factory _$CheckoutItemCopyWith(_CheckoutItem value, $Res Function(_CheckoutItem) _then) = __$CheckoutItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String productName, int unitPriceMinor, int quantity, String? variantName, String? imageUrl
});




}
/// @nodoc
class __$CheckoutItemCopyWithImpl<$Res>
    implements _$CheckoutItemCopyWith<$Res> {
  __$CheckoutItemCopyWithImpl(this._self, this._then);

  final _CheckoutItem _self;
  final $Res Function(_CheckoutItem) _then;

/// Create a copy of CheckoutItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productName = null,Object? unitPriceMinor = null,Object? quantity = null,Object? variantName = freezed,Object? imageUrl = freezed,}) {
  return _then(_CheckoutItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,unitPriceMinor: null == unitPriceMinor ? _self.unitPriceMinor : unitPriceMinor // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,variantName: freezed == variantName ? _self.variantName : variantName // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$CheckoutSummary {

 List<CheckoutItem> get items; int get subtotalMinor; int get deliveryFeeMinor;
/// Create a copy of CheckoutSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckoutSummaryCopyWith<CheckoutSummary> get copyWith => _$CheckoutSummaryCopyWithImpl<CheckoutSummary>(this as CheckoutSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutSummary&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.subtotalMinor, subtotalMinor) || other.subtotalMinor == subtotalMinor)&&(identical(other.deliveryFeeMinor, deliveryFeeMinor) || other.deliveryFeeMinor == deliveryFeeMinor));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),subtotalMinor,deliveryFeeMinor);

@override
String toString() {
  return 'CheckoutSummary(items: $items, subtotalMinor: $subtotalMinor, deliveryFeeMinor: $deliveryFeeMinor)';
}


}

/// @nodoc
abstract mixin class $CheckoutSummaryCopyWith<$Res>  {
  factory $CheckoutSummaryCopyWith(CheckoutSummary value, $Res Function(CheckoutSummary) _then) = _$CheckoutSummaryCopyWithImpl;
@useResult
$Res call({
 List<CheckoutItem> items, int subtotalMinor, int deliveryFeeMinor
});




}
/// @nodoc
class _$CheckoutSummaryCopyWithImpl<$Res>
    implements $CheckoutSummaryCopyWith<$Res> {
  _$CheckoutSummaryCopyWithImpl(this._self, this._then);

  final CheckoutSummary _self;
  final $Res Function(CheckoutSummary) _then;

/// Create a copy of CheckoutSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? subtotalMinor = null,Object? deliveryFeeMinor = null,}) {
  return _then(CheckoutSummary(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CheckoutItem>,subtotalMinor: null == subtotalMinor ? _self.subtotalMinor : subtotalMinor // ignore: cast_nullable_to_non_nullable
as int,deliveryFeeMinor: null == deliveryFeeMinor ? _self.deliveryFeeMinor : deliveryFeeMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CheckoutSummary].
extension CheckoutSummaryPatterns on CheckoutSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckoutSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckoutSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckoutSummary value)  $default,){
final _that = this;
switch (_that) {
case _CheckoutSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckoutSummary value)?  $default,){
final _that = this;
switch (_that) {
case _CheckoutSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CheckoutItem> items,  int subtotalMinor,  int deliveryFeeMinor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckoutSummary() when $default != null:
return $default(_that.items,_that.subtotalMinor,_that.deliveryFeeMinor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CheckoutItem> items,  int subtotalMinor,  int deliveryFeeMinor)  $default,) {final _that = this;
switch (_that) {
case _CheckoutSummary():
return $default(_that.items,_that.subtotalMinor,_that.deliveryFeeMinor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CheckoutItem> items,  int subtotalMinor,  int deliveryFeeMinor)?  $default,) {final _that = this;
switch (_that) {
case _CheckoutSummary() when $default != null:
return $default(_that.items,_that.subtotalMinor,_that.deliveryFeeMinor);case _:
  return null;

}
}

}

/// @nodoc


class _CheckoutSummary extends CheckoutSummary {
  const _CheckoutSummary({required  List<CheckoutItem> items, required this.subtotalMinor, required this.deliveryFeeMinor}): _items = items,super._();
  

 final  List<CheckoutItem> _items;
@override List<CheckoutItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int subtotalMinor;
@override final  int deliveryFeeMinor;

/// Create a copy of CheckoutSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckoutSummaryCopyWith<_CheckoutSummary> get copyWith => __$CheckoutSummaryCopyWithImpl<_CheckoutSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckoutSummary&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.subtotalMinor, subtotalMinor) || other.subtotalMinor == subtotalMinor)&&(identical(other.deliveryFeeMinor, deliveryFeeMinor) || other.deliveryFeeMinor == deliveryFeeMinor));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),subtotalMinor,deliveryFeeMinor);

@override
String toString() {
  return 'CheckoutSummary(items: $items, subtotalMinor: $subtotalMinor, deliveryFeeMinor: $deliveryFeeMinor)';
}


}

/// @nodoc
abstract mixin class _$CheckoutSummaryCopyWith<$Res> implements $CheckoutSummaryCopyWith<$Res> {
  factory _$CheckoutSummaryCopyWith(_CheckoutSummary value, $Res Function(_CheckoutSummary) _then) = __$CheckoutSummaryCopyWithImpl;
@override @useResult
$Res call({
 List<CheckoutItem> items, int subtotalMinor, int deliveryFeeMinor
});




}
/// @nodoc
class __$CheckoutSummaryCopyWithImpl<$Res>
    implements _$CheckoutSummaryCopyWith<$Res> {
  __$CheckoutSummaryCopyWithImpl(this._self, this._then);

  final _CheckoutSummary _self;
  final $Res Function(_CheckoutSummary) _then;

/// Create a copy of CheckoutSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? subtotalMinor = null,Object? deliveryFeeMinor = null,}) {
  return _then(_CheckoutSummary(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CheckoutItem>,subtotalMinor: null == subtotalMinor ? _self.subtotalMinor : subtotalMinor // ignore: cast_nullable_to_non_nullable
as int,deliveryFeeMinor: null == deliveryFeeMinor ? _self.deliveryFeeMinor : deliveryFeeMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
