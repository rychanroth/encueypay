// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'managed_business_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ManagedBusinessOrder {

 String get id; String get orderId; String get customerName; ManagedOrderStatus get status; int get subtotalMinor; int get discountMinor; DateTime get createdAt; List<ManagedOrderItem> get items; String? get rejectionReason;
/// Create a copy of ManagedBusinessOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ManagedBusinessOrderCopyWith<ManagedBusinessOrder> get copyWith => _$ManagedBusinessOrderCopyWithImpl<ManagedBusinessOrder>(this as ManagedBusinessOrder, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ManagedBusinessOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.status, status) || other.status == status)&&(identical(other.subtotalMinor, subtotalMinor) || other.subtotalMinor == subtotalMinor)&&(identical(other.discountMinor, discountMinor) || other.discountMinor == discountMinor)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason));
}


@override
int get hashCode => Object.hash(runtimeType,id,orderId,customerName,status,subtotalMinor,discountMinor,createdAt,const DeepCollectionEquality().hash(items),rejectionReason);

@override
String toString() {
  return 'ManagedBusinessOrder(id: $id, orderId: $orderId, customerName: $customerName, status: $status, subtotalMinor: $subtotalMinor, discountMinor: $discountMinor, createdAt: $createdAt, items: $items, rejectionReason: $rejectionReason)';
}


}

/// @nodoc
abstract mixin class $ManagedBusinessOrderCopyWith<$Res>  {
  factory $ManagedBusinessOrderCopyWith(ManagedBusinessOrder value, $Res Function(ManagedBusinessOrder) _then) = _$ManagedBusinessOrderCopyWithImpl;
@useResult
$Res call({
 String id, String orderId, String customerName, ManagedOrderStatus status, int subtotalMinor, int discountMinor, DateTime createdAt, List<ManagedOrderItem> items, String? rejectionReason
});




}
/// @nodoc
class _$ManagedBusinessOrderCopyWithImpl<$Res>
    implements $ManagedBusinessOrderCopyWith<$Res> {
  _$ManagedBusinessOrderCopyWithImpl(this._self, this._then);

  final ManagedBusinessOrder _self;
  final $Res Function(ManagedBusinessOrder) _then;

/// Create a copy of ManagedBusinessOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderId = null,Object? customerName = null,Object? status = null,Object? subtotalMinor = null,Object? discountMinor = null,Object? createdAt = null,Object? items = null,Object? rejectionReason = freezed,}) {
  return _then(ManagedBusinessOrder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ManagedOrderStatus,subtotalMinor: null == subtotalMinor ? _self.subtotalMinor : subtotalMinor // ignore: cast_nullable_to_non_nullable
as int,discountMinor: null == discountMinor ? _self.discountMinor : discountMinor // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ManagedOrderItem>,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ManagedBusinessOrder].
extension ManagedBusinessOrderPatterns on ManagedBusinessOrder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ManagedBusinessOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ManagedBusinessOrder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ManagedBusinessOrder value)  $default,){
final _that = this;
switch (_that) {
case _ManagedBusinessOrder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ManagedBusinessOrder value)?  $default,){
final _that = this;
switch (_that) {
case _ManagedBusinessOrder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orderId,  String customerName,  ManagedOrderStatus status,  int subtotalMinor,  int discountMinor,  DateTime createdAt,  List<ManagedOrderItem> items,  String? rejectionReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ManagedBusinessOrder() when $default != null:
return $default(_that.id,_that.orderId,_that.customerName,_that.status,_that.subtotalMinor,_that.discountMinor,_that.createdAt,_that.items,_that.rejectionReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orderId,  String customerName,  ManagedOrderStatus status,  int subtotalMinor,  int discountMinor,  DateTime createdAt,  List<ManagedOrderItem> items,  String? rejectionReason)  $default,) {final _that = this;
switch (_that) {
case _ManagedBusinessOrder():
return $default(_that.id,_that.orderId,_that.customerName,_that.status,_that.subtotalMinor,_that.discountMinor,_that.createdAt,_that.items,_that.rejectionReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orderId,  String customerName,  ManagedOrderStatus status,  int subtotalMinor,  int discountMinor,  DateTime createdAt,  List<ManagedOrderItem> items,  String? rejectionReason)?  $default,) {final _that = this;
switch (_that) {
case _ManagedBusinessOrder() when $default != null:
return $default(_that.id,_that.orderId,_that.customerName,_that.status,_that.subtotalMinor,_that.discountMinor,_that.createdAt,_that.items,_that.rejectionReason);case _:
  return null;

}
}

}

/// @nodoc


class _ManagedBusinessOrder extends ManagedBusinessOrder {
  const _ManagedBusinessOrder({required this.id, required this.orderId, required this.customerName, required this.status, required this.subtotalMinor, required this.discountMinor, required this.createdAt, required  List<ManagedOrderItem> items, this.rejectionReason}): _items = items,super._();
  

@override final  String id;
@override final  String orderId;
@override final  String customerName;
@override final  ManagedOrderStatus status;
@override final  int subtotalMinor;
@override final  int discountMinor;
@override final  DateTime createdAt;
 final  List<ManagedOrderItem> _items;
@override List<ManagedOrderItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  String? rejectionReason;

/// Create a copy of ManagedBusinessOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ManagedBusinessOrderCopyWith<_ManagedBusinessOrder> get copyWith => __$ManagedBusinessOrderCopyWithImpl<_ManagedBusinessOrder>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ManagedBusinessOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.status, status) || other.status == status)&&(identical(other.subtotalMinor, subtotalMinor) || other.subtotalMinor == subtotalMinor)&&(identical(other.discountMinor, discountMinor) || other.discountMinor == discountMinor)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason));
}


@override
int get hashCode => Object.hash(runtimeType,id,orderId,customerName,status,subtotalMinor,discountMinor,createdAt,const DeepCollectionEquality().hash(_items),rejectionReason);

@override
String toString() {
  return 'ManagedBusinessOrder(id: $id, orderId: $orderId, customerName: $customerName, status: $status, subtotalMinor: $subtotalMinor, discountMinor: $discountMinor, createdAt: $createdAt, items: $items, rejectionReason: $rejectionReason)';
}


}

