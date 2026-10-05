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
mixin _$MyPromotion {

 String get id; String get name; String get description; PromotionScope get scope; PromoDiscountType get discountType; int get discountValue; bool get active; String? get brandName; List<MyCoupon> get coupons;
/// Create a copy of MyPromotion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyPromotionCopyWith<MyPromotion> get copyWith => _$MyPromotionCopyWithImpl<MyPromotion>(this as MyPromotion, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyPromotion&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.active, active) || other.active == active)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&const DeepCollectionEquality().equals(other.coupons, coupons));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,scope,discountType,discountValue,active,brandName,const DeepCollectionEquality().hash(coupons));

@override
String toString() {
  return 'MyPromotion(id: $id, name: $name, description: $description, scope: $scope, discountType: $discountType, discountValue: $discountValue, active: $active, brandName: $brandName, coupons: $coupons)';
}


}

/// @nodoc
abstract mixin class $MyPromotionCopyWith<$Res>  {
  factory $MyPromotionCopyWith(MyPromotion value, $Res Function(MyPromotion) _then) = _$MyPromotionCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, PromotionScope scope, PromoDiscountType discountType, int discountValue, bool active, String? brandName, List<MyCoupon> coupons
});




}
/// @nodoc
class _$MyPromotionCopyWithImpl<$Res>
    implements $MyPromotionCopyWith<$Res> {
  _$MyPromotionCopyWithImpl(this._self, this._then);

  final MyPromotion _self;
  final $Res Function(MyPromotion) _then;

/// Create a copy of MyPromotion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? scope = null,Object? discountType = null,Object? discountValue = null,Object? active = null,Object? brandName = freezed,Object? coupons = null,}) {
  return _then(MyPromotion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as PromotionScope,discountType: null == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as PromoDiscountType,discountValue: null == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as int,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,brandName: freezed == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String?,coupons: null == coupons ? _self.coupons : coupons // ignore: cast_nullable_to_non_nullable
as List<MyCoupon>,
  ));
}

}


/// Adds pattern-matching-related methods to [MyPromotion].
extension MyPromotionPatterns on MyPromotion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyPromotion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyPromotion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyPromotion value)  $default,){
final _that = this;
switch (_that) {
case _MyPromotion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyPromotion value)?  $default,){
final _that = this;
switch (_that) {
case _MyPromotion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  PromotionScope scope,  PromoDiscountType discountType,  int discountValue,  bool active,  String? brandName,  List<MyCoupon> coupons)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyPromotion() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.scope,_that.discountType,_that.discountValue,_that.active,_that.brandName,_that.coupons);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  PromotionScope scope,  PromoDiscountType discountType,  int discountValue,  bool active,  String? brandName,  List<MyCoupon> coupons)  $default,) {final _that = this;
switch (_that) {
case _MyPromotion():
return $default(_that.id,_that.name,_that.description,_that.scope,_that.discountType,_that.discountValue,_that.active,_that.brandName,_that.coupons);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  PromotionScope scope,  PromoDiscountType discountType,  int discountValue,  bool active,  String? brandName,  List<MyCoupon> coupons)?  $default,) {final _that = this;
switch (_that) {
case _MyPromotion() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.scope,_that.discountType,_that.discountValue,_that.active,_that.brandName,_that.coupons);case _:
  return null;

}
}

}

/// @nodoc


class _MyPromotion implements MyPromotion {
  const _MyPromotion({required this.id, required this.name, this.description = '', required this.scope, required this.discountType, required this.discountValue, this.active = true, this.brandName,  List<MyCoupon> coupons = const []}): _coupons = coupons;
  

@override final  String id;
@override final  String name;
@override@JsonKey() final  String description;
@override final  PromotionScope scope;
@override final  PromoDiscountType discountType;
@override final  int discountValue;
@override@JsonKey() final  bool active;
@override final  String? brandName;
 final  List<MyCoupon> _coupons;
@override@JsonKey() List<MyCoupon> get coupons {
  if (_coupons is EqualUnmodifiableListView) return _coupons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_coupons);
}


/// Create a copy of MyPromotion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyPromotionCopyWith<_MyPromotion> get copyWith => __$MyPromotionCopyWithImpl<_MyPromotion>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyPromotion&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.active, active) || other.active == active)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&const DeepCollectionEquality().equals(other._coupons, _coupons));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,scope,discountType,discountValue,active,brandName,const DeepCollectionEquality().hash(_coupons));

@override
String toString() {
  return 'MyPromotion(id: $id, name: $name, description: $description, scope: $scope, discountType: $discountType, discountValue: $discountValue, active: $active, brandName: $brandName, coupons: $coupons)';
}


}

/// @nodoc
abstract mixin class _$MyPromotionCopyWith<$Res> implements $MyPromotionCopyWith<$Res> {
  factory _$MyPromotionCopyWith(_MyPromotion value, $Res Function(_MyPromotion) _then) = __$MyPromotionCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, PromotionScope scope, PromoDiscountType discountType, int discountValue, bool active, String? brandName, List<MyCoupon> coupons
});




}
/// @nodoc
class __$MyPromotionCopyWithImpl<$Res>
    implements _$MyPromotionCopyWith<$Res> {
  __$MyPromotionCopyWithImpl(this._self, this._then);

  final _MyPromotion _self;
  final $Res Function(_MyPromotion) _then;

/// Create a copy of MyPromotion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? scope = null,Object? discountType = null,Object? discountValue = null,Object? active = null,Object? brandName = freezed,Object? coupons = null,}) {
  return _then(_MyPromotion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as PromotionScope,discountType: null == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as PromoDiscountType,discountValue: null == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as int,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,brandName: freezed == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String?,coupons: null == coupons ? _self._coupons : coupons // ignore: cast_nullable_to_non_nullable
as List<MyCoupon>,
  ));
}


}

