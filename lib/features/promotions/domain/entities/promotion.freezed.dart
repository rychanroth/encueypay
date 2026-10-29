// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'promotion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ManagedSale {

 String get id; String get name; String get description; SaleScope get scope; PromoDiscountType get discountType; int get discountValue; bool get active; DateTime? get startsAt; DateTime? get endsAt; String? get brandName; String? get categoryName;
/// Create a copy of ManagedSale
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ManagedSaleCopyWith<ManagedSale> get copyWith => _$ManagedSaleCopyWithImpl<ManagedSale>(this as ManagedSale, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ManagedSale&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.active, active) || other.active == active)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,scope,discountType,discountValue,active,startsAt,endsAt,brandName,categoryName);

@override
String toString() {
  return 'ManagedSale(id: $id, name: $name, description: $description, scope: $scope, discountType: $discountType, discountValue: $discountValue, active: $active, startsAt: $startsAt, endsAt: $endsAt, brandName: $brandName, categoryName: $categoryName)';
}


}

/// @nodoc
abstract mixin class $ManagedSaleCopyWith<$Res>  {
  factory $ManagedSaleCopyWith(ManagedSale value, $Res Function(ManagedSale) _then) = _$ManagedSaleCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, SaleScope scope, PromoDiscountType discountType, int discountValue, bool active, DateTime? startsAt, DateTime? endsAt, String? brandName, String? categoryName
});




}
/// @nodoc
class _$ManagedSaleCopyWithImpl<$Res>
    implements $ManagedSaleCopyWith<$Res> {
  _$ManagedSaleCopyWithImpl(this._self, this._then);

  final ManagedSale _self;
  final $Res Function(ManagedSale) _then;

/// Create a copy of ManagedSale
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? scope = null,Object? discountType = null,Object? discountValue = null,Object? active = null,Object? startsAt = freezed,Object? endsAt = freezed,Object? brandName = freezed,Object? categoryName = freezed,}) {
  return _then(ManagedSale(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as SaleScope,discountType: null == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as PromoDiscountType,discountValue: null == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as int,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,brandName: freezed == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ManagedSale].
extension ManagedSalePatterns on ManagedSale {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ManagedSale value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ManagedSale() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ManagedSale value)  $default,){
final _that = this;
switch (_that) {
case _ManagedSale():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ManagedSale value)?  $default,){
final _that = this;
switch (_that) {
case _ManagedSale() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  SaleScope scope,  PromoDiscountType discountType,  int discountValue,  bool active,  DateTime? startsAt,  DateTime? endsAt,  String? brandName,  String? categoryName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ManagedSale() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.scope,_that.discountType,_that.discountValue,_that.active,_that.startsAt,_that.endsAt,_that.brandName,_that.categoryName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  SaleScope scope,  PromoDiscountType discountType,  int discountValue,  bool active,  DateTime? startsAt,  DateTime? endsAt,  String? brandName,  String? categoryName)  $default,) {final _that = this;
switch (_that) {
case _ManagedSale():
return $default(_that.id,_that.name,_that.description,_that.scope,_that.discountType,_that.discountValue,_that.active,_that.startsAt,_that.endsAt,_that.brandName,_that.categoryName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  SaleScope scope,  PromoDiscountType discountType,  int discountValue,  bool active,  DateTime? startsAt,  DateTime? endsAt,  String? brandName,  String? categoryName)?  $default,) {final _that = this;
switch (_that) {
case _ManagedSale() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.scope,_that.discountType,_that.discountValue,_that.active,_that.startsAt,_that.endsAt,_that.brandName,_that.categoryName);case _:
  return null;

}
}

}

/// @nodoc


class _ManagedSale implements ManagedSale {
  const _ManagedSale({required this.id, required this.name, this.description = '', required this.scope, required this.discountType, required this.discountValue, this.active = true, this.startsAt, this.endsAt, this.brandName, this.categoryName});
  

@override final  String id;
@override final  String name;
@override@JsonKey() final  String description;
@override final  SaleScope scope;
@override final  PromoDiscountType discountType;
@override final  int discountValue;
@override@JsonKey() final  bool active;
@override final  DateTime? startsAt;
@override final  DateTime? endsAt;
@override final  String? brandName;
@override final  String? categoryName;

/// Create a copy of ManagedSale
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ManagedSaleCopyWith<_ManagedSale> get copyWith => __$ManagedSaleCopyWithImpl<_ManagedSale>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ManagedSale&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.active, active) || other.active == active)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,scope,discountType,discountValue,active,startsAt,endsAt,brandName,categoryName);

