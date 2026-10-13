// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CustomerOrder {

 String get id; DateTime get createdAt; OrderStatus get status; int get subtotalMinor; int get discountMinor; int get deliveryFeeMinor; int get totalMinor; String get shippingRecipientName; String get shippingPhone; String get shippingLine1; String? get shippingLine2; String get shippingCity; String get note; String get cancellationReason; List<OrderItemSnapshot> get items; List<ReturnRequestInfo> get returns; OrderPayment? get payment;
/// Create a copy of CustomerOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerOrderCopyWith<CustomerOrder> get copyWith => _$CustomerOrderCopyWithImpl<CustomerOrder>(this as CustomerOrder, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.subtotalMinor, subtotalMinor) || other.subtotalMinor == subtotalMinor)&&(identical(other.discountMinor, discountMinor) || other.discountMinor == discountMinor)&&(identical(other.deliveryFeeMinor, deliveryFeeMinor) || other.deliveryFeeMinor == deliveryFeeMinor)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor)&&(identical(other.shippingRecipientName, shippingRecipientName) || other.shippingRecipientName == shippingRecipientName)&&(identical(other.shippingPhone, shippingPhone) || other.shippingPhone == shippingPhone)&&(identical(other.shippingLine1, shippingLine1) || other.shippingLine1 == shippingLine1)&&(identical(other.shippingLine2, shippingLine2) || other.shippingLine2 == shippingLine2)&&(identical(other.shippingCity, shippingCity) || other.shippingCity == shippingCity)&&(identical(other.note, note) || other.note == note)&&(identical(other.cancellationReason, cancellationReason) || other.cancellationReason == cancellationReason)&&const DeepCollectionEquality().equals(other.items, items)&&const DeepCollectionEquality().equals(other.returns, returns)&&(identical(other.payment, payment) || other.payment == payment));
}


@override
int get hashCode => Object.hash(runtimeType,id,createdAt,status,subtotalMinor,discountMinor,deliveryFeeMinor,totalMinor,shippingRecipientName,shippingPhone,shippingLine1,shippingLine2,shippingCity,note,cancellationReason,const DeepCollectionEquality().hash(items),const DeepCollectionEquality().hash(returns),payment);

@override
String toString() {
  return 'CustomerOrder(id: $id, createdAt: $createdAt, status: $status, subtotalMinor: $subtotalMinor, discountMinor: $discountMinor, deliveryFeeMinor: $deliveryFeeMinor, totalMinor: $totalMinor, shippingRecipientName: $shippingRecipientName, shippingPhone: $shippingPhone, shippingLine1: $shippingLine1, shippingLine2: $shippingLine2, shippingCity: $shippingCity, note: $note, cancellationReason: $cancellationReason, items: $items, returns: $returns, payment: $payment)';
}


}

/// @nodoc
abstract mixin class $CustomerOrderCopyWith<$Res>  {
  factory $CustomerOrderCopyWith(CustomerOrder value, $Res Function(CustomerOrder) _then) = _$CustomerOrderCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, OrderStatus status, int subtotalMinor, int discountMinor, int deliveryFeeMinor, int totalMinor, String shippingRecipientName, String shippingPhone, String shippingLine1, String? shippingLine2, String shippingCity, String note, String cancellationReason, List<OrderItemSnapshot> items, List<ReturnRequestInfo> returns, OrderPayment? payment
});


