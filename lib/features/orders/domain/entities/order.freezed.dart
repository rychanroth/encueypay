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

 String get id; DateTime get createdAt; int get subtotalMinor; int get discountMinor; int get deliveryFeeMinor; int get totalMinor; String get shippingRecipientName; String get shippingPhone; String get shippingLine1; String? get shippingLine2; String get shippingCity; List<OrderBusinessPart> get businessParts; OrderPayment? get payment; OrderDelivery? get delivery;
/// Create a copy of CustomerOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerOrderCopyWith<CustomerOrder> get copyWith => _$CustomerOrderCopyWithImpl<CustomerOrder>(this as CustomerOrder, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.subtotalMinor, subtotalMinor) || other.subtotalMinor == subtotalMinor)&&(identical(other.discountMinor, discountMinor) || other.discountMinor == discountMinor)&&(identical(other.deliveryFeeMinor, deliveryFeeMinor) || other.deliveryFeeMinor == deliveryFeeMinor)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor)&&(identical(other.shippingRecipientName, shippingRecipientName) || other.shippingRecipientName == shippingRecipientName)&&(identical(other.shippingPhone, shippingPhone) || other.shippingPhone == shippingPhone)&&(identical(other.shippingLine1, shippingLine1) || other.shippingLine1 == shippingLine1)&&(identical(other.shippingLine2, shippingLine2) || other.shippingLine2 == shippingLine2)&&(identical(other.shippingCity, shippingCity) || other.shippingCity == shippingCity)&&const DeepCollectionEquality().equals(other.businessParts, businessParts)&&(identical(other.payment, payment) || other.payment == payment)&&(identical(other.delivery, delivery) || other.delivery == delivery));
}


@override
int get hashCode => Object.hash(runtimeType,id,createdAt,subtotalMinor,discountMinor,deliveryFeeMinor,totalMinor,shippingRecipientName,shippingPhone,shippingLine1,shippingLine2,shippingCity,const DeepCollectionEquality().hash(businessParts),payment,delivery);

@override
String toString() {
  return 'CustomerOrder(id: $id, createdAt: $createdAt, subtotalMinor: $subtotalMinor, discountMinor: $discountMinor, deliveryFeeMinor: $deliveryFeeMinor, totalMinor: $totalMinor, shippingRecipientName: $shippingRecipientName, shippingPhone: $shippingPhone, shippingLine1: $shippingLine1, shippingLine2: $shippingLine2, shippingCity: $shippingCity, businessParts: $businessParts, payment: $payment, delivery: $delivery)';
}


}

/// @nodoc
abstract mixin class $CustomerOrderCopyWith<$Res>  {
  factory $CustomerOrderCopyWith(CustomerOrder value, $Res Function(CustomerOrder) _then) = _$CustomerOrderCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, int subtotalMinor, int discountMinor, int deliveryFeeMinor, int totalMinor, String shippingRecipientName, String shippingPhone, String shippingLine1, String? shippingLine2, String shippingCity, List<OrderBusinessPart> businessParts, OrderPayment? payment, OrderDelivery? delivery
});


