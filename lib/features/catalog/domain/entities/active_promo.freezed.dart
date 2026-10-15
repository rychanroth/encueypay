// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'active_promo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActivePromo {

 CatalogPromoScope get scope; CatalogPromoType get discountType; int get discountValue; String? get brandId;
/// Create a copy of ActivePromo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivePromoCopyWith<ActivePromo> get copyWith => _$ActivePromoCopyWithImpl<ActivePromo>(this as ActivePromo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivePromo&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.brandId, brandId) || other.brandId == brandId));
}


@override
int get hashCode => Object.hash(runtimeType,scope,discountType,discountValue,brandId);

@override
String toString() {
  return 'ActivePromo(scope: $scope, discountType: $discountType, discountValue: $discountValue, brandId: $brandId)';
}


}

/// @nodoc
abstract mixin class $ActivePromoCopyWith<$Res>  {
  factory $ActivePromoCopyWith(ActivePromo value, $Res Function(ActivePromo) _then) = _$ActivePromoCopyWithImpl;
@useResult
$Res call({
 CatalogPromoScope scope, CatalogPromoType discountType, int discountValue, String? brandId
});




}
/// @nodoc
class _$ActivePromoCopyWithImpl<$Res>
    implements $ActivePromoCopyWith<$Res> {
  _$ActivePromoCopyWithImpl(this._self, this._then);

  final ActivePromo _self;
  final $Res Function(ActivePromo) _then;

/// Create a copy of ActivePromo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scope = null,Object? discountType = null,Object? discountValue = null,Object? brandId = freezed,}) {
  return _then(ActivePromo(
scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as CatalogPromoScope,discountType: null == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as CatalogPromoType,discountValue: null == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as int,brandId: freezed == brandId ? _self.brandId : brandId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivePromo].
extension ActivePromoPatterns on ActivePromo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivePromo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivePromo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivePromo value)  $default,){
final _that = this;
switch (_that) {
case _ActivePromo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivePromo value)?  $default,){
final _that = this;
switch (_that) {
case _ActivePromo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CatalogPromoScope scope,  CatalogPromoType discountType,  int discountValue,  String? brandId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivePromo() when $default != null:
return $default(_that.scope,_that.discountType,_that.discountValue,_that.brandId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CatalogPromoScope scope,  CatalogPromoType discountType,  int discountValue,  String? brandId)  $default,) {final _that = this;
switch (_that) {
case _ActivePromo():
return $default(_that.scope,_that.discountType,_that.discountValue,_that.brandId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CatalogPromoScope scope,  CatalogPromoType discountType,  int discountValue,  String? brandId)?  $default,) {final _that = this;
switch (_that) {
case _ActivePromo() when $default != null:
return $default(_that.scope,_that.discountType,_that.discountValue,_that.brandId);case _:
  return null;

}
}

}

/// @nodoc


class _ActivePromo extends ActivePromo {
  const _ActivePromo({required this.scope, required this.discountType, required this.discountValue, this.brandId}): super._();
  

@override final  CatalogPromoScope scope;
@override final  CatalogPromoType discountType;
@override final  int discountValue;
@override final  String? brandId;

/// Create a copy of ActivePromo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivePromoCopyWith<_ActivePromo> get copyWith => __$ActivePromoCopyWithImpl<_ActivePromo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivePromo&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.brandId, brandId) || other.brandId == brandId));
}


@override
int get hashCode => Object.hash(runtimeType,scope,discountType,discountValue,brandId);

@override
String toString() {
  return 'ActivePromo(scope: $scope, discountType: $discountType, discountValue: $discountValue, brandId: $brandId)';
}


}

/// @nodoc
abstract mixin class _$ActivePromoCopyWith<$Res> implements $ActivePromoCopyWith<$Res> {
  factory _$ActivePromoCopyWith(_ActivePromo value, $Res Function(_ActivePromo) _then) = __$ActivePromoCopyWithImpl;
@override @useResult
$Res call({
 CatalogPromoScope scope, CatalogPromoType discountType, int discountValue, String? brandId
});




}
/// @nodoc
class __$ActivePromoCopyWithImpl<$Res>
    implements _$ActivePromoCopyWith<$Res> {
  __$ActivePromoCopyWithImpl(this._self, this._then);

  final _ActivePromo _self;
  final $Res Function(_ActivePromo) _then;

/// Create a copy of ActivePromo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scope = null,Object? discountType = null,Object? discountValue = null,Object? brandId = freezed,}) {
  return _then(_ActivePromo(
scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as CatalogPromoScope,discountType: null == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as CatalogPromoType,discountValue: null == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as int,brandId: freezed == brandId ? _self.brandId : brandId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