$OrderPaymentCopyWith<$Res>? get payment;

}
/// @nodoc
class _$CustomerOrderCopyWithImpl<$Res>
    implements $CustomerOrderCopyWith<$Res> {
  _$CustomerOrderCopyWithImpl(this._self, this._then);

  final CustomerOrder _self;
  final $Res Function(CustomerOrder) _then;

/// Create a copy of CustomerOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? status = null,Object? subtotalMinor = null,Object? discountMinor = null,Object? deliveryFeeMinor = null,Object? totalMinor = null,Object? shippingRecipientName = null,Object? shippingPhone = null,Object? shippingLine1 = null,Object? shippingLine2 = freezed,Object? shippingCity = null,Object? note = null,Object? cancellationReason = null,Object? items = null,Object? returns = null,Object? payment = freezed,}) {
  return _then(CustomerOrder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,subtotalMinor: null == subtotalMinor ? _self.subtotalMinor : subtotalMinor // ignore: cast_nullable_to_non_nullable
as int,discountMinor: null == discountMinor ? _self.discountMinor : discountMinor // ignore: cast_nullable_to_non_nullable
as int,deliveryFeeMinor: null == deliveryFeeMinor ? _self.deliveryFeeMinor : deliveryFeeMinor // ignore: cast_nullable_to_non_nullable
as int,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,shippingRecipientName: null == shippingRecipientName ? _self.shippingRecipientName : shippingRecipientName // ignore: cast_nullable_to_non_nullable
as String,shippingPhone: null == shippingPhone ? _self.shippingPhone : shippingPhone // ignore: cast_nullable_to_non_nullable
as String,shippingLine1: null == shippingLine1 ? _self.shippingLine1 : shippingLine1 // ignore: cast_nullable_to_non_nullable
as String,shippingLine2: freezed == shippingLine2 ? _self.shippingLine2 : shippingLine2 // ignore: cast_nullable_to_non_nullable
as String?,shippingCity: null == shippingCity ? _self.shippingCity : shippingCity // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,cancellationReason: null == cancellationReason ? _self.cancellationReason : cancellationReason // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItemSnapshot>,returns: null == returns ? _self.returns : returns // ignore: cast_nullable_to_non_nullable
as List<ReturnRequestInfo>,payment: freezed == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as OrderPayment?,
  ));
}
/// Create a copy of CustomerOrder
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderPaymentCopyWith<$Res>? get payment {
    if (_self.payment == null) {
    return null;
  }

  return $OrderPaymentCopyWith<$Res>(_self.payment!, (value) {
    return _then(_self.copyWith(payment: value));
  });
}
}


/// Adds pattern-matching-related methods to [CustomerOrder].
extension CustomerOrderPatterns on CustomerOrder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerOrder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerOrder value)  $default,){
final _that = this;
switch (_that) {
case _CustomerOrder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerOrder value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerOrder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  OrderStatus status,  int subtotalMinor,  int discountMinor,  int deliveryFeeMinor,  int totalMinor,  String shippingRecipientName,  String shippingPhone,  String shippingLine1,  String? shippingLine2,  String shippingCity,  String note,  String cancellationReason,  List<OrderItemSnapshot> items,  List<ReturnRequestInfo> returns,  OrderPayment? payment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerOrder() when $default != null:
return $default(_that.id,_that.createdAt,_that.status,_that.subtotalMinor,_that.discountMinor,_that.deliveryFeeMinor,_that.totalMinor,_that.shippingRecipientName,_that.shippingPhone,_that.shippingLine1,_that.shippingLine2,_that.shippingCity,_that.note,_that.cancellationReason,_that.items,_that.returns,_that.payment);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  OrderStatus status,  int subtotalMinor,  int discountMinor,  int deliveryFeeMinor,  int totalMinor,  String shippingRecipientName,  String shippingPhone,  String shippingLine1,  String? shippingLine2,  String shippingCity,  String note,  String cancellationReason,  List<OrderItemSnapshot> items,  List<ReturnRequestInfo> returns,  OrderPayment? payment)  $default,) {final _that = this;
switch (_that) {
case _CustomerOrder():
return $default(_that.id,_that.createdAt,_that.status,_that.subtotalMinor,_that.discountMinor,_that.deliveryFeeMinor,_that.totalMinor,_that.shippingRecipientName,_that.shippingPhone,_that.shippingLine1,_that.shippingLine2,_that.shippingCity,_that.note,_that.cancellationReason,_that.items,_that.returns,_that.payment);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime createdAt,  OrderStatus status,  int subtotalMinor,  int discountMinor,  int deliveryFeeMinor,  int totalMinor,  String shippingRecipientName,  String shippingPhone,  String shippingLine1,  String? shippingLine2,  String shippingCity,  String note,  String cancellationReason,  List<OrderItemSnapshot> items,  List<ReturnRequestInfo> returns,  OrderPayment? payment)?  $default,) {final _that = this;
switch (_that) {
case _CustomerOrder() when $default != null:
return $default(_that.id,_that.createdAt,_that.status,_that.subtotalMinor,_that.discountMinor,_that.deliveryFeeMinor,_that.totalMinor,_that.shippingRecipientName,_that.shippingPhone,_that.shippingLine1,_that.shippingLine2,_that.shippingCity,_that.note,_that.cancellationReason,_that.items,_that.returns,_that.payment);case _:
  return null;

}
}

}