$OrderPaymentCopyWith<$Res>? get payment;$OrderDeliveryCopyWith<$Res>? get delivery;

}
/// @nodoc
class _$CustomerOrderCopyWithImpl<$Res>
    implements $CustomerOrderCopyWith<$Res> {
  _$CustomerOrderCopyWithImpl(this._self, this._then);

  final CustomerOrder _self;
  final $Res Function(CustomerOrder) _then;

/// Create a copy of CustomerOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? subtotalMinor = null,Object? discountMinor = null,Object? deliveryFeeMinor = null,Object? totalMinor = null,Object? shippingRecipientName = null,Object? shippingPhone = null,Object? shippingLine1 = null,Object? shippingLine2 = freezed,Object? shippingCity = null,Object? businessParts = null,Object? payment = freezed,Object? delivery = freezed,}) {
  return _then(CustomerOrder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,subtotalMinor: null == subtotalMinor ? _self.subtotalMinor : subtotalMinor // ignore: cast_nullable_to_non_nullable
as int,discountMinor: null == discountMinor ? _self.discountMinor : discountMinor // ignore: cast_nullable_to_non_nullable
as int,deliveryFeeMinor: null == deliveryFeeMinor ? _self.deliveryFeeMinor : deliveryFeeMinor // ignore: cast_nullable_to_non_nullable
as int,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,shippingRecipientName: null == shippingRecipientName ? _self.shippingRecipientName : shippingRecipientName // ignore: cast_nullable_to_non_nullable
as String,shippingPhone: null == shippingPhone ? _self.shippingPhone : shippingPhone // ignore: cast_nullable_to_non_nullable
as String,shippingLine1: null == shippingLine1 ? _self.shippingLine1 : shippingLine1 // ignore: cast_nullable_to_non_nullable
as String,shippingLine2: freezed == shippingLine2 ? _self.shippingLine2 : shippingLine2 // ignore: cast_nullable_to_non_nullable
as String?,shippingCity: null == shippingCity ? _self.shippingCity : shippingCity // ignore: cast_nullable_to_non_nullable
as String,businessParts: null == businessParts ? _self.businessParts : businessParts // ignore: cast_nullable_to_non_nullable
as List<OrderBusinessPart>,payment: freezed == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as OrderPayment?,delivery: freezed == delivery ? _self.delivery : delivery // ignore: cast_nullable_to_non_nullable
as OrderDelivery?,
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
}/// Create a copy of CustomerOrder
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderDeliveryCopyWith<$Res>? get delivery {
    if (_self.delivery == null) {
    return null;
  }

  return $OrderDeliveryCopyWith<$Res>(_self.delivery!, (value) {
    return _then(_self.copyWith(delivery: value));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  int subtotalMinor,  int discountMinor,  int deliveryFeeMinor,  int totalMinor,  String shippingRecipientName,  String shippingPhone,  String shippingLine1,  String? shippingLine2,  String shippingCity,  List<OrderBusinessPart> businessParts,  OrderPayment? payment,  OrderDelivery? delivery)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerOrder() when $default != null:
return $default(_that.id,_that.createdAt,_that.subtotalMinor,_that.discountMinor,_that.deliveryFeeMinor,_that.totalMinor,_that.shippingRecipientName,_that.shippingPhone,_that.shippingLine1,_that.shippingLine2,_that.shippingCity,_that.businessParts,_that.payment,_that.delivery);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  int subtotalMinor,  int discountMinor,  int deliveryFeeMinor,  int totalMinor,  String shippingRecipientName,  String shippingPhone,  String shippingLine1,  String? shippingLine2,  String shippingCity,  List<OrderBusinessPart> businessParts,  OrderPayment? payment,  OrderDelivery? delivery)  $default,) {final _that = this;
switch (_that) {
case _CustomerOrder():
return $default(_that.id,_that.createdAt,_that.subtotalMinor,_that.discountMinor,_that.deliveryFeeMinor,_that.totalMinor,_that.shippingRecipientName,_that.shippingPhone,_that.shippingLine1,_that.shippingLine2,_that.shippingCity,_that.businessParts,_that.payment,_that.delivery);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime createdAt,  int subtotalMinor,  int discountMinor,  int deliveryFeeMinor,  int totalMinor,  String shippingRecipientName,  String shippingPhone,  String shippingLine1,  String? shippingLine2,  String shippingCity,  List<OrderBusinessPart> businessParts,  OrderPayment? payment,  OrderDelivery? delivery)?  $default,) {final _that = this;
switch (_that) {
case _CustomerOrder() when $default != null:
return $default(_that.id,_that.createdAt,_that.subtotalMinor,_that.discountMinor,_that.deliveryFeeMinor,_that.totalMinor,_that.shippingRecipientName,_that.shippingPhone,_that.shippingLine1,_that.shippingLine2,_that.shippingCity,_that.businessParts,_that.payment,_that.delivery);case _:
  return null;

}
}

}

/// @nodoc