@override
String toString() {
  return 'ManagedSale(id: $id, name: $name, description: $description, scope: $scope, discountType: $discountType, discountValue: $discountValue, active: $active, startsAt: $startsAt, endsAt: $endsAt, brandName: $brandName, categoryName: $categoryName)';
}


}

/// @nodoc
abstract mixin class _$ManagedSaleCopyWith<$Res> implements $ManagedSaleCopyWith<$Res> {
  factory _$ManagedSaleCopyWith(_ManagedSale value, $Res Function(_ManagedSale) _then) = __$ManagedSaleCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, SaleScope scope, PromoDiscountType discountType, int discountValue, bool active, DateTime? startsAt, DateTime? endsAt, String? brandName, String? categoryName
});




}
/// @nodoc
class __$ManagedSaleCopyWithImpl<$Res>
    implements _$ManagedSaleCopyWith<$Res> {
  __$ManagedSaleCopyWithImpl(this._self, this._then);

  final _ManagedSale _self;
  final $Res Function(_ManagedSale) _then;

/// Create a copy of ManagedSale
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? scope = null,Object? discountType = null,Object? discountValue = null,Object? active = null,Object? startsAt = freezed,Object? endsAt = freezed,Object? brandName = freezed,Object? categoryName = freezed,}) {
  return _then(_ManagedSale(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as SaleScope,discountType: null == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as PromoDiscountType,discountValue: null == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as int,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,brandName: freezed == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ManagedCoupon {

 String get id; String get name; String get code; PromoDiscountType get discountType; int get discountValue; int get minOrderAmountMinor; bool get active; DateTime? get startsAt; DateTime? get endsAt;
/// Create a copy of ManagedCoupon
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ManagedCouponCopyWith<ManagedCoupon> get copyWith => _$ManagedCouponCopyWithImpl<ManagedCoupon>(this as ManagedCoupon, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ManagedCoupon&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.code, code) || other.code == code)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.minOrderAmountMinor, minOrderAmountMinor) || other.minOrderAmountMinor == minOrderAmountMinor)&&(identical(other.active, active) || other.active == active)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,code,discountType,discountValue,minOrderAmountMinor,active,startsAt,endsAt);

@override
String toString() {
  return 'ManagedCoupon(id: $id, name: $name, code: $code, discountType: $discountType, discountValue: $discountValue, minOrderAmountMinor: $minOrderAmountMinor, active: $active, startsAt: $startsAt, endsAt: $endsAt)';
}


}

