// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'active_sale.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActiveSale {

 CatalogSaleScope get scope; CatalogSaleType get discountType; int get discountValue; String? get brandId; String? get categoryId;
/// Create a copy of ActiveSale
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActiveSaleCopyWith<ActiveSale> get copyWith => _$ActiveSaleCopyWithImpl<ActiveSale>(this as ActiveSale, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActiveSale&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.brandId, brandId) || other.brandId == brandId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}


@override
int get hashCode => Object.hash(runtimeType,scope,discountType,discountValue,brandId,categoryId);

@override
String toString() {
  return 'ActiveSale(scope: $scope, discountType: $discountType, discountValue: $discountValue, brandId: $brandId, categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class $ActiveSaleCopyWith<$Res>  {
  factory $ActiveSaleCopyWith(ActiveSale value, $Res Function(ActiveSale) _then) = _$ActiveSaleCopyWithImpl;
@useResult
$Res call({
 CatalogSaleScope scope, CatalogSaleType discountType, int discountValue, String? brandId, String? categoryId
});




}
/// @nodoc
class _$ActiveSaleCopyWithImpl<$Res>
    implements $ActiveSaleCopyWith<$Res> {
  _$ActiveSaleCopyWithImpl(this._self, this._then);

  final ActiveSale _self;
  final $Res Function(ActiveSale) _then;

/// Create a copy of ActiveSale
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scope = null,Object? discountType = null,Object? discountValue = null,Object? brandId = freezed,Object? categoryId = freezed,}) {
  return _then(ActiveSale(
scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as CatalogSaleScope,discountType: null == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as CatalogSaleType,discountValue: null == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as int,brandId: freezed == brandId ? _self.brandId : brandId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActiveSale].
extension ActiveSalePatterns on ActiveSale {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActiveSale value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActiveSale() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActiveSale value)  $default,){
final _that = this;
switch (_that) {
case _ActiveSale():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActiveSale value)?  $default,){
final _that = this;
switch (_that) {
case _ActiveSale() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CatalogSaleScope scope,  CatalogSaleType discountType,  int discountValue,  String? brandId,  String? categoryId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActiveSale() when $default != null:
return $default(_that.scope,_that.discountType,_that.discountValue,_that.brandId,_that.categoryId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CatalogSaleScope scope,  CatalogSaleType discountType,  int discountValue,  String? brandId,  String? categoryId)  $default,) {final _that = this;
switch (_that) {
case _ActiveSale():
return $default(_that.scope,_that.discountType,_that.discountValue,_that.brandId,_that.categoryId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CatalogSaleScope scope,  CatalogSaleType discountType,  int discountValue,  String? brandId,  String? categoryId)?  $default,) {final _that = this;
switch (_that) {
case _ActiveSale() when $default != null:
return $default(_that.scope,_that.discountType,_that.discountValue,_that.brandId,_that.categoryId);case _:
  return null;

}
}

}

/// @nodoc


class _ActiveSale extends ActiveSale {
  const _ActiveSale({required this.scope, required this.discountType, required this.discountValue, this.brandId, this.categoryId}): super._();
  

@override final  CatalogSaleScope scope;
@override final  CatalogSaleType discountType;
@override final  int discountValue;
@override final  String? brandId;
@override final  String? categoryId;

/// Create a copy of ActiveSale
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActiveSaleCopyWith<_ActiveSale> get copyWith => __$ActiveSaleCopyWithImpl<_ActiveSale>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActiveSale&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.brandId, brandId) || other.brandId == brandId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}


@override
int get hashCode => Object.hash(runtimeType,scope,discountType,discountValue,brandId,categoryId);

@override
String toString() {
  return 'ActiveSale(scope: $scope, discountType: $discountType, discountValue: $discountValue, brandId: $brandId, categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class _$ActiveSaleCopyWith<$Res> implements $ActiveSaleCopyWith<$Res> {
  factory _$ActiveSaleCopyWith(_ActiveSale value, $Res Function(_ActiveSale) _then) = __$ActiveSaleCopyWithImpl;
@override @useResult
$Res call({
 CatalogSaleScope scope, CatalogSaleType discountType, int discountValue, String? brandId, String? categoryId
});




}
/// @nodoc
class __$ActiveSaleCopyWithImpl<$Res>
    implements _$ActiveSaleCopyWith<$Res> {
  __$ActiveSaleCopyWithImpl(this._self, this._then);

  final _ActiveSale _self;
  final $Res Function(_ActiveSale) _then;

/// Create a copy of ActiveSale
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scope = null,Object? discountType = null,Object? discountValue = null,Object? brandId = freezed,Object? categoryId = freezed,}) {
  return _then(_ActiveSale(
scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as CatalogSaleScope,discountType: null == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as CatalogSaleType,discountValue: null == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as int,brandId: freezed == brandId ? _self.brandId : brandId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