class _CustomerOrder extends CustomerOrder {
  const _CustomerOrder({required this.id, required this.createdAt, required this.subtotalMinor, required this.discountMinor, required this.deliveryFeeMinor, required this.totalMinor, required this.shippingRecipientName, this.shippingPhone = '', required this.shippingLine1, this.shippingLine2, required this.shippingCity, required  List<OrderBusinessPart> businessParts, this.payment, this.delivery}): _businessParts = businessParts,super._();
  

@override final  String id;
@override final  DateTime createdAt;
@override final  int subtotalMinor;
@override final  int discountMinor;
@override final  int deliveryFeeMinor;
@override final  int totalMinor;
@override final  String shippingRecipientName;
@override@JsonKey() final  String shippingPhone;
@override final  String shippingLine1;
@override final  String? shippingLine2;
@override final  String shippingCity;
 final  List<OrderBusinessPart> _businessParts;
@override List<OrderBusinessPart> get businessParts {
  if (_businessParts is EqualUnmodifiableListView) return _businessParts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_businessParts);
}

@override final  OrderPayment? payment;
@override final  OrderDelivery? delivery;

/// Create a copy of CustomerOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerOrderCopyWith<_CustomerOrder> get copyWith => __$CustomerOrderCopyWithImpl<_CustomerOrder>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.subtotalMinor, subtotalMinor) || other.subtotalMinor == subtotalMinor)&&(identical(other.discountMinor, discountMinor) || other.discountMinor == discountMinor)&&(identical(other.deliveryFeeMinor, deliveryFeeMinor) || other.deliveryFeeMinor == deliveryFeeMinor)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor)&&(identical(other.shippingRecipientName, shippingRecipientName) || other.shippingRecipientName == shippingRecipientName)&&(identical(other.shippingPhone, shippingPhone) || other.shippingPhone == shippingPhone)&&(identical(other.shippingLine1, shippingLine1) || other.shippingLine1 == shippingLine1)&&(identical(other.shippingLine2, shippingLine2) || other.shippingLine2 == shippingLine2)&&(identical(other.shippingCity, shippingCity) || other.shippingCity == shippingCity)&&const DeepCollectionEquality().equals(other._businessParts, _businessParts)&&(identical(other.payment, payment) || other.payment == payment)&&(identical(other.delivery, delivery) || other.delivery == delivery));
}


@override
int get hashCode => Object.hash(runtimeType,id,createdAt,subtotalMinor,discountMinor,deliveryFeeMinor,totalMinor,shippingRecipientName,shippingPhone,shippingLine1,shippingLine2,shippingCity,const DeepCollectionEquality().hash(_businessParts),payment,delivery);

@override
String toString() {
  return 'CustomerOrder(id: $id, createdAt: $createdAt, subtotalMinor: $subtotalMinor, discountMinor: $discountMinor, deliveryFeeMinor: $deliveryFeeMinor, totalMinor: $totalMinor, shippingRecipientName: $shippingRecipientName, shippingPhone: $shippingPhone, shippingLine1: $shippingLine1, shippingLine2: $shippingLine2, shippingCity: $shippingCity, businessParts: $businessParts, payment: $payment, delivery: $delivery)';
}


}

/// @nodoc
abstract mixin class _$CustomerOrderCopyWith<$Res> implements $CustomerOrderCopyWith<$Res> {
  factory _$CustomerOrderCopyWith(_CustomerOrder value, $Res Function(_CustomerOrder) _then) = __$CustomerOrderCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime createdAt, int subtotalMinor, int discountMinor, int deliveryFeeMinor, int totalMinor, String shippingRecipientName, String shippingPhone, String shippingLine1, String? shippingLine2, String shippingCity, List<OrderBusinessPart> businessParts, OrderPayment? payment, OrderDelivery? delivery
});