/// @nodoc
mixin _$MyCoupon {

 String get id; String get code; bool get active; int get minOrderAmountMinor; DateTime? get startsAt; DateTime? get endsAt;
/// Create a copy of MyCoupon
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyCouponCopyWith<MyCoupon> get copyWith => _$MyCouponCopyWithImpl<MyCoupon>(this as MyCoupon, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyCoupon&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.active, active) || other.active == active)&&(identical(other.minOrderAmountMinor, minOrderAmountMinor) || other.minOrderAmountMinor == minOrderAmountMinor)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,code,active,minOrderAmountMinor,startsAt,endsAt);

@override
String toString() {
  return 'MyCoupon(id: $id, code: $code, active: $active, minOrderAmountMinor: $minOrderAmountMinor, startsAt: $startsAt, endsAt: $endsAt)';
}


}

/// @nodoc
abstract mixin class $MyCouponCopyWith<$Res>  {
  factory $MyCouponCopyWith(MyCoupon value, $Res Function(MyCoupon) _then) = _$MyCouponCopyWithImpl;
@useResult
$Res call({
 String id, String code, bool active, int minOrderAmountMinor, DateTime? startsAt, DateTime? endsAt
});




}
/// @nodoc
class _$MyCouponCopyWithImpl<$Res>
    implements $MyCouponCopyWith<$Res> {
  _$MyCouponCopyWithImpl(this._self, this._then);

  final MyCoupon _self;
  final $Res Function(MyCoupon) _then;

/// Create a copy of MyCoupon
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? active = null,Object? minOrderAmountMinor = null,Object? startsAt = freezed,Object? endsAt = freezed,}) {
  return _then(MyCoupon(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,minOrderAmountMinor: null == minOrderAmountMinor ? _self.minOrderAmountMinor : minOrderAmountMinor // ignore: cast_nullable_to_non_nullable
as int,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MyCoupon].
extension MyCouponPatterns on MyCoupon {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyCoupon value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyCoupon() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyCoupon value)  $default,){
final _that = this;
switch (_that) {
case _MyCoupon():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyCoupon value)?  $default,){
final _that = this;
switch (_that) {
case _MyCoupon() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  bool active,  int minOrderAmountMinor,  DateTime? startsAt,  DateTime? endsAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyCoupon() when $default != null:
return $default(_that.id,_that.code,_that.active,_that.minOrderAmountMinor,_that.startsAt,_that.endsAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  bool active,  int minOrderAmountMinor,  DateTime? startsAt,  DateTime? endsAt)  $default,) {final _that = this;
switch (_that) {
case _MyCoupon():
return $default(_that.id,_that.code,_that.active,_that.minOrderAmountMinor,_that.startsAt,_that.endsAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  bool active,  int minOrderAmountMinor,  DateTime? startsAt,  DateTime? endsAt)?  $default,) {final _that = this;
switch (_that) {
case _MyCoupon() when $default != null:
return $default(_that.id,_that.code,_that.active,_that.minOrderAmountMinor,_that.startsAt,_that.endsAt);case _:
  return null;

}
}

}

/// @nodoc


class _MyCoupon implements MyCoupon {
  const _MyCoupon({required this.id, required this.code, required this.active, this.minOrderAmountMinor = 0, this.startsAt, this.endsAt});
  

@override final  String id;
@override final  String code;
@override final  bool active;
@override@JsonKey() final  int minOrderAmountMinor;
@override final  DateTime? startsAt;
@override final  DateTime? endsAt;

/// Create a copy of MyCoupon
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyCouponCopyWith<_MyCoupon> get copyWith => __$MyCouponCopyWithImpl<_MyCoupon>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyCoupon&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.active, active) || other.active == active)&&(identical(other.minOrderAmountMinor, minOrderAmountMinor) || other.minOrderAmountMinor == minOrderAmountMinor)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,code,active,minOrderAmountMinor,startsAt,endsAt);

@override
String toString() {
  return 'MyCoupon(id: $id, code: $code, active: $active, minOrderAmountMinor: $minOrderAmountMinor, startsAt: $startsAt, endsAt: $endsAt)';
}


}

/// @nodoc
abstract mixin class _$MyCouponCopyWith<$Res> implements $MyCouponCopyWith<$Res> {
  factory _$MyCouponCopyWith(_MyCoupon value, $Res Function(_MyCoupon) _then) = __$MyCouponCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, bool active, int minOrderAmountMinor, DateTime? startsAt, DateTime? endsAt
});




}
/// @nodoc
class __$MyCouponCopyWithImpl<$Res>
    implements _$MyCouponCopyWith<$Res> {
  __$MyCouponCopyWithImpl(this._self, this._then);

  final _MyCoupon _self;
  final $Res Function(_MyCoupon) _then;

/// Create a copy of MyCoupon
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? active = null,Object? minOrderAmountMinor = null,Object? startsAt = freezed,Object? endsAt = freezed,}) {
  return _then(_MyCoupon(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,minOrderAmountMinor: null == minOrderAmountMinor ? _self.minOrderAmountMinor : minOrderAmountMinor // ignore: cast_nullable_to_non_nullable
as int,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
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

// dart format on
