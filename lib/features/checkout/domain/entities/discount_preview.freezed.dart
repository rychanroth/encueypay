// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discount_preview.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DiscountPreview {

 List<CouponPreview> get manual; CouponPreview? get auto; int get totalDiscountMinor;
/// Create a copy of DiscountPreview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscountPreviewCopyWith<DiscountPreview> get copyWith => _$DiscountPreviewCopyWithImpl<DiscountPreview>(this as DiscountPreview, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscountPreview&&const DeepCollectionEquality().equals(other.manual, manual)&&(identical(other.auto, auto) || other.auto == auto)&&(identical(other.totalDiscountMinor, totalDiscountMinor) || other.totalDiscountMinor == totalDiscountMinor));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(manual),auto,totalDiscountMinor);

@override
String toString() {
  return 'DiscountPreview(manual: $manual, auto: $auto, totalDiscountMinor: $totalDiscountMinor)';
}


}

/// @nodoc
abstract mixin class $DiscountPreviewCopyWith<$Res>  {
  factory $DiscountPreviewCopyWith(DiscountPreview value, $Res Function(DiscountPreview) _then) = _$DiscountPreviewCopyWithImpl;
@useResult
$Res call({
 List<CouponPreview> manual, CouponPreview? auto, int totalDiscountMinor
});


$CouponPreviewCopyWith<$Res>? get auto;

}
/// @nodoc
class _$DiscountPreviewCopyWithImpl<$Res>
    implements $DiscountPreviewCopyWith<$Res> {
  _$DiscountPreviewCopyWithImpl(this._self, this._then);

  final DiscountPreview _self;
  final $Res Function(DiscountPreview) _then;

/// Create a copy of DiscountPreview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? manual = null,Object? auto = freezed,Object? totalDiscountMinor = null,}) {
  return _then(DiscountPreview(
manual: null == manual ? _self.manual : manual // ignore: cast_nullable_to_non_nullable
as List<CouponPreview>,auto: freezed == auto ? _self.auto : auto // ignore: cast_nullable_to_non_nullable
as CouponPreview?,totalDiscountMinor: null == totalDiscountMinor ? _self.totalDiscountMinor : totalDiscountMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of DiscountPreview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CouponPreviewCopyWith<$Res>? get auto {
    if (_self.auto == null) {
    return null;
  }

  return $CouponPreviewCopyWith<$Res>(_self.auto!, (value) {
    return _then(_self.copyWith(auto: value));
  });
}
}


/// Adds pattern-matching-related methods to [DiscountPreview].
extension DiscountPreviewPatterns on DiscountPreview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiscountPreview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiscountPreview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiscountPreview value)  $default,){
final _that = this;
switch (_that) {
case _DiscountPreview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiscountPreview value)?  $default,){
final _that = this;
switch (_that) {
case _DiscountPreview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CouponPreview> manual,  CouponPreview? auto,  int totalDiscountMinor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscountPreview() when $default != null:
return $default(_that.manual,_that.auto,_that.totalDiscountMinor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CouponPreview> manual,  CouponPreview? auto,  int totalDiscountMinor)  $default,) {final _that = this;
switch (_that) {
case _DiscountPreview():
return $default(_that.manual,_that.auto,_that.totalDiscountMinor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CouponPreview> manual,  CouponPreview? auto,  int totalDiscountMinor)?  $default,) {final _that = this;
switch (_that) {
case _DiscountPreview() when $default != null:
return $default(_that.manual,_that.auto,_that.totalDiscountMinor);case _:
  return null;

}
}

}

/// @nodoc


class _DiscountPreview implements DiscountPreview {
  const _DiscountPreview({ List<CouponPreview> manual = const [], this.auto, this.totalDiscountMinor = 0}): _manual = manual;
  

 final  List<CouponPreview> _manual;
@override@JsonKey() List<CouponPreview> get manual {
  if (_manual is EqualUnmodifiableListView) return _manual;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_manual);
}

@override final  CouponPreview? auto;
@override@JsonKey() final  int totalDiscountMinor;

/// Create a copy of DiscountPreview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscountPreviewCopyWith<_DiscountPreview> get copyWith => __$DiscountPreviewCopyWithImpl<_DiscountPreview>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscountPreview&&const DeepCollectionEquality().equals(other._manual, _manual)&&(identical(other.auto, auto) || other.auto == auto)&&(identical(other.totalDiscountMinor, totalDiscountMinor) || other.totalDiscountMinor == totalDiscountMinor));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_manual),auto,totalDiscountMinor);

@override
String toString() {
  return 'DiscountPreview(manual: $manual, auto: $auto, totalDiscountMinor: $totalDiscountMinor)';
}


}

/// @nodoc
abstract mixin class _$DiscountPreviewCopyWith<$Res> implements $DiscountPreviewCopyWith<$Res> {
  factory _$DiscountPreviewCopyWith(_DiscountPreview value, $Res Function(_DiscountPreview) _then) = __$DiscountPreviewCopyWithImpl;
@override @useResult
$Res call({
 List<CouponPreview> manual, CouponPreview? auto, int totalDiscountMinor
});


@override $CouponPreviewCopyWith<$Res>? get auto;

}
/// @nodoc
class __$DiscountPreviewCopyWithImpl<$Res>
    implements _$DiscountPreviewCopyWith<$Res> {
  __$DiscountPreviewCopyWithImpl(this._self, this._then);

  final _DiscountPreview _self;
  final $Res Function(_DiscountPreview) _then;

/// Create a copy of DiscountPreview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? manual = null,Object? auto = freezed,Object? totalDiscountMinor = null,}) {
  return _then(_DiscountPreview(
manual: null == manual ? _self._manual : manual // ignore: cast_nullable_to_non_nullable
as List<CouponPreview>,auto: freezed == auto ? _self.auto : auto // ignore: cast_nullable_to_non_nullable
as CouponPreview?,totalDiscountMinor: null == totalDiscountMinor ? _self.totalDiscountMinor : totalDiscountMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of DiscountPreview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CouponPreviewCopyWith<$Res>? get auto {
    if (_self.auto == null) {
    return null;
  }

  return $CouponPreviewCopyWith<$Res>(_self.auto!, (value) {
    return _then(_self.copyWith(auto: value));
  });
}
}

// dart format on