@override $OrderPaymentCopyWith<$Res>? get payment;@override $OrderDeliveryCopyWith<$Res>? get delivery;

}
/// @nodoc
class __$CustomerOrderCopyWithImpl<$Res>
    implements _$CustomerOrderCopyWith<$Res> {
  __$CustomerOrderCopyWithImpl(this._self, this._then);

  final _CustomerOrder _self;
  final $Res Function(_CustomerOrder) _then;

/// Create a copy of CustomerOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = null,Object? subtotalMinor = null,Object? discountMinor = null,Object? deliveryFeeMinor = null,Object? totalMinor = null,Object? shippingRecipientName = null,Object? shippingPhone = null,Object? shippingLine1 = null,Object? shippingLine2 = freezed,Object? shippingCity = null,Object? businessParts = null,Object? payment = freezed,Object? delivery = freezed,}) {
  return _then(_CustomerOrder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,subtotalMinor: null == subtotalMinor ? _self.subtotalMinor : subtotalMinor // ignore: cast_nullable_to_non_nullable
as int,discountMinor: null == discountMinor ? _self.discountMinor : discountMinor // ignore: cast_nullable_to_non_nullable
as int,deliveryFeeMinor: null == deliveryFeeMinor ? _self.deliveryFeeMinor : deliveryFeeMinor // ignore: cast_nullable_to_non_nullable
as int,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,shippingRecipientName: null == shippingRecipientName ? _self.shippingRecipientName : shippingRecipientName // ignore: cast_nullable_to_non_nullable
as String,shippingPhone: null == shippingPhone ? _self.shippingPhone : shippingPhone // ignore: cast_nullable_to_non_nullable
as String,shippingLine1: null == shippingLine1 ? _self.shippingLine1 : shippingLine1 // ignore: cast_nullable_to_non_nullable
as String,shippingLine2: freezed == shippingLine2 ? _self.shippingLine2 : shippingLine2 // ignore: cast_nullable_to_non_nullable
as String?,shippingCity: null == shippingCity ? _self.shippingCity : shippingCity // ignore: cast_nullable_to_non_nullable
as String,businessParts: null == businessParts ? _self._businessParts : businessParts // ignore: cast_nullable_to_non_nullable
as List<OrderBusinessPart>,payment: freezed == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as OrderPayment?,delivery: freezed == delivery ? _self.delivery : delivery // ignore: cast_nullable_to_non_nullable
as OrderDelivery?,
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
}/// Create a copy of CustomerOrder
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderDeliveryCopyWith<$Res>? get delivery {
    if (_self.delivery == null) {
    return null;
  }

  return $OrderDeliveryCopyWith<$Res>(_self.delivery!, (value) {
    return _then(_self.copyWith(delivery: value));
  });
}
}

/// @nodoc
mixin _$OrderBusinessPart {

 String get id; String get businessId; String get businessName; BusinessOrderStatus get status; List<OrderItemSnapshot> get items; PickupStopInfo? get pickupStop; String? get rejectionReason;
/// Create a copy of OrderBusinessPart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderBusinessPartCopyWith<OrderBusinessPart> get copyWith => _$OrderBusinessPartCopyWithImpl<OrderBusinessPart>(this as OrderBusinessPart, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderBusinessPart&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.businessName, businessName) || other.businessName == businessName)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.pickupStop, pickupStop) || other.pickupStop == pickupStop)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason));
}


@override
int get hashCode => Object.hash(runtimeType,id,businessId,businessName,status,const DeepCollectionEquality().hash(items),pickupStop,rejectionReason);

@override
String toString() {
  return 'OrderBusinessPart(id: $id, businessId: $businessId, businessName: $businessName, status: $status, items: $items, pickupStop: $pickupStop, rejectionReason: $rejectionReason)';
}


}

