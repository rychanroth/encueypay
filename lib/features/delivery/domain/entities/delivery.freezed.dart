// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AvailableDelivery {

 String get id; String get orderId; String get dropoffCity; List<String> get pickupBusinessNames; int get stopCount; int get deliveryFeeMinor; DateTime get createdAt;
/// Create a copy of AvailableDelivery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AvailableDeliveryCopyWith<AvailableDelivery> get copyWith => _$AvailableDeliveryCopyWithImpl<AvailableDelivery>(this as AvailableDelivery, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AvailableDelivery&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.dropoffCity, dropoffCity) || other.dropoffCity == dropoffCity)&&const DeepCollectionEquality().equals(other.pickupBusinessNames, pickupBusinessNames)&&(identical(other.stopCount, stopCount) || other.stopCount == stopCount)&&(identical(other.deliveryFeeMinor, deliveryFeeMinor) || other.deliveryFeeMinor == deliveryFeeMinor)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,orderId,dropoffCity,const DeepCollectionEquality().hash(pickupBusinessNames),stopCount,deliveryFeeMinor,createdAt);

@override
String toString() {
  return 'AvailableDelivery(id: $id, orderId: $orderId, dropoffCity: $dropoffCity, pickupBusinessNames: $pickupBusinessNames, stopCount: $stopCount, deliveryFeeMinor: $deliveryFeeMinor, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AvailableDeliveryCopyWith<$Res>  {
  factory $AvailableDeliveryCopyWith(AvailableDelivery value, $Res Function(AvailableDelivery) _then) = _$AvailableDeliveryCopyWithImpl;
@useResult
$Res call({
 String id, String orderId, String dropoffCity, List<String> pickupBusinessNames, int stopCount, int deliveryFeeMinor, DateTime createdAt
});




}
/// @nodoc
class _$AvailableDeliveryCopyWithImpl<$Res>
    implements $AvailableDeliveryCopyWith<$Res> {
  _$AvailableDeliveryCopyWithImpl(this._self, this._then);

  final AvailableDelivery _self;
  final $Res Function(AvailableDelivery) _then;

/// Create a copy of AvailableDelivery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderId = null,Object? dropoffCity = null,Object? pickupBusinessNames = null,Object? stopCount = null,Object? deliveryFeeMinor = null,Object? createdAt = null,}) {
  return _then(AvailableDelivery(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,dropoffCity: null == dropoffCity ? _self.dropoffCity : dropoffCity // ignore: cast_nullable_to_non_nullable
as String,pickupBusinessNames: null == pickupBusinessNames ? _self.pickupBusinessNames : pickupBusinessNames // ignore: cast_nullable_to_non_nullable
as List<String>,stopCount: null == stopCount ? _self.stopCount : stopCount // ignore: cast_nullable_to_non_nullable
as int,deliveryFeeMinor: null == deliveryFeeMinor ? _self.deliveryFeeMinor : deliveryFeeMinor // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AvailableDelivery].
extension AvailableDeliveryPatterns on AvailableDelivery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AvailableDelivery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AvailableDelivery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AvailableDelivery value)  $default,){
final _that = this;
switch (_that) {
case _AvailableDelivery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AvailableDelivery value)?  $default,){
final _that = this;
switch (_that) {
case _AvailableDelivery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orderId,  String dropoffCity,  List<String> pickupBusinessNames,  int stopCount,  int deliveryFeeMinor,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AvailableDelivery() when $default != null:
return $default(_that.id,_that.orderId,_that.dropoffCity,_that.pickupBusinessNames,_that.stopCount,_that.deliveryFeeMinor,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orderId,  String dropoffCity,  List<String> pickupBusinessNames,  int stopCount,  int deliveryFeeMinor,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _AvailableDelivery():
return $default(_that.id,_that.orderId,_that.dropoffCity,_that.pickupBusinessNames,_that.stopCount,_that.deliveryFeeMinor,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orderId,  String dropoffCity,  List<String> pickupBusinessNames,  int stopCount,  int deliveryFeeMinor,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AvailableDelivery() when $default != null:
return $default(_that.id,_that.orderId,_that.dropoffCity,_that.pickupBusinessNames,_that.stopCount,_that.deliveryFeeMinor,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _AvailableDelivery implements AvailableDelivery {
  const _AvailableDelivery({required this.id, required this.orderId, required this.dropoffCity, required  List<String> pickupBusinessNames, required this.stopCount, required this.deliveryFeeMinor, required this.createdAt}): _pickupBusinessNames = pickupBusinessNames;
  

@override final  String id;
@override final  String orderId;
@override final  String dropoffCity;
 final  List<String> _pickupBusinessNames;
@override List<String> get pickupBusinessNames {
  if (_pickupBusinessNames is EqualUnmodifiableListView) return _pickupBusinessNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pickupBusinessNames);
}

@override final  int stopCount;
@override final  int deliveryFeeMinor;
@override final  DateTime createdAt;

/// Create a copy of AvailableDelivery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvailableDeliveryCopyWith<_AvailableDelivery> get copyWith => __$AvailableDeliveryCopyWithImpl<_AvailableDelivery>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AvailableDelivery&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.dropoffCity, dropoffCity) || other.dropoffCity == dropoffCity)&&const DeepCollectionEquality().equals(other._pickupBusinessNames, _pickupBusinessNames)&&(identical(other.stopCount, stopCount) || other.stopCount == stopCount)&&(identical(other.deliveryFeeMinor, deliveryFeeMinor) || other.deliveryFeeMinor == deliveryFeeMinor)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,orderId,dropoffCity,const DeepCollectionEquality().hash(_pickupBusinessNames),stopCount,deliveryFeeMinor,createdAt);

@override
String toString() {
  return 'AvailableDelivery(id: $id, orderId: $orderId, dropoffCity: $dropoffCity, pickupBusinessNames: $pickupBusinessNames, stopCount: $stopCount, deliveryFeeMinor: $deliveryFeeMinor, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AvailableDeliveryCopyWith<$Res> implements $AvailableDeliveryCopyWith<$Res> {
  factory _$AvailableDeliveryCopyWith(_AvailableDelivery value, $Res Function(_AvailableDelivery) _then) = __$AvailableDeliveryCopyWithImpl;
@override @useResult
$Res call({
 String id, String orderId, String dropoffCity, List<String> pickupBusinessNames, int stopCount, int deliveryFeeMinor, DateTime createdAt
});




}
/// @nodoc
class __$AvailableDeliveryCopyWithImpl<$Res>
    implements _$AvailableDeliveryCopyWith<$Res> {
  __$AvailableDeliveryCopyWithImpl(this._self, this._then);

  final _AvailableDelivery _self;
  final $Res Function(_AvailableDelivery) _then;

/// Create a copy of AvailableDelivery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderId = null,Object? dropoffCity = null,Object? pickupBusinessNames = null,Object? stopCount = null,Object? deliveryFeeMinor = null,Object? createdAt = null,}) {
  return _then(_AvailableDelivery(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,dropoffCity: null == dropoffCity ? _self.dropoffCity : dropoffCity // ignore: cast_nullable_to_non_nullable
as String,pickupBusinessNames: null == pickupBusinessNames ? _self._pickupBusinessNames : pickupBusinessNames // ignore: cast_nullable_to_non_nullable
as List<String>,stopCount: null == stopCount ? _self.stopCount : stopCount // ignore: cast_nullable_to_non_nullable
as int,deliveryFeeMinor: null == deliveryFeeMinor ? _self.deliveryFeeMinor : deliveryFeeMinor // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$DriverDelivery {

 String get id; String get orderId; DeliveryStateValue get status; String get customerName; String get dropoffLine1; String get dropoffCity; int get earningMinor; DateTime get createdAt; List<DriverStop> get stops;
/// Create a copy of DriverDelivery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DriverDeliveryCopyWith<DriverDelivery> get copyWith => _$DriverDeliveryCopyWithImpl<DriverDelivery>(this as DriverDelivery, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DriverDelivery&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.status, status) || other.status == status)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.dropoffLine1, dropoffLine1) || other.dropoffLine1 == dropoffLine1)&&(identical(other.dropoffCity, dropoffCity) || other.dropoffCity == dropoffCity)&&(identical(other.earningMinor, earningMinor) || other.earningMinor == earningMinor)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.stops, stops));
}


@override
int get hashCode => Object.hash(runtimeType,id,orderId,status,customerName,dropoffLine1,dropoffCity,earningMinor,createdAt,const DeepCollectionEquality().hash(stops));

@override
String toString() {
  return 'DriverDelivery(id: $id, orderId: $orderId, status: $status, customerName: $customerName, dropoffLine1: $dropoffLine1, dropoffCity: $dropoffCity, earningMinor: $earningMinor, createdAt: $createdAt, stops: $stops)';
}


}

/// @nodoc
abstract mixin class $DriverDeliveryCopyWith<$Res>  {
  factory $DriverDeliveryCopyWith(DriverDelivery value, $Res Function(DriverDelivery) _then) = _$DriverDeliveryCopyWithImpl;
@useResult
$Res call({
 String id, String orderId, DeliveryStateValue status, String customerName, String dropoffLine1, String dropoffCity, int earningMinor, DateTime createdAt, List<DriverStop> stops
});




}
/// @nodoc
class _$DriverDeliveryCopyWithImpl<$Res>
    implements $DriverDeliveryCopyWith<$Res> {
  _$DriverDeliveryCopyWithImpl(this._self, this._then);

  final DriverDelivery _self;
  final $Res Function(DriverDelivery) _then;

/// Create a copy of DriverDelivery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderId = null,Object? status = null,Object? customerName = null,Object? dropoffLine1 = null,Object? dropoffCity = null,Object? earningMinor = null,Object? createdAt = null,Object? stops = null,}) {
  return _then(DriverDelivery(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DeliveryStateValue,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,dropoffLine1: null == dropoffLine1 ? _self.dropoffLine1 : dropoffLine1 // ignore: cast_nullable_to_non_nullable
as String,dropoffCity: null == dropoffCity ? _self.dropoffCity : dropoffCity // ignore: cast_nullable_to_non_nullable
as String,earningMinor: null == earningMinor ? _self.earningMinor : earningMinor // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,stops: null == stops ? _self.stops : stops // ignore: cast_nullable_to_non_nullable
as List<DriverStop>,
  ));
}

}


/// Adds pattern-matching-related methods to [DriverDelivery].
extension DriverDeliveryPatterns on DriverDelivery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DriverDelivery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DriverDelivery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DriverDelivery value)  $default,){
final _that = this;
switch (_that) {
case _DriverDelivery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DriverDelivery value)?  $default,){
final _that = this;
switch (_that) {
case _DriverDelivery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orderId,  DeliveryStateValue status,  String customerName,  String dropoffLine1,  String dropoffCity,  int earningMinor,  DateTime createdAt,  List<DriverStop> stops)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DriverDelivery() when $default != null:
return $default(_that.id,_that.orderId,_that.status,_that.customerName,_that.dropoffLine1,_that.dropoffCity,_that.earningMinor,_that.createdAt,_that.stops);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orderId,  DeliveryStateValue status,  String customerName,  String dropoffLine1,  String dropoffCity,  int earningMinor,  DateTime createdAt,  List<DriverStop> stops)  $default,) {final _that = this;
switch (_that) {
case _DriverDelivery():
return $default(_that.id,_that.orderId,_that.status,_that.customerName,_that.dropoffLine1,_that.dropoffCity,_that.earningMinor,_that.createdAt,_that.stops);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orderId,  DeliveryStateValue status,  String customerName,  String dropoffLine1,  String dropoffCity,  int earningMinor,  DateTime createdAt,  List<DriverStop> stops)?  $default,) {final _that = this;
switch (_that) {
case _DriverDelivery() when $default != null:
return $default(_that.id,_that.orderId,_that.status,_that.customerName,_that.dropoffLine1,_that.dropoffCity,_that.earningMinor,_that.createdAt,_that.stops);case _:
  return null;

}
}

}

/// @nodoc


class _DriverDelivery extends DriverDelivery {
  const _DriverDelivery({required this.id, required this.orderId, required this.status, required this.customerName, required this.dropoffLine1, required this.dropoffCity, required this.earningMinor, required this.createdAt, required  List<DriverStop> stops}): _stops = stops,super._();
  

@override final  String id;
@override final  String orderId;
@override final  DeliveryStateValue status;
@override final  String customerName;
@override final  String dropoffLine1;
@override final  String dropoffCity;
@override final  int earningMinor;
@override final  DateTime createdAt;
 final  List<DriverStop> _stops;
@override List<DriverStop> get stops {
  if (_stops is EqualUnmodifiableListView) return _stops;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stops);
}


/// Create a copy of DriverDelivery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DriverDeliveryCopyWith<_DriverDelivery> get copyWith => __$DriverDeliveryCopyWithImpl<_DriverDelivery>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DriverDelivery&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.status, status) || other.status == status)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.dropoffLine1, dropoffLine1) || other.dropoffLine1 == dropoffLine1)&&(identical(other.dropoffCity, dropoffCity) || other.dropoffCity == dropoffCity)&&(identical(other.earningMinor, earningMinor) || other.earningMinor == earningMinor)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._stops, _stops));
}


@override
int get hashCode => Object.hash(runtimeType,id,orderId,status,customerName,dropoffLine1,dropoffCity,earningMinor,createdAt,const DeepCollectionEquality().hash(_stops));

@override
String toString() {
  return 'DriverDelivery(id: $id, orderId: $orderId, status: $status, customerName: $customerName, dropoffLine1: $dropoffLine1, dropoffCity: $dropoffCity, earningMinor: $earningMinor, createdAt: $createdAt, stops: $stops)';
}


}

