// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_coupon.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CartCoupon {

 String get code; bool get valid; int get discountMinor; String? get message;/// `'Platform'` or `'Brand'` — scope recognition chip (§5.1.3). The RPC
/// returns the raw promotion scope; anything non-brand acts cart-wide in
/// the 2-role prototype and renders as Platform.
 String get scopeLabel;
/// Create a copy of CartCoupon
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartCouponCopyWith<CartCoupon> get copyWith => _$CartCouponCopyWithImpl<CartCoupon>(this as CartCoupon, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartCoupon&&(identical(other.code, code) || other.code == code)&&(identical(other.valid, valid) || other.valid == valid)&&(identical(other.discountMinor, discountMinor) || other.discountMinor == discountMinor)&&(identical(other.message, message) || other.message == message)&&(identical(other.scopeLabel, scopeLabel) || other.scopeLabel == scopeLabel));
}


@override
int get hashCode => Object.hash(runtimeType,code,valid,discountMinor,message,scopeLabel);

@override
String toString() {
  return 'CartCoupon(code: $code, valid: $valid, discountMinor: $discountMinor, message: $message, scopeLabel: $scopeLabel)';
}


}

/// @nodoc
abstract mixin class $CartCouponCopyWith<$Res>  {
  factory $CartCouponCopyWith(CartCoupon value, $Res Function(CartCoupon) _then) = _$CartCouponCopyWithImpl;
@useResult
$Res call({
 String code, bool valid, int discountMinor, String? message, String scopeLabel
});




}
/// @nodoc
class _$CartCouponCopyWithImpl<$Res>
    implements $CartCouponCopyWith<$Res> {
  _$CartCouponCopyWithImpl(this._self, this._then);

  final CartCoupon _self;
  final $Res Function(CartCoupon) _then;

/// Create a copy of CartCoupon
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? valid = null,Object? discountMinor = null,Object? message = freezed,Object? scopeLabel = null,}) {
  return _then(CartCoupon(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,valid: null == valid ? _self.valid : valid // ignore: cast_nullable_to_non_nullable
as bool,discountMinor: null == discountMinor ? _self.discountMinor : discountMinor // ignore: cast_nullable_to_non_nullable
as int,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,scopeLabel: null == scopeLabel ? _self.scopeLabel : scopeLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CartCoupon].
extension CartCouponPatterns on CartCoupon {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CartCoupon value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CartCoupon() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CartCoupon value)  $default,){
final _that = this;
switch (_that) {
case _CartCoupon():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CartCoupon value)?  $default,){
final _that = this;
switch (_that) {
case _CartCoupon() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  bool valid,  int discountMinor,  String? message,  String scopeLabel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CartCoupon() when $default != null:
return $default(_that.code,_that.valid,_that.discountMinor,_that.message,_that.scopeLabel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  bool valid,  int discountMinor,  String? message,  String scopeLabel)  $default,) {final _that = this;
switch (_that) {
case _CartCoupon():
return $default(_that.code,_that.valid,_that.discountMinor,_that.message,_that.scopeLabel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  bool valid,  int discountMinor,  String? message,  String scopeLabel)?  $default,) {final _that = this;
switch (_that) {
case _CartCoupon() when $default != null:
return $default(_that.code,_that.valid,_that.discountMinor,_that.message,_that.scopeLabel);case _:
  return null;

}
}

}

/// @nodoc


class _CartCoupon implements CartCoupon {
  const _CartCoupon({required this.code, required this.valid, this.discountMinor = 0, this.message, this.scopeLabel = 'Platform'});
  

@override final  String code;
@override final  bool valid;
@override@JsonKey() final  int discountMinor;
@override final  String? message;
/// `'Platform'` or `'Brand'` — scope recognition chip (§5.1.3). The RPC
/// returns the raw promotion scope; anything non-brand acts cart-wide in
/// the 2-role prototype and renders as Platform.
@override@JsonKey() final  String scopeLabel;

/// Create a copy of CartCoupon
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartCouponCopyWith<_CartCoupon> get copyWith => __$CartCouponCopyWithImpl<_CartCoupon>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CartCoupon&&(identical(other.code, code) || other.code == code)&&(identical(other.valid, valid) || other.valid == valid)&&(identical(other.discountMinor, discountMinor) || other.discountMinor == discountMinor)&&(identical(other.message, message) || other.message == message)&&(identical(other.scopeLabel, scopeLabel) || other.scopeLabel == scopeLabel));
}


@override
int get hashCode => Object.hash(runtimeType,code,valid,discountMinor,message,scopeLabel);

@override
String toString() {
  return 'CartCoupon(code: $code, valid: $valid, discountMinor: $discountMinor, message: $message, scopeLabel: $scopeLabel)';
}


}

/// @nodoc
abstract mixin class _$CartCouponCopyWith<$Res> implements $CartCouponCopyWith<$Res> {
  factory _$CartCouponCopyWith(_CartCoupon value, $Res Function(_CartCoupon) _then) = __$CartCouponCopyWithImpl;
@override @useResult
$Res call({
 String code, bool valid, int discountMinor, String? message, String scopeLabel
});




}
/// @nodoc
class __$CartCouponCopyWithImpl<$Res>
    implements _$CartCouponCopyWith<$Res> {
  __$CartCouponCopyWithImpl(this._self, this._then);

  final _CartCoupon _self;
  final $Res Function(_CartCoupon) _then;

/// Create a copy of CartCoupon
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? valid = null,Object? discountMinor = null,Object? message = freezed,Object? scopeLabel = null,}) {
  return _then(_CartCoupon(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,valid: null == valid ? _self.valid : valid // ignore: cast_nullable_to_non_nullable
as bool,discountMinor: null == discountMinor ? _self.discountMinor : discountMinor // ignore: cast_nullable_to_non_nullable
as int,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,scopeLabel: null == scopeLabel ? _self.scopeLabel : scopeLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