/// @nodoc
abstract mixin class $OrderBusinessPartCopyWith<$Res>  {
  factory $OrderBusinessPartCopyWith(OrderBusinessPart value, $Res Function(OrderBusinessPart) _then) = _$OrderBusinessPartCopyWithImpl;
@useResult
$Res call({
 String id, String businessId, String businessName, BusinessOrderStatus status, List<OrderItemSnapshot> items, PickupStopInfo? pickupStop, String? rejectionReason
});


$PickupStopInfoCopyWith<$Res>? get pickupStop;

}
/// @nodoc
class _$OrderBusinessPartCopyWithImpl<$Res>
    implements $OrderBusinessPartCopyWith<$Res> {
  _$OrderBusinessPartCopyWithImpl(this._self, this._then);

  final OrderBusinessPart _self;
  final $Res Function(OrderBusinessPart) _then;

/// Create a copy of OrderBusinessPart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? businessName = null,Object? status = null,Object? items = null,Object? pickupStop = freezed,Object? rejectionReason = freezed,}) {
  return _then(OrderBusinessPart(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,businessName: null == businessName ? _self.businessName : businessName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BusinessOrderStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItemSnapshot>,pickupStop: freezed == pickupStop ? _self.pickupStop : pickupStop // ignore: cast_nullable_to_non_nullable
as PickupStopInfo?,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of OrderBusinessPart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PickupStopInfoCopyWith<$Res>? get pickupStop {
    if (_self.pickupStop == null) {
    return null;
  }

  return $PickupStopInfoCopyWith<$Res>(_self.pickupStop!, (value) {
    return _then(_self.copyWith(pickupStop: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrderBusinessPart].
extension OrderBusinessPartPatterns on OrderBusinessPart {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderBusinessPart value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderBusinessPart() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderBusinessPart value)  $default,){
final _that = this;
switch (_that) {
case _OrderBusinessPart():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderBusinessPart value)?  $default,){
final _that = this;
switch (_that) {
case _OrderBusinessPart() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String businessId,  String businessName,  BusinessOrderStatus status,  List<OrderItemSnapshot> items,  PickupStopInfo? pickupStop,  String? rejectionReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderBusinessPart() when $default != null:
return $default(_that.id,_that.businessId,_that.businessName,_that.status,_that.items,_that.pickupStop,_that.rejectionReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String businessId,  String businessName,  BusinessOrderStatus status,  List<OrderItemSnapshot> items,  PickupStopInfo? pickupStop,  String? rejectionReason)  $default,) {final _that = this;
switch (_that) {
case _OrderBusinessPart():
return $default(_that.id,_that.businessId,_that.businessName,_that.status,_that.items,_that.pickupStop,_that.rejectionReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String businessId,  String businessName,  BusinessOrderStatus status,  List<OrderItemSnapshot> items,  PickupStopInfo? pickupStop,  String? rejectionReason)?  $default,) {final _that = this;
switch (_that) {
case _OrderBusinessPart() when $default != null:
return $default(_that.id,_that.businessId,_that.businessName,_that.status,_that.items,_that.pickupStop,_that.rejectionReason);case _:
  return null;

}
}

}

/// @nodoc


class _OrderBusinessPart implements OrderBusinessPart {
  const _OrderBusinessPart({required this.id, required this.businessId, required this.businessName, required this.status, required  List<OrderItemSnapshot> items, required this.pickupStop, this.rejectionReason}): _items = items;
  

@override final  String id;
@override final  String businessId;
@override final  String businessName;
@override final  BusinessOrderStatus status;
 final  List<OrderItemSnapshot> _items;
@override List<OrderItemSnapshot> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  PickupStopInfo? pickupStop;
@override final  String? rejectionReason;

/// Create a copy of OrderBusinessPart
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderBusinessPartCopyWith<_OrderBusinessPart> get copyWith => __$OrderBusinessPartCopyWithImpl<_OrderBusinessPart>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderBusinessPart&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.businessName, businessName) || other.businessName == businessName)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.pickupStop, pickupStop) || other.pickupStop == pickupStop)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason));
}


@override
int get hashCode => Object.hash(runtimeType,id,businessId,businessName,status,const DeepCollectionEquality().hash(_items),pickupStop,rejectionReason);

@override
String toString() {
  return 'OrderBusinessPart(id: $id, businessId: $businessId, businessName: $businessName, status: $status, items: $items, pickupStop: $pickupStop, rejectionReason: $rejectionReason)';
}


}

