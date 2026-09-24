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

 String get id; String get name; String get description; PromotionScope get scope; PromoDiscountType get discountType; int get discountValue; bool get isBanner; BannerStatus get bannerStatus; List<MyCoupon> get coupons; String? get bannerUrl; DateTime? get endsAt;
/// Create a copy of MyPromotion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyPromotionCopyWith<MyPromotion> get copyWith => _$MyPromotionCopyWithImpl<MyPromotion>(this as MyPromotion, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyPromotion&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.isBanner, isBanner) || other.isBanner == isBanner)&&(identical(other.bannerStatus, bannerStatus) || other.bannerStatus == bannerStatus)&&const DeepCollectionEquality().equals(other.coupons, coupons)&&(identical(other.bannerUrl, bannerUrl) || other.bannerUrl == bannerUrl)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,scope,discountType,discountValue,isBanner,bannerStatus,const DeepCollectionEquality().hash(coupons),bannerUrl,endsAt);

@override
String toString() {
  return 'MyPromotion(id: $id, name: $name, description: $description, scope: $scope, discountType: $discountType, discountValue: $discountValue, isBanner: $isBanner, bannerStatus: $bannerStatus, coupons: $coupons, bannerUrl: $bannerUrl, endsAt: $endsAt)';
}


}

/// @nodoc
abstract mixin class $MyPromotionCopyWith<$Res>  {
  factory $MyPromotionCopyWith(MyPromotion value, $Res Function(MyPromotion) _then) = _$MyPromotionCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, PromotionScope scope, PromoDiscountType discountType, int discountValue, bool isBanner, BannerStatus bannerStatus, List<MyCoupon> coupons, String? bannerUrl, DateTime? endsAt
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? scope = null,Object? discountType = null,Object? discountValue = null,Object? isBanner = null,Object? bannerStatus = null,Object? coupons = null,Object? bannerUrl = freezed,Object? endsAt = freezed,}) {
  return _then(MyPromotion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as PromotionScope,discountType: null == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as PromoDiscountType,discountValue: null == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as int,isBanner: null == isBanner ? _self.isBanner : isBanner // ignore: cast_nullable_to_non_nullable
as bool,bannerStatus: null == bannerStatus ? _self.bannerStatus : bannerStatus // ignore: cast_nullable_to_non_nullable
as BannerStatus,coupons: null == coupons ? _self.coupons : coupons // ignore: cast_nullable_to_non_nullable
as List<MyCoupon>,bannerUrl: freezed == bannerUrl ? _self.bannerUrl : bannerUrl // ignore: cast_nullable_to_non_nullable
as String?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  PromotionScope scope,  PromoDiscountType discountType,  int discountValue,  bool isBanner,  BannerStatus bannerStatus,  List<MyCoupon> coupons,  String? bannerUrl,  DateTime? endsAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyPromotion() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.scope,_that.discountType,_that.discountValue,_that.isBanner,_that.bannerStatus,_that.coupons,_that.bannerUrl,_that.endsAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  PromotionScope scope,  PromoDiscountType discountType,  int discountValue,  bool isBanner,  BannerStatus bannerStatus,  List<MyCoupon> coupons,  String? bannerUrl,  DateTime? endsAt)  $default,) {final _that = this;
switch (_that) {
case _MyPromotion():
return $default(_that.id,_that.name,_that.description,_that.scope,_that.discountType,_that.discountValue,_that.isBanner,_that.bannerStatus,_that.coupons,_that.bannerUrl,_that.endsAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  PromotionScope scope,  PromoDiscountType discountType,  int discountValue,  bool isBanner,  BannerStatus bannerStatus,  List<MyCoupon> coupons,  String? bannerUrl,  DateTime? endsAt)?  $default,) {final _that = this;
switch (_that) {
case _MyPromotion() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.scope,_that.discountType,_that.discountValue,_that.isBanner,_that.bannerStatus,_that.coupons,_that.bannerUrl,_that.endsAt);case _:
  return null;

}
}

}

/// @nodoc


class _MyPromotion implements MyPromotion {
  const _MyPromotion({required this.id, required this.name, this.description = '', required this.scope, required this.discountType, required this.discountValue, required this.isBanner, required this.bannerStatus, required  List<MyCoupon> coupons, this.bannerUrl, this.endsAt}): _coupons = coupons;
  

@override final  String id;
@override final  String name;
@override@JsonKey() final  String description;
@override final  PromotionScope scope;
@override final  PromoDiscountType discountType;
@override final  int discountValue;
@override final  bool isBanner;
@override final  BannerStatus bannerStatus;
 final  List<MyCoupon> _coupons;
@override List<MyCoupon> get coupons {
  if (_coupons is EqualUnmodifiableListView) return _coupons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_coupons);
}