/// @nodoc
abstract mixin class $ManagedCouponCopyWith<$Res>  {
  factory $ManagedCouponCopyWith(ManagedCoupon value, $Res Function(ManagedCoupon) _then) = _$ManagedCouponCopyWithImpl;
@useResult
$Res call({
 String id, String name, String code, PromoDiscountType discountType, int discountValue, int minOrderAmountMinor, bool active, DateTime? startsAt, DateTime? endsAt
});




}
/// @nodoc
class _$ManagedCouponCopyWithImpl<$Res>
    implements $ManagedCouponCopyWith<$Res> {
  _$ManagedCouponCopyWithImpl(this._self, this._then);

  final ManagedCoupon _self;
  final $Res Function(ManagedCoupon) _then;

/// Create a copy of ManagedCoupon
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? code = null,Object? discountType = null,Object? discountValue = null,Object? minOrderAmountMinor = null,Object? active = null,Object? startsAt = freezed,Object? endsAt = freezed,}) {
  return _then(ManagedCoupon(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,discountType: null == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as PromoDiscountType,discountValue: null == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as int,minOrderAmountMinor: null == minOrderAmountMinor ? _self.minOrderAmountMinor : minOrderAmountMinor // ignore: cast_nullable_to_non_nullable
as int,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ManagedCoupon].
extension ManagedCouponPatterns on ManagedCoupon {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ManagedCoupon value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ManagedCoupon() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ManagedCoupon value)  $default,){
final _that = this;
switch (_that) {
case _ManagedCoupon():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ManagedCoupon value)?  $default,){
final _that = this;
switch (_that) {
case _ManagedCoupon() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String code,  PromoDiscountType discountType,  int discountValue,  int minOrderAmountMinor,  bool active,  DateTime? startsAt,  DateTime? endsAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ManagedCoupon() when $default != null:
return $default(_that.id,_that.name,_that.code,_that.discountType,_that.discountValue,_that.minOrderAmountMinor,_that.active,_that.startsAt,_that.endsAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String code,  PromoDiscountType discountType,  int discountValue,  int minOrderAmountMinor,  bool active,  DateTime? startsAt,  DateTime? endsAt)  $default,) {final _that = this;
switch (_that) {
case _ManagedCoupon():
return $default(_that.id,_that.name,_that.code,_that.discountType,_that.discountValue,_that.minOrderAmountMinor,_that.active,_that.startsAt,_that.endsAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String code,  PromoDiscountType discountType,  int discountValue,  int minOrderAmountMinor,  bool active,  DateTime? startsAt,  DateTime? endsAt)?  $default,) {final _that = this;
switch (_that) {
case _ManagedCoupon() when $default != null:
return $default(_that.id,_that.name,_that.code,_that.discountType,_that.discountValue,_that.minOrderAmountMinor,_that.active,_that.startsAt,_that.endsAt);case _:
  return null;

}
}

}

/// @nodoc


class _ManagedCoupon implements ManagedCoupon {
  const _ManagedCoupon({required this.id, this.name = '', required this.code, required this.discountType, required this.discountValue, this.minOrderAmountMinor = 0, this.active = true, this.startsAt, this.endsAt});
  

@override final  String id;
@override@JsonKey() final  String name;
@override final  String code;
@override final  PromoDiscountType discountType;
@override final  int discountValue;
@override@JsonKey() final  int minOrderAmountMinor;
@override@JsonKey() final  bool active;
@override final  DateTime? startsAt;
@override final  DateTime? endsAt;

/// Create a copy of ManagedCoupon
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ManagedCouponCopyWith<_ManagedCoupon> get copyWith => __$ManagedCouponCopyWithImpl<_ManagedCoupon>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ManagedCoupon&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.code, code) || other.code == code)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.minOrderAmountMinor, minOrderAmountMinor) || other.minOrderAmountMinor == minOrderAmountMinor)&&(identical(other.active, active) || other.active == active)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,code,discountType,discountValue,minOrderAmountMinor,active,startsAt,endsAt);

@override
String toString() {
  return 'ManagedCoupon(id: $id, name: $name, code: $code, discountType: $discountType, discountValue: $discountValue, minOrderAmountMinor: $minOrderAmountMinor, active: $active, startsAt: $startsAt, endsAt: $endsAt)';
}


}

