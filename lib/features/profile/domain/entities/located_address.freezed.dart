// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'located_address.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LocatedAddress {

/// Street line (e.g. "271 Preah Norodom Blvd"); empty when the geocoder
/// could only resolve an administrative area.
 String get line1; String? get city;/// Official 2025 codes when Nominatim output could be matched to the
/// bundled hierarchy. Each level is filled independently.
 String? get provinceCode; String? get provinceName; String? get districtCode; String? get districtName; String? get communeCode; String? get communeName; String? get villageCode; String? get villageName;
/// Create a copy of LocatedAddress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocatedAddressCopyWith<LocatedAddress> get copyWith => _$LocatedAddressCopyWithImpl<LocatedAddress>(this as LocatedAddress, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocatedAddress&&(identical(other.line1, line1) || other.line1 == line1)&&(identical(other.city, city) || other.city == city)&&(identical(other.provinceCode, provinceCode) || other.provinceCode == provinceCode)&&(identical(other.provinceName, provinceName) || other.provinceName == provinceName)&&(identical(other.districtCode, districtCode) || other.districtCode == districtCode)&&(identical(other.districtName, districtName) || other.districtName == districtName)&&(identical(other.communeCode, communeCode) || other.communeCode == communeCode)&&(identical(other.communeName, communeName) || other.communeName == communeName)&&(identical(other.villageCode, villageCode) || other.villageCode == villageCode)&&(identical(other.villageName, villageName) || other.villageName == villageName));
}


@override
int get hashCode => Object.hash(runtimeType,line1,city,provinceCode,provinceName,districtCode,districtName,communeCode,communeName,villageCode,villageName);

@override
String toString() {
  return 'LocatedAddress(line1: $line1, city: $city, provinceCode: $provinceCode, provinceName: $provinceName, districtCode: $districtCode, districtName: $districtName, communeCode: $communeCode, communeName: $communeName, villageCode: $villageCode, villageName: $villageName)';
}


}

/// @nodoc
abstract mixin class $LocatedAddressCopyWith<$Res>  {
  factory $LocatedAddressCopyWith(LocatedAddress value, $Res Function(LocatedAddress) _then) = _$LocatedAddressCopyWithImpl;
@useResult
$Res call({
 String line1, String? city, String? provinceCode, String? provinceName, String? districtCode, String? districtName, String? communeCode, String? communeName, String? villageCode, String? villageName
});




}
/// @nodoc
class _$LocatedAddressCopyWithImpl<$Res>
    implements $LocatedAddressCopyWith<$Res> {
  _$LocatedAddressCopyWithImpl(this._self, this._then);

  final LocatedAddress _self;
  final $Res Function(LocatedAddress) _then;

/// Create a copy of LocatedAddress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? line1 = null,Object? city = freezed,Object? provinceCode = freezed,Object? provinceName = freezed,Object? districtCode = freezed,Object? districtName = freezed,Object? communeCode = freezed,Object? communeName = freezed,Object? villageCode = freezed,Object? villageName = freezed,}) {
  return _then(LocatedAddress(
line1: null == line1 ? _self.line1 : line1 // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,provinceCode: freezed == provinceCode ? _self.provinceCode : provinceCode // ignore: cast_nullable_to_non_nullable
as String?,provinceName: freezed == provinceName ? _self.provinceName : provinceName // ignore: cast_nullable_to_non_nullable
as String?,districtCode: freezed == districtCode ? _self.districtCode : districtCode // ignore: cast_nullable_to_non_nullable
as String?,districtName: freezed == districtName ? _self.districtName : districtName // ignore: cast_nullable_to_non_nullable
as String?,communeCode: freezed == communeCode ? _self.communeCode : communeCode // ignore: cast_nullable_to_non_nullable
as String?,communeName: freezed == communeName ? _self.communeName : communeName // ignore: cast_nullable_to_non_nullable
as String?,villageCode: freezed == villageCode ? _self.villageCode : villageCode // ignore: cast_nullable_to_non_nullable
as String?,villageName: freezed == villageName ? _self.villageName : villageName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LocatedAddress].
extension LocatedAddressPatterns on LocatedAddress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocatedAddress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocatedAddress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocatedAddress value)  $default,){
final _that = this;
switch (_that) {
case _LocatedAddress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocatedAddress value)?  $default,){
final _that = this;
switch (_that) {
case _LocatedAddress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String line1,  String? city,  String? provinceCode,  String? provinceName,  String? districtCode,  String? districtName,  String? communeCode,  String? communeName,  String? villageCode,  String? villageName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocatedAddress() when $default != null:
return $default(_that.line1,_that.city,_that.provinceCode,_that.provinceName,_that.districtCode,_that.districtName,_that.communeCode,_that.communeName,_that.villageCode,_that.villageName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String line1,  String? city,  String? provinceCode,  String? provinceName,  String? districtCode,  String? districtName,  String? communeCode,  String? communeName,  String? villageCode,  String? villageName)  $default,) {final _that = this;
switch (_that) {
case _LocatedAddress():
return $default(_that.line1,_that.city,_that.provinceCode,_that.provinceName,_that.districtCode,_that.districtName,_that.communeCode,_that.communeName,_that.villageCode,_that.villageName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String line1,  String? city,  String? provinceCode,  String? provinceName,  String? districtCode,  String? districtName,  String? communeCode,  String? communeName,  String? villageCode,  String? villageName)?  $default,) {final _that = this;
switch (_that) {
case _LocatedAddress() when $default != null:
return $default(_that.line1,_that.city,_that.provinceCode,_that.provinceName,_that.districtCode,_that.districtName,_that.communeCode,_that.communeName,_that.villageCode,_that.villageName);case _:
  return null;

}
}

}

/// @nodoc


class _LocatedAddress extends LocatedAddress {
  const _LocatedAddress({required this.line1, this.city, this.provinceCode, this.provinceName, this.districtCode, this.districtName, this.communeCode, this.communeName, this.villageCode, this.villageName}): super._();
  

/// Street line (e.g. "271 Preah Norodom Blvd"); empty when the geocoder
/// could only resolve an administrative area.
@override final  String line1;
@override final  String? city;
/// Official 2025 codes when Nominatim output could be matched to the
/// bundled hierarchy. Each level is filled independently.
@override final  String? provinceCode;
@override final  String? provinceName;
@override final  String? districtCode;
@override final  String? districtName;
@override final  String? communeCode;
@override final  String? communeName;
@override final  String? villageCode;
@override final  String? villageName;

/// Create a copy of LocatedAddress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocatedAddressCopyWith<_LocatedAddress> get copyWith => __$LocatedAddressCopyWithImpl<_LocatedAddress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocatedAddress&&(identical(other.line1, line1) || other.line1 == line1)&&(identical(other.city, city) || other.city == city)&&(identical(other.provinceCode, provinceCode) || other.provinceCode == provinceCode)&&(identical(other.provinceName, provinceName) || other.provinceName == provinceName)&&(identical(other.districtCode, districtCode) || other.districtCode == districtCode)&&(identical(other.districtName, districtName) || other.districtName == districtName)&&(identical(other.communeCode, communeCode) || other.communeCode == communeCode)&&(identical(other.communeName, communeName) || other.communeName == communeName)&&(identical(other.villageCode, villageCode) || other.villageCode == villageCode)&&(identical(other.villageName, villageName) || other.villageName == villageName));
}


@override
int get hashCode => Object.hash(runtimeType,line1,city,provinceCode,provinceName,districtCode,districtName,communeCode,communeName,villageCode,villageName);

@override
String toString() {
  return 'LocatedAddress(line1: $line1, city: $city, provinceCode: $provinceCode, provinceName: $provinceName, districtCode: $districtCode, districtName: $districtName, communeCode: $communeCode, communeName: $communeName, villageCode: $villageCode, villageName: $villageName)';
}


}

