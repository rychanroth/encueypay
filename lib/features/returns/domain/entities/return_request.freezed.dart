// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'return_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReturnRequest {

 String get id; String get orderId; ReturnStatus get status; DateTime get createdAt; List<ReturnItemInfo> get items;
/// Create a copy of ReturnRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReturnRequestCopyWith<ReturnRequest> get copyWith => _$ReturnRequestCopyWithImpl<ReturnRequest>(this as ReturnRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReturnRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.items, items));
}


@override
int get hashCode => Object.hash(runtimeType,id,orderId,status,createdAt,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'ReturnRequest(id: $id, orderId: $orderId, status: $status, createdAt: $createdAt, items: $items)';
}


}

/// @nodoc
abstract mixin class $ReturnRequestCopyWith<$Res>  {
  factory $ReturnRequestCopyWith(ReturnRequest value, $Res Function(ReturnRequest) _then) = _$ReturnRequestCopyWithImpl;
@useResult
$Res call({
 String id, String orderId, ReturnStatus status, DateTime createdAt, List<ReturnItemInfo> items
});




}
/// @nodoc
class _$ReturnRequestCopyWithImpl<$Res>
    implements $ReturnRequestCopyWith<$Res> {
  _$ReturnRequestCopyWithImpl(this._self, this._then);

  final ReturnRequest _self;
  final $Res Function(ReturnRequest) _then;

/// Create a copy of ReturnRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderId = null,Object? status = null,Object? createdAt = null,Object? items = null,}) {
  return _then(ReturnRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReturnStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ReturnItemInfo>,
  ));
}

}