/// @nodoc
abstract mixin class _$ManagedCouponCopyWith<$Res> implements $ManagedCouponCopyWith<$Res> {
  factory _$ManagedCouponCopyWith(_ManagedCoupon value, $Res Function(_ManagedCoupon) _then) = __$ManagedCouponCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String code, PromoDiscountType discountType, int discountValue, int minOrderAmountMinor, bool active, DateTime? startsAt, DateTime? endsAt
});




}
/// @nodoc
class __$ManagedCouponCopyWithImpl<$Res>
    implements _$ManagedCouponCopyWith<$Res> {
  __$ManagedCouponCopyWithImpl(this._self, this._then);

  final _ManagedCoupon _self;
  final $Res Function(_ManagedCoupon) _then;

/// Create a copy of ManagedCoupon
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? code = null,Object? discountType = null,Object? discountValue = null,Object? minOrderAmountMinor = null,Object? active = null,Object? startsAt = freezed,Object? endsAt = freezed,}) {
  return _then(_ManagedCoupon(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,discountType: null == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as PromoDiscountType,discountValue: null == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as int,minOrderAmountMinor: null == minOrderAmountMinor ? _self.minOrderAmountMinor : minOrderAmountMinor // ignore: cast_nullable_to_non_nullable
as int,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$ManagedBanner {

 String get id; String get name; String get imageUrl; BannerStatus get status; DateTime? get startsAt; DateTime? get endsAt;
/// Create a copy of ManagedBanner
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ManagedBannerCopyWith<ManagedBanner> get copyWith => _$ManagedBannerCopyWithImpl<ManagedBanner>(this as ManagedBanner, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ManagedBanner&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,imageUrl,status,startsAt,endsAt);

@override
String toString() {
  return 'ManagedBanner(id: $id, name: $name, imageUrl: $imageUrl, status: $status, startsAt: $startsAt, endsAt: $endsAt)';
}


}

/// @nodoc
abstract mixin class $ManagedBannerCopyWith<$Res>  {
  factory $ManagedBannerCopyWith(ManagedBanner value, $Res Function(ManagedBanner) _then) = _$ManagedBannerCopyWithImpl;
@useResult
$Res call({
 String id, String name, String imageUrl, BannerStatus status, DateTime? startsAt, DateTime? endsAt
});




}
/// @nodoc
class _$ManagedBannerCopyWithImpl<$Res>
    implements $ManagedBannerCopyWith<$Res> {
  _$ManagedBannerCopyWithImpl(this._self, this._then);

  final ManagedBanner _self;
  final $Res Function(ManagedBanner) _then;

/// Create a copy of ManagedBanner
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? imageUrl = null,Object? status = null,Object? startsAt = freezed,Object? endsAt = freezed,}) {
  return _then(ManagedBanner(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BannerStatus,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ManagedBanner].
extension ManagedBannerPatterns on ManagedBanner {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ManagedBanner value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ManagedBanner() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ManagedBanner value)  $default,){
final _that = this;
switch (_that) {
case _ManagedBanner():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ManagedBanner value)?  $default,){
final _that = this;
switch (_that) {
case _ManagedBanner() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String imageUrl,  BannerStatus status,  DateTime? startsAt,  DateTime? endsAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ManagedBanner() when $default != null:
return $default(_that.id,_that.name,_that.imageUrl,_that.status,_that.startsAt,_that.endsAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String imageUrl,  BannerStatus status,  DateTime? startsAt,  DateTime? endsAt)  $default,) {final _that = this;
switch (_that) {
case _ManagedBanner():
return $default(_that.id,_that.name,_that.imageUrl,_that.status,_that.startsAt,_that.endsAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String imageUrl,  BannerStatus status,  DateTime? startsAt,  DateTime? endsAt)?  $default,) {final _that = this;
switch (_that) {
case _ManagedBanner() when $default != null:
return $default(_that.id,_that.name,_that.imageUrl,_that.status,_that.startsAt,_that.endsAt);case _:
  return null;

}
}

}

/// @nodoc


class _ManagedBanner implements ManagedBanner {
  const _ManagedBanner({required this.id, required this.name, required this.imageUrl, required this.status, this.startsAt, this.endsAt});
  

@override final  String id;
@override final  String name;
@override final  String imageUrl;
@override final  BannerStatus status;
@override final  DateTime? startsAt;
@override final  DateTime? endsAt;

/// Create a copy of ManagedBanner
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ManagedBannerCopyWith<_ManagedBanner> get copyWith => __$ManagedBannerCopyWithImpl<_ManagedBanner>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ManagedBanner&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,imageUrl,status,startsAt,endsAt);

@override
String toString() {
  return 'ManagedBanner(id: $id, name: $name, imageUrl: $imageUrl, status: $status, startsAt: $startsAt, endsAt: $endsAt)';
}


}

/// @nodoc
abstract mixin class _$ManagedBannerCopyWith<$Res> implements $ManagedBannerCopyWith<$Res> {
  factory _$ManagedBannerCopyWith(_ManagedBanner value, $Res Function(_ManagedBanner) _then) = __$ManagedBannerCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String imageUrl, BannerStatus status, DateTime? startsAt, DateTime? endsAt
});




}
/// @nodoc
class __$ManagedBannerCopyWithImpl<$Res>
    implements _$ManagedBannerCopyWith<$Res> {
  __$ManagedBannerCopyWithImpl(this._self, this._then);

  final _ManagedBanner _self;
  final $Res Function(_ManagedBanner) _then;

/// Create a copy of ManagedBanner
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? imageUrl = null,Object? status = null,Object? startsAt = freezed,Object? endsAt = freezed,}) {
  return _then(_ManagedBanner(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BannerStatus,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$PromoBrandRef {

 String get id; String get name;
/// Create a copy of PromoBrandRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromoBrandRefCopyWith<PromoBrandRef> get copyWith => _$PromoBrandRefCopyWithImpl<PromoBrandRef>(this as PromoBrandRef, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromoBrandRef&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'PromoBrandRef(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $PromoBrandRefCopyWith<$Res>  {
  factory $PromoBrandRefCopyWith(PromoBrandRef value, $Res Function(PromoBrandRef) _then) = _$PromoBrandRefCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$PromoBrandRefCopyWithImpl<$Res>
    implements $PromoBrandRefCopyWith<$Res> {
  _$PromoBrandRefCopyWithImpl(this._self, this._then);

  final PromoBrandRef _self;
  final $Res Function(PromoBrandRef) _then;

/// Create a copy of PromoBrandRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(PromoBrandRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PromoBrandRef].
extension PromoBrandRefPatterns on PromoBrandRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PromoBrandRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PromoBrandRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PromoBrandRef value)  $default,){
final _that = this;
switch (_that) {
case _PromoBrandRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PromoBrandRef value)?  $default,){
final _that = this;
switch (_that) {
case _PromoBrandRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PromoBrandRef() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name)  $default,) {final _that = this;
switch (_that) {
case _PromoBrandRef():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _PromoBrandRef() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _PromoBrandRef implements PromoBrandRef {
  const _PromoBrandRef({required this.id, required this.name});
  

@override final  String id;
@override final  String name;

/// Create a copy of PromoBrandRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromoBrandRefCopyWith<_PromoBrandRef> get copyWith => __$PromoBrandRefCopyWithImpl<_PromoBrandRef>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PromoBrandRef&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'PromoBrandRef(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$PromoBrandRefCopyWith<$Res> implements $PromoBrandRefCopyWith<$Res> {
  factory _$PromoBrandRefCopyWith(_PromoBrandRef value, $Res Function(_PromoBrandRef) _then) = __$PromoBrandRefCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$PromoBrandRefCopyWithImpl<$Res>
    implements _$PromoBrandRefCopyWith<$Res> {
  __$PromoBrandRefCopyWithImpl(this._self, this._then);

  final _PromoBrandRef _self;
  final $Res Function(_PromoBrandRef) _then;

/// Create a copy of PromoBrandRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_PromoBrandRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$PromoCategoryRef {

 String get id; String get name;
/// Create a copy of PromoCategoryRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromoCategoryRefCopyWith<PromoCategoryRef> get copyWith => _$PromoCategoryRefCopyWithImpl<PromoCategoryRef>(this as PromoCategoryRef, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromoCategoryRef&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'PromoCategoryRef(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $PromoCategoryRefCopyWith<$Res>  {
  factory $PromoCategoryRefCopyWith(PromoCategoryRef value, $Res Function(PromoCategoryRef) _then) = _$PromoCategoryRefCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$PromoCategoryRefCopyWithImpl<$Res>
    implements $PromoCategoryRefCopyWith<$Res> {
  _$PromoCategoryRefCopyWithImpl(this._self, this._then);

  final PromoCategoryRef _self;
  final $Res Function(PromoCategoryRef) _then;

/// Create a copy of PromoCategoryRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(PromoCategoryRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PromoCategoryRef].
extension PromoCategoryRefPatterns on PromoCategoryRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PromoCategoryRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PromoCategoryRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PromoCategoryRef value)  $default,){
final _that = this;
switch (_that) {
case _PromoCategoryRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PromoCategoryRef value)?  $default,){
final _that = this;
switch (_that) {
case _PromoCategoryRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PromoCategoryRef() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name)  $default,) {final _that = this;
switch (_that) {
case _PromoCategoryRef():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _PromoCategoryRef() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _PromoCategoryRef implements PromoCategoryRef {
  const _PromoCategoryRef({required this.id, required this.name});
  

@override final  String id;
@override final  String name;

/// Create a copy of PromoCategoryRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromoCategoryRefCopyWith<_PromoCategoryRef> get copyWith => __$PromoCategoryRefCopyWithImpl<_PromoCategoryRef>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PromoCategoryRef&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'PromoCategoryRef(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$PromoCategoryRefCopyWith<$Res> implements $PromoCategoryRefCopyWith<$Res> {
  factory _$PromoCategoryRefCopyWith(_PromoCategoryRef value, $Res Function(_PromoCategoryRef) _then) = __$PromoCategoryRefCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$PromoCategoryRefCopyWithImpl<$Res>
    implements _$PromoCategoryRefCopyWith<$Res> {
  __$PromoCategoryRefCopyWithImpl(this._self, this._then);

  final _PromoCategoryRef _self;
  final $Res Function(_PromoCategoryRef) _then;

/// Create a copy of PromoCategoryRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_PromoCategoryRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