/// @nodoc
abstract mixin class _$OrderBusinessPartCopyWith<$Res> implements $OrderBusinessPartCopyWith<$Res> {
  factory _$OrderBusinessPartCopyWith(_OrderBusinessPart value, $Res Function(_OrderBusinessPart) _then) = __$OrderBusinessPartCopyWithImpl;
@override @useResult
$Res call({
 String id, String businessId, String businessName, BusinessOrderStatus status, List<OrderItemSnapshot> items, PickupStopInfo? pickupStop, String? rejectionReason
});


@override $PickupStopInfoCopyWith<$Res>? get pickupStop;

}
/// @nodoc
class __$OrderBusinessPartCopyWithImpl<$Res>
    implements _$OrderBusinessPartCopyWith<$Res> {
  __$OrderBusinessPartCopyWithImpl(this._self, this._then);

  final _OrderBusinessPart _self;
  final $Res Function(_OrderBusinessPart) _then;

/// Create a copy of OrderBusinessPart
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? businessName = null,Object? status = null,Object? items = null,Object? pickupStop = freezed,Object? rejectionReason = freezed,}) {
  return _then(_OrderBusinessPart(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,businessName: null == businessName ? _self.businessName : businessName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BusinessOrderStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItemSnapshot>,pickupStop: freezed == pickupStop ? _self.pickupStop : pickupStop // ignore: cast_nullable_to_non_nullable
as PickupStopInfo?,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of OrderBusinessPart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PickupStopInfoCopyWith<$Res>? get pickupStop {
    if (_self.pickupStop == null) {
    return null;
  }

  return $PickupStopInfoCopyWith<$Res>(_self.pickupStop!, (value) {
    return _then(_self.copyWith(pickupStop: value));
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

/// @nodoc
mixin _$OrderDelivery {

 DeliveryState get status;
/// Create a copy of OrderDelivery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderDeliveryCopyWith<OrderDelivery> get copyWith => _$OrderDeliveryCopyWithImpl<OrderDelivery>(this as OrderDelivery, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderDelivery&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,status);

@override
String toString() {
  return 'OrderDelivery(status: $status)';
}


}

/// @nodoc
abstract mixin class $OrderDeliveryCopyWith<$Res>  {
  factory $OrderDeliveryCopyWith(OrderDelivery value, $Res Function(OrderDelivery) _then) = _$OrderDeliveryCopyWithImpl;
@useResult
$Res call({
 DeliveryState status
});




}
/// @nodoc
class _$OrderDeliveryCopyWithImpl<$Res>
    implements $OrderDeliveryCopyWith<$Res> {
  _$OrderDeliveryCopyWithImpl(this._self, this._then);

  final OrderDelivery _self;
  final $Res Function(OrderDelivery) _then;

/// Create a copy of OrderDelivery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,}) {
  return _then(OrderDelivery(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DeliveryState,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderDelivery].
extension OrderDeliveryPatterns on OrderDelivery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderDelivery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderDelivery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderDelivery value)  $default,){
final _that = this;
switch (_that) {
case _OrderDelivery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderDelivery value)?  $default,){
final _that = this;
switch (_that) {
case _OrderDelivery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DeliveryState status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderDelivery() when $default != null:
return $default(_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DeliveryState status)  $default,) {final _that = this;
switch (_that) {
case _OrderDelivery():
return $default(_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DeliveryState status)?  $default,) {final _that = this;
switch (_that) {
case _OrderDelivery() when $default != null:
return $default(_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _OrderDelivery implements OrderDelivery {
  const _OrderDelivery({required this.status});
  

@override final  DeliveryState status;

/// Create a copy of OrderDelivery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderDeliveryCopyWith<_OrderDelivery> get copyWith => __$OrderDeliveryCopyWithImpl<_OrderDelivery>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderDelivery&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,status);

@override
String toString() {
  return 'OrderDelivery(status: $status)';
}


}

/// @nodoc
abstract mixin class _$OrderDeliveryCopyWith<$Res> implements $OrderDeliveryCopyWith<$Res> {
  factory _$OrderDeliveryCopyWith(_OrderDelivery value, $Res Function(_OrderDelivery) _then) = __$OrderDeliveryCopyWithImpl;
@override @useResult
$Res call({
 DeliveryState status
});




}
/// @nodoc
class __$OrderDeliveryCopyWithImpl<$Res>
    implements _$OrderDeliveryCopyWith<$Res> {
  __$OrderDeliveryCopyWithImpl(this._self, this._then);

  final _OrderDelivery _self;
  final $Res Function(_OrderDelivery) _then;

/// Create a copy of OrderDelivery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,}) {
  return _then(_OrderDelivery(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DeliveryState,
  ));
}


}

/// @nodoc
mixin _$PickupStopInfo {

 String get id; int get sequence; PickupStopState get status;
/// Create a copy of PickupStopInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PickupStopInfoCopyWith<PickupStopInfo> get copyWith => _$PickupStopInfoCopyWithImpl<PickupStopInfo>(this as PickupStopInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PickupStopInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,sequence,status);

@override
String toString() {
  return 'PickupStopInfo(id: $id, sequence: $sequence, status: $status)';
}


}

/// @nodoc
abstract mixin class $PickupStopInfoCopyWith<$Res>  {
  factory $PickupStopInfoCopyWith(PickupStopInfo value, $Res Function(PickupStopInfo) _then) = _$PickupStopInfoCopyWithImpl;
@useResult
$Res call({
 String id, int sequence, PickupStopState status
});




}
/// @nodoc
class _$PickupStopInfoCopyWithImpl<$Res>
    implements $PickupStopInfoCopyWith<$Res> {
  _$PickupStopInfoCopyWithImpl(this._self, this._then);

  final PickupStopInfo _self;
  final $Res Function(PickupStopInfo) _then;

/// Create a copy of PickupStopInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sequence = null,Object? status = null,}) {
  return _then(PickupStopInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PickupStopState,
  ));
}

}


/// Adds pattern-matching-related methods to [PickupStopInfo].
extension PickupStopInfoPatterns on PickupStopInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PickupStopInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PickupStopInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PickupStopInfo value)  $default,){
final _that = this;
switch (_that) {
case _PickupStopInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PickupStopInfo value)?  $default,){
final _that = this;
switch (_that) {
case _PickupStopInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int sequence,  PickupStopState status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PickupStopInfo() when $default != null:
return $default(_that.id,_that.sequence,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int sequence,  PickupStopState status)  $default,) {final _that = this;
switch (_that) {
case _PickupStopInfo():
return $default(_that.id,_that.sequence,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int sequence,  PickupStopState status)?  $default,) {final _that = this;
switch (_that) {
case _PickupStopInfo() when $default != null:
return $default(_that.id,_that.sequence,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _PickupStopInfo implements PickupStopInfo {
  const _PickupStopInfo({required this.id, required this.sequence, required this.status});
  

@override final  String id;
@override final  int sequence;
@override final  PickupStopState status;

/// Create a copy of PickupStopInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PickupStopInfoCopyWith<_PickupStopInfo> get copyWith => __$PickupStopInfoCopyWithImpl<_PickupStopInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PickupStopInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,sequence,status);

@override
String toString() {
  return 'PickupStopInfo(id: $id, sequence: $sequence, status: $status)';
}


}

/// @nodoc
abstract mixin class _$PickupStopInfoCopyWith<$Res> implements $PickupStopInfoCopyWith<$Res> {
  factory _$PickupStopInfoCopyWith(_PickupStopInfo value, $Res Function(_PickupStopInfo) _then) = __$PickupStopInfoCopyWithImpl;
@override @useResult
$Res call({
 String id, int sequence, PickupStopState status
});




}
/// @nodoc
class __$PickupStopInfoCopyWithImpl<$Res>
    implements _$PickupStopInfoCopyWith<$Res> {
  __$PickupStopInfoCopyWithImpl(this._self, this._then);

  final _PickupStopInfo _self;
  final $Res Function(_PickupStopInfo) _then;

/// Create a copy of PickupStopInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sequence = null,Object? status = null,}) {
  return _then(_PickupStopInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PickupStopState,
  ));
}


}

// dart format on