/// Adds pattern-matching-related methods to [ReturnRequest].
extension ReturnRequestPatterns on ReturnRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReturnRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReturnRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReturnRequest value)  $default,){
final _that = this;
switch (_that) {
case _ReturnRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReturnRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ReturnRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orderId,  ReturnStatus status,  DateTime createdAt,  List<ReturnItemInfo> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReturnRequest() when $default != null:
return $default(_that.id,_that.orderId,_that.status,_that.createdAt,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orderId,  ReturnStatus status,  DateTime createdAt,  List<ReturnItemInfo> items)  $default,) {final _that = this;
switch (_that) {
case _ReturnRequest():
return $default(_that.id,_that.orderId,_that.status,_that.createdAt,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orderId,  ReturnStatus status,  DateTime createdAt,  List<ReturnItemInfo> items)?  $default,) {final _that = this;
switch (_that) {
case _ReturnRequest() when $default != null:
return $default(_that.id,_that.orderId,_that.status,_that.createdAt,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _ReturnRequest implements ReturnRequest {
  const _ReturnRequest({required this.id, required this.orderId, required this.status, required this.createdAt, required  List<ReturnItemInfo> items}): _items = items;
  

@override final  String id;
@override final  String orderId;
@override final  ReturnStatus status;
@override final  DateTime createdAt;
 final  List<ReturnItemInfo> _items;
@override List<ReturnItemInfo> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of ReturnRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReturnRequestCopyWith<_ReturnRequest> get copyWith => __$ReturnRequestCopyWithImpl<_ReturnRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReturnRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,id,orderId,status,createdAt,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'ReturnRequest(id: $id, orderId: $orderId, status: $status, createdAt: $createdAt, items: $items)';
}


}

/// @nodoc
abstract mixin class _$ReturnRequestCopyWith<$Res> implements $ReturnRequestCopyWith<$Res> {
  factory _$ReturnRequestCopyWith(_ReturnRequest value, $Res Function(_ReturnRequest) _then) = __$ReturnRequestCopyWithImpl;
@override @useResult
$Res call({
 String id, String orderId, ReturnStatus status, DateTime createdAt, List<ReturnItemInfo> items
});




}
/// @nodoc
class __$ReturnRequestCopyWithImpl<$Res>
    implements _$ReturnRequestCopyWith<$Res> {
  __$ReturnRequestCopyWithImpl(this._self, this._then);

  final _ReturnRequest _self;
  final $Res Function(_ReturnRequest) _then;

/// Create a copy of ReturnRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderId = null,Object? status = null,Object? createdAt = null,Object? items = null,}) {
  return _then(_ReturnRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReturnStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ReturnItemInfo>,
  ));
}


}

/// @nodoc
mixin _$ReturnItemInfo {

 String get id; String get orderItemId; int get quantity; String get reason; String get productName;
/// Create a copy of ReturnItemInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReturnItemInfoCopyWith<ReturnItemInfo> get copyWith => _$ReturnItemInfoCopyWithImpl<ReturnItemInfo>(this as ReturnItemInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReturnItemInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.orderItemId, orderItemId) || other.orderItemId == orderItemId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.productName, productName) || other.productName == productName));
}


@override
int get hashCode => Object.hash(runtimeType,id,orderItemId,quantity,reason,productName);

@override
String toString() {
  return 'ReturnItemInfo(id: $id, orderItemId: $orderItemId, quantity: $quantity, reason: $reason, productName: $productName)';
}


}

/// @nodoc
abstract mixin class $ReturnItemInfoCopyWith<$Res>  {
  factory $ReturnItemInfoCopyWith(ReturnItemInfo value, $Res Function(ReturnItemInfo) _then) = _$ReturnItemInfoCopyWithImpl;
@useResult
$Res call({
 String id, String orderItemId, int quantity, String reason, String productName
});




}
/// @nodoc
class _$ReturnItemInfoCopyWithImpl<$Res>
    implements $ReturnItemInfoCopyWith<$Res> {
  _$ReturnItemInfoCopyWithImpl(this._self, this._then);

  final ReturnItemInfo _self;
  final $Res Function(ReturnItemInfo) _then;

/// Create a copy of ReturnItemInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderItemId = null,Object? quantity = null,Object? reason = null,Object? productName = null,}) {
  return _then(ReturnItemInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderItemId: null == orderItemId ? _self.orderItemId : orderItemId // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReturnItemInfo].
extension ReturnItemInfoPatterns on ReturnItemInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReturnItemInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReturnItemInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReturnItemInfo value)  $default,){
final _that = this;
switch (_that) {
case _ReturnItemInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReturnItemInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ReturnItemInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orderItemId,  int quantity,  String reason,  String productName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReturnItemInfo() when $default != null:
return $default(_that.id,_that.orderItemId,_that.quantity,_that.reason,_that.productName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orderItemId,  int quantity,  String reason,  String productName)  $default,) {final _that = this;
switch (_that) {
case _ReturnItemInfo():
return $default(_that.id,_that.orderItemId,_that.quantity,_that.reason,_that.productName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orderItemId,  int quantity,  String reason,  String productName)?  $default,) {final _that = this;
switch (_that) {
case _ReturnItemInfo() when $default != null:
return $default(_that.id,_that.orderItemId,_that.quantity,_that.reason,_that.productName);case _:
  return null;

}
}

}

/// @nodoc


class _ReturnItemInfo implements ReturnItemInfo {
  const _ReturnItemInfo({required this.id, required this.orderItemId, required this.quantity, required this.reason, required this.productName});
  

@override final  String id;
@override final  String orderItemId;
@override final  int quantity;
@override final  String reason;
@override final  String productName;

/// Create a copy of ReturnItemInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReturnItemInfoCopyWith<_ReturnItemInfo> get copyWith => __$ReturnItemInfoCopyWithImpl<_ReturnItemInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReturnItemInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.orderItemId, orderItemId) || other.orderItemId == orderItemId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.productName, productName) || other.productName == productName));
}


@override
int get hashCode => Object.hash(runtimeType,id,orderItemId,quantity,reason,productName);

@override
String toString() {
  return 'ReturnItemInfo(id: $id, orderItemId: $orderItemId, quantity: $quantity, reason: $reason, productName: $productName)';
}


}

/// @nodoc
abstract mixin class _$ReturnItemInfoCopyWith<$Res> implements $ReturnItemInfoCopyWith<$Res> {
  factory _$ReturnItemInfoCopyWith(_ReturnItemInfo value, $Res Function(_ReturnItemInfo) _then) = __$ReturnItemInfoCopyWithImpl;
@override @useResult
$Res call({
 String id, String orderItemId, int quantity, String reason, String productName
});




}
/// @nodoc
class __$ReturnItemInfoCopyWithImpl<$Res>
    implements _$ReturnItemInfoCopyWith<$Res> {
  __$ReturnItemInfoCopyWithImpl(this._self, this._then);

  final _ReturnItemInfo _self;
  final $Res Function(_ReturnItemInfo) _then;

/// Create a copy of ReturnItemInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderItemId = null,Object? quantity = null,Object? reason = null,Object? productName = null,}) {
  return _then(_ReturnItemInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderItemId: null == orderItemId ? _self.orderItemId : orderItemId // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ReturnableItem {

 String get orderItemId; String get productName; int get purchasedQuantity; String? get variantName;
/// Create a copy of ReturnableItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReturnableItemCopyWith<ReturnableItem> get copyWith => _$ReturnableItemCopyWithImpl<ReturnableItem>(this as ReturnableItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReturnableItem&&(identical(other.orderItemId, orderItemId) || other.orderItemId == orderItemId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.purchasedQuantity, purchasedQuantity) || other.purchasedQuantity == purchasedQuantity)&&(identical(other.variantName, variantName) || other.variantName == variantName));
}


@override
int get hashCode => Object.hash(runtimeType,orderItemId,productName,purchasedQuantity,variantName);

@override
String toString() {
  return 'ReturnableItem(orderItemId: $orderItemId, productName: $productName, purchasedQuantity: $purchasedQuantity, variantName: $variantName)';
}


}

/// @nodoc
abstract mixin class $ReturnableItemCopyWith<$Res>  {
  factory $ReturnableItemCopyWith(ReturnableItem value, $Res Function(ReturnableItem) _then) = _$ReturnableItemCopyWithImpl;
@useResult
$Res call({
 String orderItemId, String productName, int purchasedQuantity, String? variantName
});




}
/// @nodoc
class _$ReturnableItemCopyWithImpl<$Res>
    implements $ReturnableItemCopyWith<$Res> {
  _$ReturnableItemCopyWithImpl(this._self, this._then);

  final ReturnableItem _self;
  final $Res Function(ReturnableItem) _then;

/// Create a copy of ReturnableItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderItemId = null,Object? productName = null,Object? purchasedQuantity = null,Object? variantName = freezed,}) {
  return _then(ReturnableItem(
orderItemId: null == orderItemId ? _self.orderItemId : orderItemId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,purchasedQuantity: null == purchasedQuantity ? _self.purchasedQuantity : purchasedQuantity // ignore: cast_nullable_to_non_nullable
as int,variantName: freezed == variantName ? _self.variantName : variantName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReturnableItem].
extension ReturnableItemPatterns on ReturnableItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReturnableItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReturnableItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReturnableItem value)  $default,){
final _that = this;
switch (_that) {
case _ReturnableItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReturnableItem value)?  $default,){
final _that = this;
switch (_that) {
case _ReturnableItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String orderItemId,  String productName,  int purchasedQuantity,  String? variantName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReturnableItem() when $default != null:
return $default(_that.orderItemId,_that.productName,_that.purchasedQuantity,_that.variantName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String orderItemId,  String productName,  int purchasedQuantity,  String? variantName)  $default,) {final _that = this;
switch (_that) {
case _ReturnableItem():
return $default(_that.orderItemId,_that.productName,_that.purchasedQuantity,_that.variantName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String orderItemId,  String productName,  int purchasedQuantity,  String? variantName)?  $default,) {final _that = this;
switch (_that) {
case _ReturnableItem() when $default != null:
return $default(_that.orderItemId,_that.productName,_that.purchasedQuantity,_that.variantName);case _:
  return null;

}
}

}

/// @nodoc


class _ReturnableItem implements ReturnableItem {
  const _ReturnableItem({required this.orderItemId, required this.productName, required this.purchasedQuantity, this.variantName});
  

@override final  String orderItemId;
@override final  String productName;
@override final  int purchasedQuantity;
@override final  String? variantName;

/// Create a copy of ReturnableItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReturnableItemCopyWith<_ReturnableItem> get copyWith => __$ReturnableItemCopyWithImpl<_ReturnableItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReturnableItem&&(identical(other.orderItemId, orderItemId) || other.orderItemId == orderItemId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.purchasedQuantity, purchasedQuantity) || other.purchasedQuantity == purchasedQuantity)&&(identical(other.variantName, variantName) || other.variantName == variantName));
}


@override
int get hashCode => Object.hash(runtimeType,orderItemId,productName,purchasedQuantity,variantName);

@override
String toString() {
  return 'ReturnableItem(orderItemId: $orderItemId, productName: $productName, purchasedQuantity: $purchasedQuantity, variantName: $variantName)';
}


}

/// @nodoc
abstract mixin class _$ReturnableItemCopyWith<$Res> implements $ReturnableItemCopyWith<$Res> {
  factory _$ReturnableItemCopyWith(_ReturnableItem value, $Res Function(_ReturnableItem) _then) = __$ReturnableItemCopyWithImpl;
@override @useResult
$Res call({
 String orderItemId, String productName, int purchasedQuantity, String? variantName
});




}
/// @nodoc
class __$ReturnableItemCopyWithImpl<$Res>
    implements _$ReturnableItemCopyWith<$Res> {
  __$ReturnableItemCopyWithImpl(this._self, this._then);

  final _ReturnableItem _self;
  final $Res Function(_ReturnableItem) _then;

/// Create a copy of ReturnableItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderItemId = null,Object? productName = null,Object? purchasedQuantity = null,Object? variantName = freezed,}) {
  return _then(_ReturnableItem(
orderItemId: null == orderItemId ? _self.orderItemId : orderItemId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,purchasedQuantity: null == purchasedQuantity ? _self.purchasedQuantity : purchasedQuantity // ignore: cast_nullable_to_non_nullable
as int,variantName: freezed == variantName ? _self.variantName : variantName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ReturnItemDraft {

 String get orderItemId; int get quantity; String get reason;
/// Create a copy of ReturnItemDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReturnItemDraftCopyWith<ReturnItemDraft> get copyWith => _$ReturnItemDraftCopyWithImpl<ReturnItemDraft>(this as ReturnItemDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReturnItemDraft&&(identical(other.orderItemId, orderItemId) || other.orderItemId == orderItemId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,orderItemId,quantity,reason);

@override
String toString() {
  return 'ReturnItemDraft(orderItemId: $orderItemId, quantity: $quantity, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $ReturnItemDraftCopyWith<$Res>  {
  factory $ReturnItemDraftCopyWith(ReturnItemDraft value, $Res Function(ReturnItemDraft) _then) = _$ReturnItemDraftCopyWithImpl;
@useResult
$Res call({
 String orderItemId, int quantity, String reason
});




}
/// @nodoc
class _$ReturnItemDraftCopyWithImpl<$Res>
    implements $ReturnItemDraftCopyWith<$Res> {
  _$ReturnItemDraftCopyWithImpl(this._self, this._then);

  final ReturnItemDraft _self;
  final $Res Function(ReturnItemDraft) _then;

/// Create a copy of ReturnItemDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderItemId = null,Object? quantity = null,Object? reason = null,}) {
  return _then(ReturnItemDraft(
orderItemId: null == orderItemId ? _self.orderItemId : orderItemId // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReturnItemDraft].
extension ReturnItemDraftPatterns on ReturnItemDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReturnItemDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReturnItemDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReturnItemDraft value)  $default,){
final _that = this;
switch (_that) {
case _ReturnItemDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReturnItemDraft value)?  $default,){
final _that = this;
switch (_that) {
case _ReturnItemDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String orderItemId,  int quantity,  String reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReturnItemDraft() when $default != null:
return $default(_that.orderItemId,_that.quantity,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String orderItemId,  int quantity,  String reason)  $default,) {final _that = this;
switch (_that) {
case _ReturnItemDraft():
return $default(_that.orderItemId,_that.quantity,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String orderItemId,  int quantity,  String reason)?  $default,) {final _that = this;
switch (_that) {
case _ReturnItemDraft() when $default != null:
return $default(_that.orderItemId,_that.quantity,_that.reason);case _:
  return null;

}
}

}

/// @nodoc


class _ReturnItemDraft implements ReturnItemDraft {
  const _ReturnItemDraft({required this.orderItemId, required this.quantity, required this.reason});
  

@override final  String orderItemId;
@override final  int quantity;
@override final  String reason;

/// Create a copy of ReturnItemDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReturnItemDraftCopyWith<_ReturnItemDraft> get copyWith => __$ReturnItemDraftCopyWithImpl<_ReturnItemDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReturnItemDraft&&(identical(other.orderItemId, orderItemId) || other.orderItemId == orderItemId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,orderItemId,quantity,reason);

@override
String toString() {
  return 'ReturnItemDraft(orderItemId: $orderItemId, quantity: $quantity, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$ReturnItemDraftCopyWith<$Res> implements $ReturnItemDraftCopyWith<$Res> {
  factory _$ReturnItemDraftCopyWith(_ReturnItemDraft value, $Res Function(_ReturnItemDraft) _then) = __$ReturnItemDraftCopyWithImpl;
@override @useResult
$Res call({
 String orderItemId, int quantity, String reason
});




}
/// @nodoc
class __$ReturnItemDraftCopyWithImpl<$Res>
    implements _$ReturnItemDraftCopyWith<$Res> {
  __$ReturnItemDraftCopyWithImpl(this._self, this._then);

  final _ReturnItemDraft _self;
  final $Res Function(_ReturnItemDraft) _then;

/// Create a copy of ReturnItemDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderItemId = null,Object? quantity = null,Object? reason = null,}) {
  return _then(_ReturnItemDraft(
orderItemId: null == orderItemId ? _self.orderItemId : orderItemId // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