/// @nodoc
abstract mixin class _$ManagedBusinessOrderCopyWith<$Res> implements $ManagedBusinessOrderCopyWith<$Res> {
  factory _$ManagedBusinessOrderCopyWith(_ManagedBusinessOrder value, $Res Function(_ManagedBusinessOrder) _then) = __$ManagedBusinessOrderCopyWithImpl;
@override @useResult
$Res call({
 String id, String orderId, String customerName, ManagedOrderStatus status, int subtotalMinor, int discountMinor, DateTime createdAt, List<ManagedOrderItem> items, String? rejectionReason
});




}
/// @nodoc
class __$ManagedBusinessOrderCopyWithImpl<$Res>
    implements _$ManagedBusinessOrderCopyWith<$Res> {
  __$ManagedBusinessOrderCopyWithImpl(this._self, this._then);

  final _ManagedBusinessOrder _self;
  final $Res Function(_ManagedBusinessOrder) _then;

/// Create a copy of ManagedBusinessOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderId = null,Object? customerName = null,Object? status = null,Object? subtotalMinor = null,Object? discountMinor = null,Object? createdAt = null,Object? items = null,Object? rejectionReason = freezed,}) {
  return _then(_ManagedBusinessOrder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ManagedOrderStatus,subtotalMinor: null == subtotalMinor ? _self.subtotalMinor : subtotalMinor // ignore: cast_nullable_to_non_nullable
as int,discountMinor: null == discountMinor ? _self.discountMinor : discountMinor // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ManagedOrderItem>,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ManagedOrderItem {

 String get id; String get productName; int get quantity; int get lineTotalMinor; String? get variantName;
/// Create a copy of ManagedOrderItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ManagedOrderItemCopyWith<ManagedOrderItem> get copyWith => _$ManagedOrderItemCopyWithImpl<ManagedOrderItem>(this as ManagedOrderItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ManagedOrderItem&&(identical(other.id, id) || other.id == id)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.lineTotalMinor, lineTotalMinor) || other.lineTotalMinor == lineTotalMinor)&&(identical(other.variantName, variantName) || other.variantName == variantName));
}


@override
int get hashCode => Object.hash(runtimeType,id,productName,quantity,lineTotalMinor,variantName);

@override
String toString() {
  return 'ManagedOrderItem(id: $id, productName: $productName, quantity: $quantity, lineTotalMinor: $lineTotalMinor, variantName: $variantName)';
}


}