/// @nodoc


class _CustomerOrder extends CustomerOrder {
  const _CustomerOrder({required this.id, required this.createdAt, required this.status, required this.subtotalMinor, required this.discountMinor, required this.deliveryFeeMinor, required this.totalMinor, required this.shippingRecipientName, this.shippingPhone = '', required this.shippingLine1, this.shippingLine2, required this.shippingCity, this.note = '', this.cancellationReason = '',  List<OrderItemSnapshot> items = const [],  List<ReturnRequestInfo> returns = const [], this.payment}): _items = items,_returns = returns,super._();
  

@override final  String id;
@override final  DateTime createdAt;
@override final  OrderStatus status;
@override final  int subtotalMinor;
@override final  int discountMinor;
@override final  int deliveryFeeMinor;
@override final  int totalMinor;
@override final  String shippingRecipientName;
@override@JsonKey() final  String shippingPhone;
@override final  String shippingLine1;
@override final  String? shippingLine2;
@override final  String shippingCity;
@override@JsonKey() final  String note;
@override@JsonKey() final  String cancellationReason;
 final  List<OrderItemSnapshot> _items;
@override@JsonKey() List<OrderItemSnapshot> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  List<ReturnRequestInfo> _returns;
@override@JsonKey() List<ReturnRequestInfo> get returns {
  if (_returns is EqualUnmodifiableListView) return _returns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_returns);
}

@override final  OrderPayment? payment;

/// Create a copy of CustomerOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerOrderCopyWith<_CustomerOrder> get copyWith => __$CustomerOrderCopyWithImpl<_CustomerOrder>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.subtotalMinor, subtotalMinor) || other.subtotalMinor == subtotalMinor)&&(identical(other.discountMinor, discountMinor) || other.discountMinor == discountMinor)&&(identical(other.deliveryFeeMinor, deliveryFeeMinor) || other.deliveryFeeMinor == deliveryFeeMinor)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor)&&(identical(other.shippingRecipientName, shippingRecipientName) || other.shippingRecipientName == shippingRecipientName)&&(identical(other.shippingPhone, shippingPhone) || other.shippingPhone == shippingPhone)&&(identical(other.shippingLine1, shippingLine1) || other.shippingLine1 == shippingLine1)&&(identical(other.shippingLine2, shippingLine2) || other.shippingLine2 == shippingLine2)&&(identical(other.shippingCity, shippingCity) || other.shippingCity == shippingCity)&&(identical(other.note, note) || other.note == note)&&(identical(other.cancellationReason, cancellationReason) || other.cancellationReason == cancellationReason)&&const DeepCollectionEquality().equals(other._items, _items)&&const DeepCollectionEquality().equals(other._returns, _returns)&&(identical(other.payment, payment) || other.payment == payment));
}


@override
int get hashCode => Object.hash(runtimeType,id,createdAt,status,subtotalMinor,discountMinor,deliveryFeeMinor,totalMinor,shippingRecipientName,shippingPhone,shippingLine1,shippingLine2,shippingCity,note,cancellationReason,const DeepCollectionEquality().hash(_items),const DeepCollectionEquality().hash(_returns),payment);

@override
String toString() {
  return 'CustomerOrder(id: $id, createdAt: $createdAt, status: $status, subtotalMinor: $subtotalMinor, discountMinor: $discountMinor, deliveryFeeMinor: $deliveryFeeMinor, totalMinor: $totalMinor, shippingRecipientName: $shippingRecipientName, shippingPhone: $shippingPhone, shippingLine1: $shippingLine1, shippingLine2: $shippingLine2, shippingCity: $shippingCity, note: $note, cancellationReason: $cancellationReason, items: $items, returns: $returns, payment: $payment)';
}


}

/// @nodoc
abstract mixin class _$CustomerOrderCopyWith<$Res> implements $CustomerOrderCopyWith<$Res> {
  factory _$CustomerOrderCopyWith(_CustomerOrder value, $Res Function(_CustomerOrder) _then) = __$CustomerOrderCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime createdAt, OrderStatus status, int subtotalMinor, int discountMinor, int deliveryFeeMinor, int totalMinor, String shippingRecipientName, String shippingPhone, String shippingLine1, String? shippingLine2, String shippingCity, String note, String cancellationReason, List<OrderItemSnapshot> items, List<ReturnRequestInfo> returns, OrderPayment? payment
});


