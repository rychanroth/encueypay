// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coupon_preview.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CouponPreview {

 String get code; bool get valid; int get discountMinor; String? get message; String get name; CouponDiscountType? get discountType; int get discountValue; int get minOrderAmountMinor; DateTime? get startsAt; DateTime? get endsAt; int get subtotalMinor;/// Structured failure code (`not_found`, `inactive`, `not_started`,
/// `expired`, `min_order_not_met`, `empty_cart`, `not_authenticated`).
 String? get reason;
/// Create a copy of CouponPreview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CouponPreviewCopyWith<CouponPreview> get copyWith => _$CouponPreviewCopyWithImpl<CouponPreview>(this as CouponPreview, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CouponPreview&&(identical(other.code, code) || other.code == code)&&(identical(other.valid, valid) || other.valid == valid)&&(identical(other.discountMinor, discountMinor) || other.discountMinor == discountMinor)&&(identical(other.message, message) || other.message == message)&&(identical(other.name, name) || other.name == name)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.minOrderAmountMinor, minOrderAmountMinor) || other.minOrderAmountMinor == minOrderAmountMinor)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.subtotalMinor, subtotalMinor) || other.subtotalMinor == subtotalMinor)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,code,valid,discountMinor,message,name,discountType,discountValue,minOrderAmountMinor,startsAt,endsAt,subtotalMinor,reason);

