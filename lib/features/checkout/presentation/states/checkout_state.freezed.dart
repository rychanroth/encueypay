// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CheckoutState {

 List<AddressOption> get addresses; String? get selectedAddressId; CheckoutSummary? get summary; PaymentMethod get method; List<CouponPreview> get coupons; String get note; int get currentStep;
/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckoutStateCopyWith<CheckoutState> get copyWith => _$CheckoutStateCopyWithImpl<CheckoutState>(this as CheckoutState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutState&&const DeepCollectionEquality().equals(other.addresses, addresses)&&(identical(other.selectedAddressId, selectedAddressId) || other.selectedAddressId == selectedAddressId)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.method, method) || other.method == method)&&const DeepCollectionEquality().equals(other.coupons, coupons)&&(identical(other.note, note) || other.note == note)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(addresses),selectedAddressId,summary,method,const DeepCollectionEquality().hash(coupons),note,currentStep);

@override
String toString() {
  return 'CheckoutState(addresses: $addresses, selectedAddressId: $selectedAddressId, summary: $summary, method: $method, coupons: $coupons, note: $note, currentStep: $currentStep)';
}


}

/// @nodoc
abstract mixin class $CheckoutStateCopyWith<$Res>  {
  factory $CheckoutStateCopyWith(CheckoutState value, $Res Function(CheckoutState) _then) = _$CheckoutStateCopyWithImpl;
@useResult
$Res call({
 List<AddressOption> addresses, String? selectedAddressId, CheckoutSummary? summary, PaymentMethod method, List<CouponPreview> coupons, String note, int currentStep
});


$CheckoutSummaryCopyWith<$Res>? get summary;

}
/// @nodoc
class _$CheckoutStateCopyWithImpl<$Res>
    implements $CheckoutStateCopyWith<$Res> {
  _$CheckoutStateCopyWithImpl(this._self, this._then);

  final CheckoutState _self;
  final $Res Function(CheckoutState) _then;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? addresses = null,Object? selectedAddressId = freezed,Object? summary = freezed,Object? method = null,Object? coupons = null,Object? note = null,Object? currentStep = null,}) {
  return _then(CheckoutState(
addresses: null == addresses ? _self.addresses : addresses // ignore: cast_nullable_to_non_nullable
as List<AddressOption>,selectedAddressId: freezed == selectedAddressId ? _self.selectedAddressId : selectedAddressId // ignore: cast_nullable_to_non_nullable
as String?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as CheckoutSummary?,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,coupons: null == coupons ? _self.coupons : coupons // ignore: cast_nullable_to_non_nullable
as List<CouponPreview>,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CheckoutSummaryCopyWith<$Res>? get summary {
    if (_self.summary == null) {
    return null;
  }

  return $CheckoutSummaryCopyWith<$Res>(_self.summary!, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// Adds pattern-matching-related methods to [CheckoutState].
extension CheckoutStatePatterns on CheckoutState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckoutState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckoutState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckoutState value)  $default,){
final _that = this;
switch (_that) {
case _CheckoutState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckoutState value)?  $default,){
final _that = this;
switch (_that) {
case _CheckoutState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AddressOption> addresses,  String? selectedAddressId,  CheckoutSummary? summary,  PaymentMethod method,  List<CouponPreview> coupons,  String note,  int currentStep)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckoutState() when $default != null:
return $default(_that.addresses,_that.selectedAddressId,_that.summary,_that.method,_that.coupons,_that.note,_that.currentStep);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AddressOption> addresses,  String? selectedAddressId,  CheckoutSummary? summary,  PaymentMethod method,  List<CouponPreview> coupons,  String note,  int currentStep)  $default,) {final _that = this;
switch (_that) {
case _CheckoutState():
return $default(_that.addresses,_that.selectedAddressId,_that.summary,_that.method,_that.coupons,_that.note,_that.currentStep);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AddressOption> addresses,  String? selectedAddressId,  CheckoutSummary? summary,  PaymentMethod method,  List<CouponPreview> coupons,  String note,  int currentStep)?  $default,) {final _that = this;
switch (_that) {
case _CheckoutState() when $default != null:
return $default(_that.addresses,_that.selectedAddressId,_that.summary,_that.method,_that.coupons,_that.note,_that.currentStep);case _:
  return null;

}
}

}

/// @nodoc


class _CheckoutState extends CheckoutState {
  const _CheckoutState({ List<AddressOption> addresses = const [], this.selectedAddressId, this.summary, this.method = PaymentMethod.cod,  List<CouponPreview> coupons = const [], this.note = '', this.currentStep = 0}): _addresses = addresses,_coupons = coupons,super._();
  

 final  List<AddressOption> _addresses;
@override@JsonKey() List<AddressOption> get addresses {
  if (_addresses is EqualUnmodifiableListView) return _addresses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_addresses);
}

@override final  String? selectedAddressId;
@override final  CheckoutSummary? summary;
@override@JsonKey() final  PaymentMethod method;
 final  List<CouponPreview> _coupons;
@override@JsonKey() List<CouponPreview> get coupons {
  if (_coupons is EqualUnmodifiableListView) return _coupons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_coupons);
}