@override $OrderPaymentCopyWith<$Res>? get payment;

}
/// @nodoc
class __$CustomerOrderCopyWithImpl<$Res>
    implements _$CustomerOrderCopyWith<$Res> {
  __$CustomerOrderCopyWithImpl(this._self, this._then);

  final _CustomerOrder _self;
  final $Res Function(_CustomerOrder) _then;

/// Create a copy of CustomerOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = null,Object? status = null,Object? subtotalMinor = null,Object? discountMinor = null,Object? deliveryFeeMinor = null,Object? totalMinor = null,Object? shippingRecipientName = null,Object? shippingPhone = null,Object? shippingLine1 = null,Object? shippingLine2 = freezed,Object? shippingCity = null,Object? note = null,Object? cancellationReason = null,Object? items = null,Object? returns = null,Object? payment = freezed,}) {
  return _then(_CustomerOrder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,subtotalMinor: null == subtotalMinor ? _self.subtotalMinor : subtotalMinor // ignore: cast_nullable_to_non_nullable
as int,discountMinor: null == discountMinor ? _self.discountMinor : discountMinor // ignore: cast_nullable_to_non_nullable
as int,deliveryFeeMinor: null == deliveryFeeMinor ? _self.deliveryFeeMinor : deliveryFeeMinor // ignore: cast_nullable_to_non_nullable
as int,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,shippingRecipientName: null == shippingRecipientName ? _self.shippingRecipientName : shippingRecipientName // ignore: cast_nullable_to_non_nullable
as String,shippingPhone: null == shippingPhone ? _self.shippingPhone : shippingPhone // ignore: cast_nullable_to_non_nullable
as String,shippingLine1: null == shippingLine1 ? _self.shippingLine1 : shippingLine1 // ignore: cast_nullable_to_non_nullable
as String,shippingLine2: freezed == shippingLine2 ? _self.shippingLine2 : shippingLine2 // ignore: cast_nullable_to_non_nullable
as String?,shippingCity: null == shippingCity ? _self.shippingCity : shippingCity // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,cancellationReason: null == cancellationReason ? _self.cancellationReason : cancellationReason // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItemSnapshot>,returns: null == returns ? _self._returns : returns // ignore: cast_nullable_to_non_nullable
as List<ReturnRequestInfo>,payment: freezed == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as OrderPayment?,
  ));
}

/// Create a copy of CustomerOrder
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderPaymentCopyWith<$Res>? get payment {
    if (_self.payment == null) {
    return null;
  }

  return $OrderPaymentCopyWith<$Res>(_self.payment!, (value) {
    return _then(_self.copyWith(payment: value));
  });
}
}

/// @nodoc
mixin _$OrderItemSnapshot {

 String get id; String get productName; int get unitPriceMinor; int get quantity; int get lineTotalMinor; String? get variantName; int get discountMinor;
/// Create a copy of OrderItemSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderItemSnapshotCopyWith<OrderItemSnapshot> get copyWith => _$OrderItemSnapshotCopyWithImpl<OrderItemSnapshot>(this as OrderItemSnapshot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderItemSnapshot&&(identical(other.id, id) || other.id == id)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.unitPriceMinor, unitPriceMinor) || other.unitPriceMinor == unitPriceMinor)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.lineTotalMinor, lineTotalMinor) || other.lineTotalMinor == lineTotalMinor)&&(identical(other.variantName, variantName) || other.variantName == variantName)&&(identical(other.discountMinor, discountMinor) || other.discountMinor == discountMinor));
}


@override
int get hashCode => Object.hash(runtimeType,id,productName,unitPriceMinor,quantity,lineTotalMinor,variantName,discountMinor);

@override
String toString() {
  return 'OrderItemSnapshot(id: $id, productName: $productName, unitPriceMinor: $unitPriceMinor, quantity: $quantity, lineTotalMinor: $lineTotalMinor, variantName: $variantName, discountMinor: $discountMinor)';
}


}