@override final  String? bannerUrl;
@override final  DateTime? endsAt;

/// Create a copy of MyPromotion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyPromotionCopyWith<_MyPromotion> get copyWith => __$MyPromotionCopyWithImpl<_MyPromotion>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyPromotion&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.isBanner, isBanner) || other.isBanner == isBanner)&&(identical(other.bannerStatus, bannerStatus) || other.bannerStatus == bannerStatus)&&const DeepCollectionEquality().equals(other._coupons, _coupons)&&(identical(other.bannerUrl, bannerUrl) || other.bannerUrl == bannerUrl)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,scope,discountType,discountValue,isBanner,bannerStatus,const DeepCollectionEquality().hash(_coupons),bannerUrl,endsAt);

@override
String toString() {
  return 'MyPromotion(id: $id, name: $name, description: $description, scope: $scope, discountType: $discountType, discountValue: $discountValue, isBanner: $isBanner, bannerStatus: $bannerStatus, coupons: $coupons, bannerUrl: $bannerUrl, endsAt: $endsAt)';
}


}

/// @nodoc
abstract mixin class _$MyPromotionCopyWith<$Res> implements $MyPromotionCopyWith<$Res> {
  factory _$MyPromotionCopyWith(_MyPromotion value, $Res Function(_MyPromotion) _then) = __$MyPromotionCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, PromotionScope scope, PromoDiscountType discountType, int discountValue, bool isBanner, BannerStatus bannerStatus, List<MyCoupon> coupons, String? bannerUrl, DateTime? endsAt
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? scope = null,Object? discountType = null,Object? discountValue = null,Object? isBanner = null,Object? bannerStatus = null,Object? coupons = null,Object? bannerUrl = freezed,Object? endsAt = freezed,}) {
  return _then(_MyPromotion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as PromotionScope,discountType: null == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as PromoDiscountType,discountValue: null == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as int,isBanner: null == isBanner ? _self.isBanner : isBanner // ignore: cast_nullable_to_non_nullable
as bool,bannerStatus: null == bannerStatus ? _self.bannerStatus : bannerStatus // ignore: cast_nullable_to_non_nullable
as BannerStatus,coupons: null == coupons ? _self._coupons : coupons // ignore: cast_nullable_to_non_nullable
as List<MyCoupon>,bannerUrl: freezed == bannerUrl ? _self.bannerUrl : bannerUrl // ignore: cast_nullable_to_non_nullable
as String?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$MyCoupon {

 String get id; String get code; bool get active; DateTime? get expiresAt;
/// Create a copy of MyCoupon
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyCouponCopyWith<MyCoupon> get copyWith => _$MyCouponCopyWithImpl<MyCoupon>(this as MyCoupon, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyCoupon&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.active, active) || other.active == active)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,code,active,expiresAt);

@override
String toString() {
  return 'MyCoupon(id: $id, code: $code, active: $active, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $MyCouponCopyWith<$Res>  {
  factory $MyCouponCopyWith(MyCoupon value, $Res Function(MyCoupon) _then) = _$MyCouponCopyWithImpl;
@useResult
$Res call({
 String id, String code, bool active, DateTime? expiresAt
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? active = null,Object? expiresAt = freezed,}) {
  return _then(MyCoupon(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  bool active,  DateTime? expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyCoupon() when $default != null:
return $default(_that.id,_that.code,_that.active,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  bool active,  DateTime? expiresAt)  $default,) {final _that = this;
switch (_that) {
case _MyCoupon():
return $default(_that.id,_that.code,_that.active,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  bool active,  DateTime? expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _MyCoupon() when $default != null:
return $default(_that.id,_that.code,_that.active,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc


class _MyCoupon implements MyCoupon {
  const _MyCoupon({required this.id, required this.code, required this.active, this.expiresAt});
  

@override final  String id;
@override final  String code;
@override final  bool active;
@override final  DateTime? expiresAt;

/// Create a copy of MyCoupon
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyCouponCopyWith<_MyCoupon> get copyWith => __$MyCouponCopyWithImpl<_MyCoupon>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyCoupon&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.active, active) || other.active == active)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,code,active,expiresAt);

@override
String toString() {
  return 'MyCoupon(id: $id, code: $code, active: $active, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$MyCouponCopyWith<$Res> implements $MyCouponCopyWith<$Res> {
  factory _$MyCouponCopyWith(_MyCoupon value, $Res Function(_MyCoupon) _then) = __$MyCouponCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, bool active, DateTime? expiresAt
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? active = null,Object? expiresAt = freezed,}) {
  return _then(_MyCoupon(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