/// @nodoc
abstract mixin class _$DriverDeliveryCopyWith<$Res> implements $DriverDeliveryCopyWith<$Res> {
  factory _$DriverDeliveryCopyWith(_DriverDelivery value, $Res Function(_DriverDelivery) _then) = __$DriverDeliveryCopyWithImpl;
@override @useResult
$Res call({
 String id, String orderId, DeliveryStateValue status, String customerName, String dropoffLine1, String dropoffCity, int earningMinor, DateTime createdAt, List<DriverStop> stops
});




}
/// @nodoc
class __$DriverDeliveryCopyWithImpl<$Res>
    implements _$DriverDeliveryCopyWith<$Res> {
  __$DriverDeliveryCopyWithImpl(this._self, this._then);

  final _DriverDelivery _self;
  final $Res Function(_DriverDelivery) _then;

/// Create a copy of DriverDelivery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderId = null,Object? status = null,Object? customerName = null,Object? dropoffLine1 = null,Object? dropoffCity = null,Object? earningMinor = null,Object? createdAt = null,Object? stops = null,}) {
  return _then(_DriverDelivery(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DeliveryStateValue,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,dropoffLine1: null == dropoffLine1 ? _self.dropoffLine1 : dropoffLine1 // ignore: cast_nullable_to_non_nullable
as String,dropoffCity: null == dropoffCity ? _self.dropoffCity : dropoffCity // ignore: cast_nullable_to_non_nullable
as String,earningMinor: null == earningMinor ? _self.earningMinor : earningMinor // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,stops: null == stops ? _self._stops : stops // ignore: cast_nullable_to_non_nullable
as List<DriverStop>,
  ));
}


}