/// @nodoc
abstract mixin class $OrderItemSnapshotCopyWith<$Res>  {
  factory $OrderItemSnapshotCopyWith(OrderItemSnapshot value, $Res Function(OrderItemSnapshot) _then) = _$OrderItemSnapshotCopyWithImpl;
@useResult
$Res call({
 String id, String productName, int unitPriceMinor, int quantity, int lineTotalMinor, String? variantName, int discountMinor
});




}
/// @nodoc
class _$OrderItemSnapshotCopyWithImpl<$Res>
    implements $OrderItemSnapshotCopyWith<$Res> {
  _$OrderItemSnapshotCopyWithImpl(this._self, this._then);

  final OrderItemSnapshot _self;
  final $Res Function(OrderItemSnapshot) _then;

/// Create a copy of OrderItemSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productName = null,Object? unitPriceMinor = null,Object? quantity = null,Object? lineTotalMinor = null,Object? variantName = freezed,Object? discountMinor = null,}) {
  return _then(OrderItemSnapshot(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,unitPriceMinor: null == unitPriceMinor ? _self.unitPriceMinor : unitPriceMinor // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,lineTotalMinor: null == lineTotalMinor ? _self.lineTotalMinor : lineTotalMinor // ignore: cast_nullable_to_non_nullable
as int,variantName: freezed == variantName ? _self.variantName : variantName // ignore: cast_nullable_to_non_nullable
as String?,discountMinor: null == discountMinor ? _self.discountMinor : discountMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderItemSnapshot].
extension OrderItemSnapshotPatterns on OrderItemSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderItemSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderItemSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderItemSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _OrderItemSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderItemSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _OrderItemSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String productName,  int unitPriceMinor,  int quantity,  int lineTotalMinor,  String? variantName,  int discountMinor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderItemSnapshot() when $default != null:
return $default(_that.id,_that.productName,_that.unitPriceMinor,_that.quantity,_that.lineTotalMinor,_that.variantName,_that.discountMinor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String productName,  int unitPriceMinor,  int quantity,  int lineTotalMinor,  String? variantName,  int discountMinor)  $default,) {final _that = this;
switch (_that) {
case _OrderItemSnapshot():
return $default(_that.id,_that.productName,_that.unitPriceMinor,_that.quantity,_that.lineTotalMinor,_that.variantName,_that.discountMinor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String productName,  int unitPriceMinor,  int quantity,  int lineTotalMinor,  String? variantName,  int discountMinor)?  $default,) {final _that = this;
switch (_that) {
case _OrderItemSnapshot() when $default != null:
return $default(_that.id,_that.productName,_that.unitPriceMinor,_that.quantity,_that.lineTotalMinor,_that.variantName,_that.discountMinor);case _:
  return null;

}
}

}

/// @nodoc


class _OrderItemSnapshot implements OrderItemSnapshot {
  const _OrderItemSnapshot({required this.id, required this.productName, required this.unitPriceMinor, required this.quantity, required this.lineTotalMinor, this.variantName, this.discountMinor = 0});
  

@override final  String id;
@override final  String productName;
@override final  int unitPriceMinor;
@override final  int quantity;
@override final  int lineTotalMinor;
@override final  String? variantName;
@override@JsonKey() final  int discountMinor;

/// Create a copy of OrderItemSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderItemSnapshotCopyWith<_OrderItemSnapshot> get copyWith => __$OrderItemSnapshotCopyWithImpl<_OrderItemSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderItemSnapshot&&(identical(other.id, id) || other.id == id)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.unitPriceMinor, unitPriceMinor) || other.unitPriceMinor == unitPriceMinor)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.lineTotalMinor, lineTotalMinor) || other.lineTotalMinor == lineTotalMinor)&&(identical(other.variantName, variantName) || other.variantName == variantName)&&(identical(other.discountMinor, discountMinor) || other.discountMinor == discountMinor));
}


@override
int get hashCode => Object.hash(runtimeType,id,productName,unitPriceMinor,quantity,lineTotalMinor,variantName,discountMinor);

@override
String toString() {
  return 'OrderItemSnapshot(id: $id, productName: $productName, unitPriceMinor: $unitPriceMinor, quantity: $quantity, lineTotalMinor: $lineTotalMinor, variantName: $variantName, discountMinor: $discountMinor)';
}


}

