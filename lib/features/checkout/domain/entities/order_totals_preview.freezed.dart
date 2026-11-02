// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_totals_preview.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderTotalsPreview {

 List<CouponPreview> get manual;/// Codes that no longer qualify after a cart edit — surfaced at checkout
/// instead of being silently skipped by the preview.
 List<CouponPreview> get rejected; int get subtotalMinor; int get totalDiscountMinor; int get deliveryFeeMinor; int get totalMinor;
/// Create a copy of OrderTotalsPreview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderTotalsPreviewCopyWith<OrderTotalsPreview> get copyWith => _$OrderTotalsPreviewCopyWithImpl<OrderTotalsPreview>(this as OrderTotalsPreview, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderTotalsPreview&&const DeepCollectionEquality().equals(other.manual, manual)&&const DeepCollectionEquality().equals(other.rejected, rejected)&&(identical(other.subtotalMinor, subtotalMinor) || other.subtotalMinor == subtotalMinor)&&(identical(other.totalDiscountMinor, totalDiscountMinor) || other.totalDiscountMinor == totalDiscountMinor)&&(identical(other.deliveryFeeMinor, deliveryFeeMinor) || other.deliveryFeeMinor == deliveryFeeMinor)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(manual),const DeepCollectionEquality().hash(rejected),subtotalMinor,totalDiscountMinor,deliveryFeeMinor,totalMinor);

@override
String toString() {
  return 'OrderTotalsPreview(manual: $manual, rejected: $rejected, subtotalMinor: $subtotalMinor, totalDiscountMinor: $totalDiscountMinor, deliveryFeeMinor: $deliveryFeeMinor, totalMinor: $totalMinor)';
}


}

/// @nodoc
abstract mixin class $OrderTotalsPreviewCopyWith<$Res>  {
  factory $OrderTotalsPreviewCopyWith(OrderTotalsPreview value, $Res Function(OrderTotalsPreview) _then) = _$OrderTotalsPreviewCopyWithImpl;
@useResult
$Res call({
 List<CouponPreview> manual, List<CouponPreview> rejected, int subtotalMinor, int totalDiscountMinor, int deliveryFeeMinor, int totalMinor
});




}
/// @nodoc
class _$OrderTotalsPreviewCopyWithImpl<$Res>
    implements $OrderTotalsPreviewCopyWith<$Res> {
  _$OrderTotalsPreviewCopyWithImpl(this._self, this._then);

  final OrderTotalsPreview _self;
  final $Res Function(OrderTotalsPreview) _then;

/// Create a copy of OrderTotalsPreview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? manual = null,Object? rejected = null,Object? subtotalMinor = null,Object? totalDiscountMinor = null,Object? deliveryFeeMinor = null,Object? totalMinor = null,}) {
  return _then(OrderTotalsPreview(
manual: null == manual ? _self.manual : manual // ignore: cast_nullable_to_non_nullable
as List<CouponPreview>,rejected: null == rejected ? _self.rejected : rejected // ignore: cast_nullable_to_non_nullable
as List<CouponPreview>,subtotalMinor: null == subtotalMinor ? _self.subtotalMinor : subtotalMinor // ignore: cast_nullable_to_non_nullable
as int,totalDiscountMinor: null == totalDiscountMinor ? _self.totalDiscountMinor : totalDiscountMinor // ignore: cast_nullable_to_non_nullable
as int,deliveryFeeMinor: null == deliveryFeeMinor ? _self.deliveryFeeMinor : deliveryFeeMinor // ignore: cast_nullable_to_non_nullable
as int,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderTotalsPreview].
extension OrderTotalsPreviewPatterns on OrderTotalsPreview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderTotalsPreview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderTotalsPreview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderTotalsPreview value)  $default,){
final _that = this;
switch (_that) {
case _OrderTotalsPreview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderTotalsPreview value)?  $default,){
final _that = this;
switch (_that) {
case _OrderTotalsPreview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CouponPreview> manual,  List<CouponPreview> rejected,  int subtotalMinor,  int totalDiscountMinor,  int deliveryFeeMinor,  int totalMinor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderTotalsPreview() when $default != null:
return $default(_that.manual,_that.rejected,_that.subtotalMinor,_that.totalDiscountMinor,_that.deliveryFeeMinor,_that.totalMinor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CouponPreview> manual,  List<CouponPreview> rejected,  int subtotalMinor,  int totalDiscountMinor,  int deliveryFeeMinor,  int totalMinor)  $default,) {final _that = this;
switch (_that) {
case _OrderTotalsPreview():
return $default(_that.manual,_that.rejected,_that.subtotalMinor,_that.totalDiscountMinor,_that.deliveryFeeMinor,_that.totalMinor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CouponPreview> manual,  List<CouponPreview> rejected,  int subtotalMinor,  int totalDiscountMinor,  int deliveryFeeMinor,  int totalMinor)?  $default,) {final _that = this;
switch (_that) {
case _OrderTotalsPreview() when $default != null:
return $default(_that.manual,_that.rejected,_that.subtotalMinor,_that.totalDiscountMinor,_that.deliveryFeeMinor,_that.totalMinor);case _:
  return null;

}
}

}

/// @nodoc


class _OrderTotalsPreview implements OrderTotalsPreview {
  const _OrderTotalsPreview({ List<CouponPreview> manual = const [],  List<CouponPreview> rejected = const [], this.subtotalMinor = 0, this.totalDiscountMinor = 0, this.deliveryFeeMinor = 0, this.totalMinor = 0}): _manual = manual,_rejected = rejected;
  

 final  List<CouponPreview> _manual;
@override@JsonKey() List<CouponPreview> get manual {
  if (_manual is EqualUnmodifiableListView) return _manual;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_manual);
}

/// Codes that no longer qualify after a cart edit — surfaced at checkout
/// instead of being silently skipped by the preview.
 final  List<CouponPreview> _rejected;
/// Codes that no longer qualify after a cart edit — surfaced at checkout
/// instead of being silently skipped by the preview.
@override@JsonKey() List<CouponPreview> get rejected {
  if (_rejected is EqualUnmodifiableListView) return _rejected;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rejected);
}