@override
String toString() {
  return 'CouponPreview(code: $code, valid: $valid, discountMinor: $discountMinor, message: $message, name: $name, discountType: $discountType, discountValue: $discountValue, minOrderAmountMinor: $minOrderAmountMinor, startsAt: $startsAt, endsAt: $endsAt, subtotalMinor: $subtotalMinor, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $CouponPreviewCopyWith<$Res>  {
  factory $CouponPreviewCopyWith(CouponPreview value, $Res Function(CouponPreview) _then) = _$CouponPreviewCopyWithImpl;
@useResult
$Res call({
 String code, bool valid, int discountMinor, String? message, String name, CouponDiscountType? discountType, int discountValue, int minOrderAmountMinor, DateTime? startsAt, DateTime? endsAt, int subtotalMinor, String? reason
});




}
/// @nodoc
class _$CouponPreviewCopyWithImpl<$Res>
    implements $CouponPreviewCopyWith<$Res> {
  _$CouponPreviewCopyWithImpl(this._self, this._then);

  final CouponPreview _self;
  final $Res Function(CouponPreview) _then;

/// Create a copy of CouponPreview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? valid = null,Object? discountMinor = null,Object? message = freezed,Object? name = null,Object? discountType = freezed,Object? discountValue = null,Object? minOrderAmountMinor = null,Object? startsAt = freezed,Object? endsAt = freezed,Object? subtotalMinor = null,Object? reason = freezed,}) {
  return _then(CouponPreview(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,valid: null == valid ? _self.valid : valid // ignore: cast_nullable_to_non_nullable
as bool,discountMinor: null == discountMinor ? _self.discountMinor : discountMinor // ignore: cast_nullable_to_non_nullable
as int,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,discountType: freezed == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as CouponDiscountType?,discountValue: null == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as int,minOrderAmountMinor: null == minOrderAmountMinor ? _self.minOrderAmountMinor : minOrderAmountMinor // ignore: cast_nullable_to_non_nullable
as int,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,subtotalMinor: null == subtotalMinor ? _self.subtotalMinor : subtotalMinor // ignore: cast_nullable_to_non_nullable
as int,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CouponPreview].
extension CouponPreviewPatterns on CouponPreview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CouponPreview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CouponPreview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CouponPreview value)  $default,){
final _that = this;
switch (_that) {
case _CouponPreview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CouponPreview value)?  $default,){
final _that = this;
switch (_that) {
case _CouponPreview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  bool valid,  int discountMinor,  String? message,  String name,  CouponDiscountType? discountType,  int discountValue,  int minOrderAmountMinor,  DateTime? startsAt,  DateTime? endsAt,  int subtotalMinor,  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CouponPreview() when $default != null:
return $default(_that.code,_that.valid,_that.discountMinor,_that.message,_that.name,_that.discountType,_that.discountValue,_that.minOrderAmountMinor,_that.startsAt,_that.endsAt,_that.subtotalMinor,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  bool valid,  int discountMinor,  String? message,  String name,  CouponDiscountType? discountType,  int discountValue,  int minOrderAmountMinor,  DateTime? startsAt,  DateTime? endsAt,  int subtotalMinor,  String? reason)  $default,) {final _that = this;
switch (_that) {
case _CouponPreview():
return $default(_that.code,_that.valid,_that.discountMinor,_that.message,_that.name,_that.discountType,_that.discountValue,_that.minOrderAmountMinor,_that.startsAt,_that.endsAt,_that.subtotalMinor,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  bool valid,  int discountMinor,  String? message,  String name,  CouponDiscountType? discountType,  int discountValue,  int minOrderAmountMinor,  DateTime? startsAt,  DateTime? endsAt,  int subtotalMinor,  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _CouponPreview() when $default != null:
return $default(_that.code,_that.valid,_that.discountMinor,_that.message,_that.name,_that.discountType,_that.discountValue,_that.minOrderAmountMinor,_that.startsAt,_that.endsAt,_that.subtotalMinor,_that.reason);case _:
  return null;

}
}

}

/// @nodoc


class _CouponPreview extends CouponPreview {
  const _CouponPreview({required this.code, required this.valid, this.discountMinor = 0, this.message, this.name = '', this.discountType, this.discountValue = 0, this.minOrderAmountMinor = 0, this.startsAt, this.endsAt, this.subtotalMinor = 0, this.reason}): super._();
  

@override final  String code;
@override final  bool valid;
@override@JsonKey() final  int discountMinor;
@override final  String? message;
@override@JsonKey() final  String name;
@override final  CouponDiscountType? discountType;
@override@JsonKey() final  int discountValue;
@override@JsonKey() final  int minOrderAmountMinor;
@override final  DateTime? startsAt;
@override final  DateTime? endsAt;
@override@JsonKey() final  int subtotalMinor;
/// Structured failure code (`not_found`, `inactive`, `not_started`,
/// `expired`, `min_order_not_met`, `empty_cart`, `not_authenticated`).
@override final  String? reason;

/// Create a copy of CouponPreview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CouponPreviewCopyWith<_CouponPreview> get copyWith => __$CouponPreviewCopyWithImpl<_CouponPreview>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CouponPreview&&(identical(other.code, code) || other.code == code)&&(identical(other.valid, valid) || other.valid == valid)&&(identical(other.discountMinor, discountMinor) || other.discountMinor == discountMinor)&&(identical(other.message, message) || other.message == message)&&(identical(other.name, name) || other.name == name)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.minOrderAmountMinor, minOrderAmountMinor) || other.minOrderAmountMinor == minOrderAmountMinor)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.subtotalMinor, subtotalMinor) || other.subtotalMinor == subtotalMinor)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,code,valid,discountMinor,message,name,discountType,discountValue,minOrderAmountMinor,startsAt,endsAt,subtotalMinor,reason);

@override
String toString() {
  return 'CouponPreview(code: $code, valid: $valid, discountMinor: $discountMinor, message: $message, name: $name, discountType: $discountType, discountValue: $discountValue, minOrderAmountMinor: $minOrderAmountMinor, startsAt: $startsAt, endsAt: $endsAt, subtotalMinor: $subtotalMinor, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$CouponPreviewCopyWith<$Res> implements $CouponPreviewCopyWith<$Res> {
  factory _$CouponPreviewCopyWith(_CouponPreview value, $Res Function(_CouponPreview) _then) = __$CouponPreviewCopyWithImpl;
@override @useResult
$Res call({
 String code, bool valid, int discountMinor, String? message, String name, CouponDiscountType? discountType, int discountValue, int minOrderAmountMinor, DateTime? startsAt, DateTime? endsAt, int subtotalMinor, String? reason
});




}
/// @nodoc
class __$CouponPreviewCopyWithImpl<$Res>
    implements _$CouponPreviewCopyWith<$Res> {
  __$CouponPreviewCopyWithImpl(this._self, this._then);

  final _CouponPreview _self;
  final $Res Function(_CouponPreview) _then;

/// Create a copy of CouponPreview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? valid = null,Object? discountMinor = null,Object? message = freezed,Object? name = null,Object? discountType = freezed,Object? discountValue = null,Object? minOrderAmountMinor = null,Object? startsAt = freezed,Object? endsAt = freezed,Object? subtotalMinor = null,Object? reason = freezed,}) {
  return _then(_CouponPreview(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,valid: null == valid ? _self.valid : valid // ignore: cast_nullable_to_non_nullable
as bool,discountMinor: null == discountMinor ? _self.discountMinor : discountMinor // ignore: cast_nullable_to_non_nullable
as int,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,discountType: freezed == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as CouponDiscountType?,discountValue: null == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as int,minOrderAmountMinor: null == minOrderAmountMinor ? _self.minOrderAmountMinor : minOrderAmountMinor // ignore: cast_nullable_to_non_nullable
as int,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,subtotalMinor: null == subtotalMinor ? _self.subtotalMinor : subtotalMinor // ignore: cast_nullable_to_non_nullable
as int,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