/// @nodoc
abstract mixin class _$OrderItemSnapshotCopyWith<$Res> implements $OrderItemSnapshotCopyWith<$Res> {
  factory _$OrderItemSnapshotCopyWith(_OrderItemSnapshot value, $Res Function(_OrderItemSnapshot) _then) = __$OrderItemSnapshotCopyWithImpl;
@override @useResult
$Res call({
 String id, String productName, int unitPriceMinor, int quantity, int lineTotalMinor, String? variantName, int discountMinor
});




}
/// @nodoc
class __$OrderItemSnapshotCopyWithImpl<$Res>
    implements _$OrderItemSnapshotCopyWith<$Res> {
  __$OrderItemSnapshotCopyWithImpl(this._self, this._then);

  final _OrderItemSnapshot _self;
  final $Res Function(_OrderItemSnapshot) _then;

/// Create a copy of OrderItemSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productName = null,Object? unitPriceMinor = null,Object? quantity = null,Object? lineTotalMinor = null,Object? variantName = freezed,Object? discountMinor = null,}) {
  return _then(_OrderItemSnapshot(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,unitPriceMinor: null == unitPriceMinor ? _self.unitPriceMinor : unitPriceMinor // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,lineTotalMinor: null == lineTotalMinor ? _self.lineTotalMinor : lineTotalMinor // ignore: cast_nullable_to_non_nullable
as int,variantName: freezed == variantName ? _self.variantName : variantName // ignore: cast_nullable_to_non_nullable
as String?,discountMinor: null == discountMinor ? _self.discountMinor : discountMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$ReturnRequestInfo {

 String get id; ReturnStatus get status; String get reason;
/// Create a copy of ReturnRequestInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReturnRequestInfoCopyWith<ReturnRequestInfo> get copyWith => _$ReturnRequestInfoCopyWithImpl<ReturnRequestInfo>(this as ReturnRequestInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReturnRequestInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,id,status,reason);

@override
String toString() {
  return 'ReturnRequestInfo(id: $id, status: $status, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $ReturnRequestInfoCopyWith<$Res>  {
  factory $ReturnRequestInfoCopyWith(ReturnRequestInfo value, $Res Function(ReturnRequestInfo) _then) = _$ReturnRequestInfoCopyWithImpl;
@useResult
$Res call({
 String id, ReturnStatus status, String reason
});




}
/// @nodoc
class _$ReturnRequestInfoCopyWithImpl<$Res>
    implements $ReturnRequestInfoCopyWith<$Res> {
  _$ReturnRequestInfoCopyWithImpl(this._self, this._then);

  final ReturnRequestInfo _self;
  final $Res Function(ReturnRequestInfo) _then;

/// Create a copy of ReturnRequestInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? reason = null,}) {
  return _then(ReturnRequestInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReturnStatus,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReturnRequestInfo].
extension ReturnRequestInfoPatterns on ReturnRequestInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReturnRequestInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReturnRequestInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReturnRequestInfo value)  $default,){
final _that = this;
switch (_that) {
case _ReturnRequestInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReturnRequestInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ReturnRequestInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  ReturnStatus status,  String reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReturnRequestInfo() when $default != null:
return $default(_that.id,_that.status,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  ReturnStatus status,  String reason)  $default,) {final _that = this;
switch (_that) {
case _ReturnRequestInfo():
return $default(_that.id,_that.status,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  ReturnStatus status,  String reason)?  $default,) {final _that = this;
switch (_that) {
case _ReturnRequestInfo() when $default != null:
return $default(_that.id,_that.status,_that.reason);case _:
  return null;

}
}

}

/// @nodoc


class _ReturnRequestInfo implements ReturnRequestInfo {
  const _ReturnRequestInfo({required this.id, required this.status, this.reason = ''});
  

@override final  String id;
@override final  ReturnStatus status;
@override@JsonKey() final  String reason;

/// Create a copy of ReturnRequestInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReturnRequestInfoCopyWith<_ReturnRequestInfo> get copyWith => __$ReturnRequestInfoCopyWithImpl<_ReturnRequestInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReturnRequestInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,id,status,reason);

@override
String toString() {
  return 'ReturnRequestInfo(id: $id, status: $status, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$ReturnRequestInfoCopyWith<$Res> implements $ReturnRequestInfoCopyWith<$Res> {
  factory _$ReturnRequestInfoCopyWith(_ReturnRequestInfo value, $Res Function(_ReturnRequestInfo) _then) = __$ReturnRequestInfoCopyWithImpl;
@override @useResult
$Res call({
 String id, ReturnStatus status, String reason
});




}
/// @nodoc
class __$ReturnRequestInfoCopyWithImpl<$Res>
    implements _$ReturnRequestInfoCopyWith<$Res> {
  __$ReturnRequestInfoCopyWithImpl(this._self, this._then);

  final _ReturnRequestInfo _self;
  final $Res Function(_ReturnRequestInfo) _then;

/// Create a copy of ReturnRequestInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? reason = null,}) {
  return _then(_ReturnRequestInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReturnStatus,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$OrderPayment {

 PaymentMethodKind get method; PaymentStatusState get status; int get amountMinor;
/// Create a copy of OrderPayment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderPaymentCopyWith<OrderPayment> get copyWith => _$OrderPaymentCopyWithImpl<OrderPayment>(this as OrderPayment, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderPayment&&(identical(other.method, method) || other.method == method)&&(identical(other.status, status) || other.status == status)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor));
}


@override
int get hashCode => Object.hash(runtimeType,method,status,amountMinor);

@override
String toString() {
  return 'OrderPayment(method: $method, status: $status, amountMinor: $amountMinor)';
}


}

/// @nodoc
abstract mixin class $OrderPaymentCopyWith<$Res>  {
  factory $OrderPaymentCopyWith(OrderPayment value, $Res Function(OrderPayment) _then) = _$OrderPaymentCopyWithImpl;
@useResult
$Res call({
 PaymentMethodKind method, PaymentStatusState status, int amountMinor
});




}
/// @nodoc
class _$OrderPaymentCopyWithImpl<$Res>
    implements $OrderPaymentCopyWith<$Res> {
  _$OrderPaymentCopyWithImpl(this._self, this._then);

  final OrderPayment _self;
  final $Res Function(OrderPayment) _then;

/// Create a copy of OrderPayment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? method = null,Object? status = null,Object? amountMinor = null,}) {
  return _then(OrderPayment(
method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethodKind,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatusState,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderPayment].
extension OrderPaymentPatterns on OrderPayment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderPayment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderPayment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderPayment value)  $default,){
final _that = this;
switch (_that) {
case _OrderPayment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderPayment value)?  $default,){
final _that = this;
switch (_that) {
case _OrderPayment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PaymentMethodKind method,  PaymentStatusState status,  int amountMinor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderPayment() when $default != null:
return $default(_that.method,_that.status,_that.amountMinor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PaymentMethodKind method,  PaymentStatusState status,  int amountMinor)  $default,) {final _that = this;
switch (_that) {
case _OrderPayment():
return $default(_that.method,_that.status,_that.amountMinor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PaymentMethodKind method,  PaymentStatusState status,  int amountMinor)?  $default,) {final _that = this;
switch (_that) {
case _OrderPayment() when $default != null:
return $default(_that.method,_that.status,_that.amountMinor);case _:
  return null;

}
}

}

/// @nodoc


class _OrderPayment implements OrderPayment {
  const _OrderPayment({required this.method, required this.status, required this.amountMinor});
  

@override final  PaymentMethodKind method;
@override final  PaymentStatusState status;
@override final  int amountMinor;

/// Create a copy of OrderPayment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderPaymentCopyWith<_OrderPayment> get copyWith => __$OrderPaymentCopyWithImpl<_OrderPayment>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderPayment&&(identical(other.method, method) || other.method == method)&&(identical(other.status, status) || other.status == status)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor));
}


@override
int get hashCode => Object.hash(runtimeType,method,status,amountMinor);

@override
String toString() {
  return 'OrderPayment(method: $method, status: $status, amountMinor: $amountMinor)';
}


}

/// @nodoc
abstract mixin class _$OrderPaymentCopyWith<$Res> implements $OrderPaymentCopyWith<$Res> {
  factory _$OrderPaymentCopyWith(_OrderPayment value, $Res Function(_OrderPayment) _then) = __$OrderPaymentCopyWithImpl;
@override @useResult
$Res call({
 PaymentMethodKind method, PaymentStatusState status, int amountMinor
});




}
/// @nodoc
class __$OrderPaymentCopyWithImpl<$Res>
    implements _$OrderPaymentCopyWith<$Res> {
  __$OrderPaymentCopyWithImpl(this._self, this._then);

  final _OrderPayment _self;
  final $Res Function(_OrderPayment) _then;

/// Create a copy of OrderPayment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? method = null,Object? status = null,Object? amountMinor = null,}) {
  return _then(_OrderPayment(
method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethodKind,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatusState,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