@override@JsonKey() final  int subtotalMinor;
@override@JsonKey() final  int totalDiscountMinor;
@override@JsonKey() final  int deliveryFeeMinor;
@override@JsonKey() final  int totalMinor;

/// Create a copy of OrderTotalsPreview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderTotalsPreviewCopyWith<_OrderTotalsPreview> get copyWith => __$OrderTotalsPreviewCopyWithImpl<_OrderTotalsPreview>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderTotalsPreview&&const DeepCollectionEquality().equals(other._manual, _manual)&&const DeepCollectionEquality().equals(other._rejected, _rejected)&&(identical(other.subtotalMinor, subtotalMinor) || other.subtotalMinor == subtotalMinor)&&(identical(other.totalDiscountMinor, totalDiscountMinor) || other.totalDiscountMinor == totalDiscountMinor)&&(identical(other.deliveryFeeMinor, deliveryFeeMinor) || other.deliveryFeeMinor == deliveryFeeMinor)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_manual),const DeepCollectionEquality().hash(_rejected),subtotalMinor,totalDiscountMinor,deliveryFeeMinor,totalMinor);

@override
String toString() {
  return 'OrderTotalsPreview(manual: $manual, rejected: $rejected, subtotalMinor: $subtotalMinor, totalDiscountMinor: $totalDiscountMinor, deliveryFeeMinor: $deliveryFeeMinor, totalMinor: $totalMinor)';
}


}

/// @nodoc
abstract mixin class _$OrderTotalsPreviewCopyWith<$Res> implements $OrderTotalsPreviewCopyWith<$Res> {
  factory _$OrderTotalsPreviewCopyWith(_OrderTotalsPreview value, $Res Function(_OrderTotalsPreview) _then) = __$OrderTotalsPreviewCopyWithImpl;
@override @useResult
$Res call({
 List<CouponPreview> manual, List<CouponPreview> rejected, int subtotalMinor, int totalDiscountMinor, int deliveryFeeMinor, int totalMinor
});




}
/// @nodoc
class __$OrderTotalsPreviewCopyWithImpl<$Res>
    implements _$OrderTotalsPreviewCopyWith<$Res> {
  __$OrderTotalsPreviewCopyWithImpl(this._self, this._then);

  final _OrderTotalsPreview _self;
  final $Res Function(_OrderTotalsPreview) _then;

/// Create a copy of OrderTotalsPreview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? manual = null,Object? rejected = null,Object? subtotalMinor = null,Object? totalDiscountMinor = null,Object? deliveryFeeMinor = null,Object? totalMinor = null,}) {
  return _then(_OrderTotalsPreview(
manual: null == manual ? _self._manual : manual // ignore: cast_nullable_to_non_nullable
as List<CouponPreview>,rejected: null == rejected ? _self._rejected : rejected // ignore: cast_nullable_to_non_nullable
as List<CouponPreview>,subtotalMinor: null == subtotalMinor ? _self.subtotalMinor : subtotalMinor // ignore: cast_nullable_to_non_nullable
as int,totalDiscountMinor: null == totalDiscountMinor ? _self.totalDiscountMinor : totalDiscountMinor // ignore: cast_nullable_to_non_nullable
as int,deliveryFeeMinor: null == deliveryFeeMinor ? _self.deliveryFeeMinor : deliveryFeeMinor // ignore: cast_nullable_to_non_nullable
as int,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