/// @nodoc
abstract mixin class $ManagedOrderItemCopyWith<$Res>  {
  factory $ManagedOrderItemCopyWith(ManagedOrderItem value, $Res Function(ManagedOrderItem) _then) = _$ManagedOrderItemCopyWithImpl;
@useResult
$Res call({
 String id, String productName, int quantity, int lineTotalMinor, String? variantName
});




}
/// @nodoc
class _$ManagedOrderItemCopyWithImpl<$Res>
    implements $ManagedOrderItemCopyWith<$Res> {
  _$ManagedOrderItemCopyWithImpl(this._self, this._then);

  final ManagedOrderItem _self;
  final $Res Function(ManagedOrderItem) _then;

/// Create a copy of ManagedOrderItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productName = null,Object? quantity = null,Object? lineTotalMinor = null,Object? variantName = freezed,}) {
  return _then(ManagedOrderItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,lineTotalMinor: null == lineTotalMinor ? _self.lineTotalMinor : lineTotalMinor // ignore: cast_nullable_to_non_nullable
as int,variantName: freezed == variantName ? _self.variantName : variantName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ManagedOrderItem].
extension ManagedOrderItemPatterns on ManagedOrderItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ManagedOrderItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ManagedOrderItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ManagedOrderItem value)  $default,){
final _that = this;
switch (_that) {
case _ManagedOrderItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ManagedOrderItem value)?  $default,){
final _that = this;
switch (_that) {
case _ManagedOrderItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String productName,  int quantity,  int lineTotalMinor,  String? variantName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ManagedOrderItem() when $default != null:
return $default(_that.id,_that.productName,_that.quantity,_that.lineTotalMinor,_that.variantName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String productName,  int quantity,  int lineTotalMinor,  String? variantName)  $default,) {final _that = this;
switch (_that) {
case _ManagedOrderItem():
return $default(_that.id,_that.productName,_that.quantity,_that.lineTotalMinor,_that.variantName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String productName,  int quantity,  int lineTotalMinor,  String? variantName)?  $default,) {final _that = this;
switch (_that) {
case _ManagedOrderItem() when $default != null:
return $default(_that.id,_that.productName,_that.quantity,_that.lineTotalMinor,_that.variantName);case _:
  return null;

}
}

}

/// @nodoc


class _ManagedOrderItem implements ManagedOrderItem {
  const _ManagedOrderItem({required this.id, required this.productName, required this.quantity, required this.lineTotalMinor, this.variantName});
  

@override final  String id;
@override final  String productName;
@override final  int quantity;
@override final  int lineTotalMinor;
@override final  String? variantName;

/// Create a copy of ManagedOrderItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ManagedOrderItemCopyWith<_ManagedOrderItem> get copyWith => __$ManagedOrderItemCopyWithImpl<_ManagedOrderItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ManagedOrderItem&&(identical(other.id, id) || other.id == id)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.lineTotalMinor, lineTotalMinor) || other.lineTotalMinor == lineTotalMinor)&&(identical(other.variantName, variantName) || other.variantName == variantName));
}


@override
int get hashCode => Object.hash(runtimeType,id,productName,quantity,lineTotalMinor,variantName);

@override
String toString() {
  return 'ManagedOrderItem(id: $id, productName: $productName, quantity: $quantity, lineTotalMinor: $lineTotalMinor, variantName: $variantName)';
}


}

/// @nodoc
abstract mixin class _$ManagedOrderItemCopyWith<$Res> implements $ManagedOrderItemCopyWith<$Res> {
  factory _$ManagedOrderItemCopyWith(_ManagedOrderItem value, $Res Function(_ManagedOrderItem) _then) = __$ManagedOrderItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String productName, int quantity, int lineTotalMinor, String? variantName
});




}
/// @nodoc
class __$ManagedOrderItemCopyWithImpl<$Res>
    implements _$ManagedOrderItemCopyWith<$Res> {
  __$ManagedOrderItemCopyWithImpl(this._self, this._then);

  final _ManagedOrderItem _self;
  final $Res Function(_ManagedOrderItem) _then;

/// Create a copy of ManagedOrderItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productName = null,Object? quantity = null,Object? lineTotalMinor = null,Object? variantName = freezed,}) {
  return _then(_ManagedOrderItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,lineTotalMinor: null == lineTotalMinor ? _self.lineTotalMinor : lineTotalMinor // ignore: cast_nullable_to_non_nullable
as int,variantName: freezed == variantName ? _self.variantName : variantName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