/// @nodoc
mixin _$DriverStop {

 String get id; String get businessName; int get sequence; bool get completed;
/// Create a copy of DriverStop
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DriverStopCopyWith<DriverStop> get copyWith => _$DriverStopCopyWithImpl<DriverStop>(this as DriverStop, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DriverStop&&(identical(other.id, id) || other.id == id)&&(identical(other.businessName, businessName) || other.businessName == businessName)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.completed, completed) || other.completed == completed));
}


@override
int get hashCode => Object.hash(runtimeType,id,businessName,sequence,completed);

@override
String toString() {
  return 'DriverStop(id: $id, businessName: $businessName, sequence: $sequence, completed: $completed)';
}


}

/// @nodoc
abstract mixin class $DriverStopCopyWith<$Res>  {
  factory $DriverStopCopyWith(DriverStop value, $Res Function(DriverStop) _then) = _$DriverStopCopyWithImpl;
@useResult
$Res call({
 String id, String businessName, int sequence, bool completed
});




}
/// @nodoc
class _$DriverStopCopyWithImpl<$Res>
    implements $DriverStopCopyWith<$Res> {
  _$DriverStopCopyWithImpl(this._self, this._then);

  final DriverStop _self;
  final $Res Function(DriverStop) _then;

/// Create a copy of DriverStop
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessName = null,Object? sequence = null,Object? completed = null,}) {
  return _then(DriverStop(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessName: null == businessName ? _self.businessName : businessName // ignore: cast_nullable_to_non_nullable
as String,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DriverStop].
extension DriverStopPatterns on DriverStop {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DriverStop value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DriverStop() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DriverStop value)  $default,){
final _that = this;
switch (_that) {
case _DriverStop():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DriverStop value)?  $default,){
final _that = this;
switch (_that) {
case _DriverStop() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String businessName,  int sequence,  bool completed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DriverStop() when $default != null:
return $default(_that.id,_that.businessName,_that.sequence,_that.completed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String businessName,  int sequence,  bool completed)  $default,) {final _that = this;
switch (_that) {
case _DriverStop():
return $default(_that.id,_that.businessName,_that.sequence,_that.completed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String businessName,  int sequence,  bool completed)?  $default,) {final _that = this;
switch (_that) {
case _DriverStop() when $default != null:
return $default(_that.id,_that.businessName,_that.sequence,_that.completed);case _:
  return null;

}
}

}

/// @nodoc


class _DriverStop implements DriverStop {
  const _DriverStop({required this.id, required this.businessName, required this.sequence, required this.completed});
  

@override final  String id;
@override final  String businessName;
@override final  int sequence;
@override final  bool completed;

/// Create a copy of DriverStop
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DriverStopCopyWith<_DriverStop> get copyWith => __$DriverStopCopyWithImpl<_DriverStop>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DriverStop&&(identical(other.id, id) || other.id == id)&&(identical(other.businessName, businessName) || other.businessName == businessName)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.completed, completed) || other.completed == completed));
}


@override
int get hashCode => Object.hash(runtimeType,id,businessName,sequence,completed);

@override
String toString() {
  return 'DriverStop(id: $id, businessName: $businessName, sequence: $sequence, completed: $completed)';
}


}

/// @nodoc
abstract mixin class _$DriverStopCopyWith<$Res> implements $DriverStopCopyWith<$Res> {
  factory _$DriverStopCopyWith(_DriverStop value, $Res Function(_DriverStop) _then) = __$DriverStopCopyWithImpl;
@override @useResult
$Res call({
 String id, String businessName, int sequence, bool completed
});




}
/// @nodoc
class __$DriverStopCopyWithImpl<$Res>
    implements _$DriverStopCopyWith<$Res> {
  __$DriverStopCopyWithImpl(this._self, this._then);

  final _DriverStop _self;
  final $Res Function(_DriverStop) _then;

/// Create a copy of DriverStop
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessName = null,Object? sequence = null,Object? completed = null,}) {
  return _then(_DriverStop(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessName: null == businessName ? _self.businessName : businessName // ignore: cast_nullable_to_non_nullable
as String,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
