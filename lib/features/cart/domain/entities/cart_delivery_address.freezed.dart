// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_delivery_address.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CartDeliveryAddress {

 String get id; String get label; String get city;
/// Create a copy of CartDeliveryAddress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartDeliveryAddressCopyWith<CartDeliveryAddress> get copyWith => _$CartDeliveryAddressCopyWithImpl<CartDeliveryAddress>(this as CartDeliveryAddress, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartDeliveryAddress&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.city, city) || other.city == city));
}


@override
int get hashCode => Object.hash(runtimeType,id,label,city);

@override
String toString() {
  return 'CartDeliveryAddress(id: $id, label: $label, city: $city)';
}


}

/// @nodoc
abstract mixin class $CartDeliveryAddressCopyWith<$Res>  {
  factory $CartDeliveryAddressCopyWith(CartDeliveryAddress value, $Res Function(CartDeliveryAddress) _then) = _$CartDeliveryAddressCopyWithImpl;
@useResult
$Res call({
 String id, String label, String city
});




}
/// @nodoc
class _$CartDeliveryAddressCopyWithImpl<$Res>
    implements $CartDeliveryAddressCopyWith<$Res> {
  _$CartDeliveryAddressCopyWithImpl(this._self, this._then);

  final CartDeliveryAddress _self;
  final $Res Function(CartDeliveryAddress) _then;

/// Create a copy of CartDeliveryAddress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? city = null,}) {
  return _then(CartDeliveryAddress(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CartDeliveryAddress].
extension CartDeliveryAddressPatterns on CartDeliveryAddress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CartDeliveryAddress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CartDeliveryAddress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CartDeliveryAddress value)  $default,){
final _that = this;
switch (_that) {
case _CartDeliveryAddress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CartDeliveryAddress value)?  $default,){
final _that = this;
switch (_that) {
case _CartDeliveryAddress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String label,  String city)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CartDeliveryAddress() when $default != null:
return $default(_that.id,_that.label,_that.city);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String label,  String city)  $default,) {final _that = this;
switch (_that) {
case _CartDeliveryAddress():
return $default(_that.id,_that.label,_that.city);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String label,  String city)?  $default,) {final _that = this;
switch (_that) {
case _CartDeliveryAddress() when $default != null:
return $default(_that.id,_that.label,_that.city);case _:
  return null;

}
}

}

/// @nodoc


class _CartDeliveryAddress implements CartDeliveryAddress {
  const _CartDeliveryAddress({required this.id, required this.label, required this.city});
  

@override final  String id;
@override final  String label;
@override final  String city;

/// Create a copy of CartDeliveryAddress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartDeliveryAddressCopyWith<_CartDeliveryAddress> get copyWith => __$CartDeliveryAddressCopyWithImpl<_CartDeliveryAddress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CartDeliveryAddress&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.city, city) || other.city == city));
}


@override
int get hashCode => Object.hash(runtimeType,id,label,city);

@override
String toString() {
  return 'CartDeliveryAddress(id: $id, label: $label, city: $city)';
}


}

/// @nodoc
abstract mixin class _$CartDeliveryAddressCopyWith<$Res> implements $CartDeliveryAddressCopyWith<$Res> {
  factory _$CartDeliveryAddressCopyWith(_CartDeliveryAddress value, $Res Function(_CartDeliveryAddress) _then) = __$CartDeliveryAddressCopyWithImpl;
@override @useResult
$Res call({
 String id, String label, String city
});




}
/// @nodoc
class __$CartDeliveryAddressCopyWithImpl<$Res>
    implements _$CartDeliveryAddressCopyWith<$Res> {
  __$CartDeliveryAddressCopyWithImpl(this._self, this._then);

  final _CartDeliveryAddress _self;
  final $Res Function(_CartDeliveryAddress) _then;

/// Create a copy of CartDeliveryAddress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? city = null,}) {
  return _then(_CartDeliveryAddress(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