@override@JsonKey() final  String note;
@override@JsonKey() final  int currentStep;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckoutStateCopyWith<_CheckoutState> get copyWith => __$CheckoutStateCopyWithImpl<_CheckoutState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckoutState&&const DeepCollectionEquality().equals(other._addresses, _addresses)&&(identical(other.selectedAddressId, selectedAddressId) || other.selectedAddressId == selectedAddressId)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.method, method) || other.method == method)&&const DeepCollectionEquality().equals(other._coupons, _coupons)&&(identical(other.note, note) || other.note == note)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_addresses),selectedAddressId,summary,method,const DeepCollectionEquality().hash(_coupons),note,currentStep);

@override
String toString() {
  return 'CheckoutState(addresses: $addresses, selectedAddressId: $selectedAddressId, summary: $summary, method: $method, coupons: $coupons, note: $note, currentStep: $currentStep)';
}


}

/// @nodoc
abstract mixin class _$CheckoutStateCopyWith<$Res> implements $CheckoutStateCopyWith<$Res> {
  factory _$CheckoutStateCopyWith(_CheckoutState value, $Res Function(_CheckoutState) _then) = __$CheckoutStateCopyWithImpl;
@override @useResult
$Res call({
 List<AddressOption> addresses, String? selectedAddressId, CheckoutSummary? summary, PaymentMethod method, List<CouponPreview> coupons, String note, int currentStep
});


@override $CheckoutSummaryCopyWith<$Res>? get summary;

}
/// @nodoc
class __$CheckoutStateCopyWithImpl<$Res>
    implements _$CheckoutStateCopyWith<$Res> {
  __$CheckoutStateCopyWithImpl(this._self, this._then);

  final _CheckoutState _self;
  final $Res Function(_CheckoutState) _then;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? addresses = null,Object? selectedAddressId = freezed,Object? summary = freezed,Object? method = null,Object? coupons = null,Object? note = null,Object? currentStep = null,}) {
  return _then(_CheckoutState(
addresses: null == addresses ? _self._addresses : addresses // ignore: cast_nullable_to_non_nullable
as List<AddressOption>,selectedAddressId: freezed == selectedAddressId ? _self.selectedAddressId : selectedAddressId // ignore: cast_nullable_to_non_nullable
as String?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as CheckoutSummary?,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,coupons: null == coupons ? _self._coupons : coupons // ignore: cast_nullable_to_non_nullable
as List<CouponPreview>,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CheckoutSummaryCopyWith<$Res>? get summary {
    if (_self.summary == null) {
    return null;
  }

  return $CheckoutSummaryCopyWith<$Res>(_self.summary!, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}

// dart format on