/// @nodoc
abstract mixin class _$LocatedAddressCopyWith<$Res> implements $LocatedAddressCopyWith<$Res> {
  factory _$LocatedAddressCopyWith(_LocatedAddress value, $Res Function(_LocatedAddress) _then) = __$LocatedAddressCopyWithImpl;
@override @useResult
$Res call({
 String line1, String? city, String? provinceCode, String? provinceName, String? districtCode, String? districtName, String? communeCode, String? communeName, String? villageCode, String? villageName
});




}
/// @nodoc
class __$LocatedAddressCopyWithImpl<$Res>
    implements _$LocatedAddressCopyWith<$Res> {
  __$LocatedAddressCopyWithImpl(this._self, this._then);

  final _LocatedAddress _self;
  final $Res Function(_LocatedAddress) _then;

/// Create a copy of LocatedAddress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? line1 = null,Object? city = freezed,Object? provinceCode = freezed,Object? provinceName = freezed,Object? districtCode = freezed,Object? districtName = freezed,Object? communeCode = freezed,Object? communeName = freezed,Object? villageCode = freezed,Object? villageName = freezed,}) {
  return _then(_LocatedAddress(
line1: null == line1 ? _self.line1 : line1 // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,provinceCode: freezed == provinceCode ? _self.provinceCode : provinceCode // ignore: cast_nullable_to_non_nullable
as String?,provinceName: freezed == provinceName ? _self.provinceName : provinceName // ignore: cast_nullable_to_non_nullable
as String?,districtCode: freezed == districtCode ? _self.districtCode : districtCode // ignore: cast_nullable_to_non_nullable
as String?,districtName: freezed == districtName ? _self.districtName : districtName // ignore: cast_nullable_to_non_nullable
as String?,communeCode: freezed == communeCode ? _self.communeCode : communeCode // ignore: cast_nullable_to_non_nullable
as String?,communeName: freezed == communeName ? _self.communeName : communeName // ignore: cast_nullable_to_non_nullable
as String?,villageCode: freezed == villageCode ? _self.villageCode : villageCode // ignore: cast_nullable_to_non_nullable
as String?,villageName: freezed == villageName ? _self.villageName : villageName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
