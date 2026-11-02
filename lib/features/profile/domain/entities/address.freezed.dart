// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Address {

 String get id; String get label; String get recipientName; String get phone; String get line1; String? get line2; String get city;/// Official 2025 administrative codes (bundled assets/geo data). Null
/// for legacy addresses whose city is still free text.
 String? get provinceCode; String? get districtCode; String? get communeCode; String? get villageCode; double? get latitude; double? get longitude; bool get isDefault;
/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressCopyWith<Address> get copyWith => _$AddressCopyWithImpl<Address>(this as Address, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Address&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.recipientName, recipientName) || other.recipientName == recipientName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.line1, line1) || other.line1 == line1)&&(identical(other.line2, line2) || other.line2 == line2)&&(identical(other.city, city) || other.city == city)&&(identical(other.provinceCode, provinceCode) || other.provinceCode == provinceCode)&&(identical(other.districtCode, districtCode) || other.districtCode == districtCode)&&(identical(other.communeCode, communeCode) || other.communeCode == communeCode)&&(identical(other.villageCode, villageCode) || other.villageCode == villageCode)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}


@override
int get hashCode => Object.hash(runtimeType,id,label,recipientName,phone,line1,line2,city,provinceCode,districtCode,communeCode,villageCode,latitude,longitude,isDefault);

@override
String toString() {
  return 'Address(id: $id, label: $label, recipientName: $recipientName, phone: $phone, line1: $line1, line2: $line2, city: $city, provinceCode: $provinceCode, districtCode: $districtCode, communeCode: $communeCode, villageCode: $villageCode, latitude: $latitude, longitude: $longitude, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class $AddressCopyWith<$Res>  {
  factory $AddressCopyWith(Address value, $Res Function(Address) _then) = _$AddressCopyWithImpl;
@useResult
$Res call({
 String id, String label, String recipientName, String phone, String line1, String? line2, String city, String? provinceCode, String? districtCode, String? communeCode, String? villageCode, double? latitude, double? longitude, bool isDefault
});




}
/// @nodoc
class _$AddressCopyWithImpl<$Res>
    implements $AddressCopyWith<$Res> {
  _$AddressCopyWithImpl(this._self, this._then);

  final Address _self;
  final $Res Function(Address) _then;

/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? recipientName = null,Object? phone = null,Object? line1 = null,Object? line2 = freezed,Object? city = null,Object? provinceCode = freezed,Object? districtCode = freezed,Object? communeCode = freezed,Object? villageCode = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? isDefault = null,}) {
  return _then(Address(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,recipientName: null == recipientName ? _self.recipientName : recipientName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,line1: null == line1 ? _self.line1 : line1 // ignore: cast_nullable_to_non_nullable
as String,line2: freezed == line2 ? _self.line2 : line2 // ignore: cast_nullable_to_non_nullable
as String?,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,provinceCode: freezed == provinceCode ? _self.provinceCode : provinceCode // ignore: cast_nullable_to_non_nullable
as String?,districtCode: freezed == districtCode ? _self.districtCode : districtCode // ignore: cast_nullable_to_non_nullable
as String?,communeCode: freezed == communeCode ? _self.communeCode : communeCode // ignore: cast_nullable_to_non_nullable
as String?,villageCode: freezed == villageCode ? _self.villageCode : villageCode // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Address].
extension AddressPatterns on Address {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Address value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Address() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Address value)  $default,){
final _that = this;
switch (_that) {
case _Address():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Address value)?  $default,){
final _that = this;
switch (_that) {
case _Address() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String label,  String recipientName,  String phone,  String line1,  String? line2,  String city,  String? provinceCode,  String? districtCode,  String? communeCode,  String? villageCode,  double? latitude,  double? longitude,  bool isDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Address() when $default != null:
return $default(_that.id,_that.label,_that.recipientName,_that.phone,_that.line1,_that.line2,_that.city,_that.provinceCode,_that.districtCode,_that.communeCode,_that.villageCode,_that.latitude,_that.longitude,_that.isDefault);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String label,  String recipientName,  String phone,  String line1,  String? line2,  String city,  String? provinceCode,  String? districtCode,  String? communeCode,  String? villageCode,  double? latitude,  double? longitude,  bool isDefault)  $default,) {final _that = this;
switch (_that) {
case _Address():
return $default(_that.id,_that.label,_that.recipientName,_that.phone,_that.line1,_that.line2,_that.city,_that.provinceCode,_that.districtCode,_that.communeCode,_that.villageCode,_that.latitude,_that.longitude,_that.isDefault);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String label,  String recipientName,  String phone,  String line1,  String? line2,  String city,  String? provinceCode,  String? districtCode,  String? communeCode,  String? villageCode,  double? latitude,  double? longitude,  bool isDefault)?  $default,) {final _that = this;
switch (_that) {
case _Address() when $default != null:
return $default(_that.id,_that.label,_that.recipientName,_that.phone,_that.line1,_that.line2,_that.city,_that.provinceCode,_that.districtCode,_that.communeCode,_that.villageCode,_that.latitude,_that.longitude,_that.isDefault);case _:
  return null;

}
}

}

/// @nodoc


class _Address implements Address {
  const _Address({required this.id, this.label = 'Home', required this.recipientName, this.phone = '', required this.line1, this.line2, required this.city, this.provinceCode, this.districtCode, this.communeCode, this.villageCode, this.latitude, this.longitude, this.isDefault = false});
  

@override final  String id;
@override@JsonKey() final  String label;
@override final  String recipientName;
@override@JsonKey() final  String phone;
@override final  String line1;
@override final  String? line2;
@override final  String city;
/// Official 2025 administrative codes (bundled assets/geo data). Null
/// for legacy addresses whose city is still free text.
@override final  String? provinceCode;
@override final  String? districtCode;
@override final  String? communeCode;
@override final  String? villageCode;
@override final  double? latitude;
@override final  double? longitude;
@override@JsonKey() final  bool isDefault;

/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddressCopyWith<_Address> get copyWith => __$AddressCopyWithImpl<_Address>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Address&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.recipientName, recipientName) || other.recipientName == recipientName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.line1, line1) || other.line1 == line1)&&(identical(other.line2, line2) || other.line2 == line2)&&(identical(other.city, city) || other.city == city)&&(identical(other.provinceCode, provinceCode) || other.provinceCode == provinceCode)&&(identical(other.districtCode, districtCode) || other.districtCode == districtCode)&&(identical(other.communeCode, communeCode) || other.communeCode == communeCode)&&(identical(other.villageCode, villageCode) || other.villageCode == villageCode)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}


@override
int get hashCode => Object.hash(runtimeType,id,label,recipientName,phone,line1,line2,city,provinceCode,districtCode,communeCode,villageCode,latitude,longitude,isDefault);

@override
String toString() {
  return 'Address(id: $id, label: $label, recipientName: $recipientName, phone: $phone, line1: $line1, line2: $line2, city: $city, provinceCode: $provinceCode, districtCode: $districtCode, communeCode: $communeCode, villageCode: $villageCode, latitude: $latitude, longitude: $longitude, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$AddressCopyWith<$Res> implements $AddressCopyWith<$Res> {
  factory _$AddressCopyWith(_Address value, $Res Function(_Address) _then) = __$AddressCopyWithImpl;
@override @useResult
$Res call({
 String id, String label, String recipientName, String phone, String line1, String? line2, String city, String? provinceCode, String? districtCode, String? communeCode, String? villageCode, double? latitude, double? longitude, bool isDefault
});




}
/// @nodoc
class __$AddressCopyWithImpl<$Res>
    implements _$AddressCopyWith<$Res> {
  __$AddressCopyWithImpl(this._self, this._then);

  final _Address _self;
  final $Res Function(_Address) _then;

/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? recipientName = null,Object? phone = null,Object? line1 = null,Object? line2 = freezed,Object? city = null,Object? provinceCode = freezed,Object? districtCode = freezed,Object? communeCode = freezed,Object? villageCode = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? isDefault = null,}) {
  return _then(_Address(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,recipientName: null == recipientName ? _self.recipientName : recipientName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,line1: null == line1 ? _self.line1 : line1 // ignore: cast_nullable_to_non_nullable
as String,line2: freezed == line2 ? _self.line2 : line2 // ignore: cast_nullable_to_non_nullable
as String?,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,provinceCode: freezed == provinceCode ? _self.provinceCode : provinceCode // ignore: cast_nullable_to_non_nullable
as String?,districtCode: freezed == districtCode ? _self.districtCode : districtCode // ignore: cast_nullable_to_non_nullable
as String?,communeCode: freezed == communeCode ? _self.communeCode : communeCode // ignore: cast_nullable_to_non_nullable
as String?,villageCode: freezed == villageCode ? _self.villageCode : villageCode // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$AddressDraft {

 String get label; String get recipientName; String get phone; String get line1; String? get line2; String get city; String? get provinceCode; String? get districtCode; String? get communeCode; String? get villageCode; double? get latitude; double? get longitude;
/// Create a copy of AddressDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressDraftCopyWith<AddressDraft> get copyWith => _$AddressDraftCopyWithImpl<AddressDraft>(this as AddressDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressDraft&&(identical(other.label, label) || other.label == label)&&(identical(other.recipientName, recipientName) || other.recipientName == recipientName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.line1, line1) || other.line1 == line1)&&(identical(other.line2, line2) || other.line2 == line2)&&(identical(other.city, city) || other.city == city)&&(identical(other.provinceCode, provinceCode) || other.provinceCode == provinceCode)&&(identical(other.districtCode, districtCode) || other.districtCode == districtCode)&&(identical(other.communeCode, communeCode) || other.communeCode == communeCode)&&(identical(other.villageCode, villageCode) || other.villageCode == villageCode)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}


@override
int get hashCode => Object.hash(runtimeType,label,recipientName,phone,line1,line2,city,provinceCode,districtCode,communeCode,villageCode,latitude,longitude);

@override
String toString() {
  return 'AddressDraft(label: $label, recipientName: $recipientName, phone: $phone, line1: $line1, line2: $line2, city: $city, provinceCode: $provinceCode, districtCode: $districtCode, communeCode: $communeCode, villageCode: $villageCode, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class $AddressDraftCopyWith<$Res>  {
  factory $AddressDraftCopyWith(AddressDraft value, $Res Function(AddressDraft) _then) = _$AddressDraftCopyWithImpl;
@useResult
$Res call({
 String label, String recipientName, String phone, String line1, String? line2, String city, String? provinceCode, String? districtCode, String? communeCode, String? villageCode, double? latitude, double? longitude
});




}
/// @nodoc
class _$AddressDraftCopyWithImpl<$Res>
    implements $AddressDraftCopyWith<$Res> {
  _$AddressDraftCopyWithImpl(this._self, this._then);

  final AddressDraft _self;
  final $Res Function(AddressDraft) _then;

/// Create a copy of AddressDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? recipientName = null,Object? phone = null,Object? line1 = null,Object? line2 = freezed,Object? city = null,Object? provinceCode = freezed,Object? districtCode = freezed,Object? communeCode = freezed,Object? villageCode = freezed,Object? latitude = freezed,Object? longitude = freezed,}) {
  return _then(AddressDraft(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,recipientName: null == recipientName ? _self.recipientName : recipientName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,line1: null == line1 ? _self.line1 : line1 // ignore: cast_nullable_to_non_nullable
as String,line2: freezed == line2 ? _self.line2 : line2 // ignore: cast_nullable_to_non_nullable
as String?,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,provinceCode: freezed == provinceCode ? _self.provinceCode : provinceCode // ignore: cast_nullable_to_non_nullable
as String?,districtCode: freezed == districtCode ? _self.districtCode : districtCode // ignore: cast_nullable_to_non_nullable
as String?,communeCode: freezed == communeCode ? _self.communeCode : communeCode // ignore: cast_nullable_to_non_nullable
as String?,villageCode: freezed == villageCode ? _self.villageCode : villageCode // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [AddressDraft].
extension AddressDraftPatterns on AddressDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddressDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddressDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddressDraft value)  $default,){
final _that = this;
switch (_that) {
case _AddressDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddressDraft value)?  $default,){
final _that = this;
switch (_that) {
case _AddressDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  String recipientName,  String phone,  String line1,  String? line2,  String city,  String? provinceCode,  String? districtCode,  String? communeCode,  String? villageCode,  double? latitude,  double? longitude)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddressDraft() when $default != null:
return $default(_that.label,_that.recipientName,_that.phone,_that.line1,_that.line2,_that.city,_that.provinceCode,_that.districtCode,_that.communeCode,_that.villageCode,_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  String recipientName,  String phone,  String line1,  String? line2,  String city,  String? provinceCode,  String? districtCode,  String? communeCode,  String? villageCode,  double? latitude,  double? longitude)  $default,) {final _that = this;
switch (_that) {
case _AddressDraft():
return $default(_that.label,_that.recipientName,_that.phone,_that.line1,_that.line2,_that.city,_that.provinceCode,_that.districtCode,_that.communeCode,_that.villageCode,_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  String recipientName,  String phone,  String line1,  String? line2,  String city,  String? provinceCode,  String? districtCode,  String? communeCode,  String? villageCode,  double? latitude,  double? longitude)?  $default,) {final _that = this;
switch (_that) {
case _AddressDraft() when $default != null:
return $default(_that.label,_that.recipientName,_that.phone,_that.line1,_that.line2,_that.city,_that.provinceCode,_that.districtCode,_that.communeCode,_that.villageCode,_that.latitude,_that.longitude);case _:
  return null;

}
}

}

/// @nodoc


class _AddressDraft extends AddressDraft {
  const _AddressDraft({required this.label, required this.recipientName, required this.phone, required this.line1, this.line2, required this.city, this.provinceCode, this.districtCode, this.communeCode, this.villageCode, this.latitude, this.longitude}): super._();
  

@override final  String label;
@override final  String recipientName;
@override final  String phone;
@override final  String line1;
@override final  String? line2;
@override final  String city;
@override final  String? provinceCode;
@override final  String? districtCode;
@override final  String? communeCode;
@override final  String? villageCode;
@override final  double? latitude;
@override final  double? longitude;

/// Create a copy of AddressDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddressDraftCopyWith<_AddressDraft> get copyWith => __$AddressDraftCopyWithImpl<_AddressDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddressDraft&&(identical(other.label, label) || other.label == label)&&(identical(other.recipientName, recipientName) || other.recipientName == recipientName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.line1, line1) || other.line1 == line1)&&(identical(other.line2, line2) || other.line2 == line2)&&(identical(other.city, city) || other.city == city)&&(identical(other.provinceCode, provinceCode) || other.provinceCode == provinceCode)&&(identical(other.districtCode, districtCode) || other.districtCode == districtCode)&&(identical(other.communeCode, communeCode) || other.communeCode == communeCode)&&(identical(other.villageCode, villageCode) || other.villageCode == villageCode)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}


@override
int get hashCode => Object.hash(runtimeType,label,recipientName,phone,line1,line2,city,provinceCode,districtCode,communeCode,villageCode,latitude,longitude);

@override
String toString() {
  return 'AddressDraft(label: $label, recipientName: $recipientName, phone: $phone, line1: $line1, line2: $line2, city: $city, provinceCode: $provinceCode, districtCode: $districtCode, communeCode: $communeCode, villageCode: $villageCode, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$AddressDraftCopyWith<$Res> implements $AddressDraftCopyWith<$Res> {
  factory _$AddressDraftCopyWith(_AddressDraft value, $Res Function(_AddressDraft) _then) = __$AddressDraftCopyWithImpl;
@override @useResult
$Res call({
 String label, String recipientName, String phone, String line1, String? line2, String city, String? provinceCode, String? districtCode, String? communeCode, String? villageCode, double? latitude, double? longitude
});




}
/// @nodoc
class __$AddressDraftCopyWithImpl<$Res>
    implements _$AddressDraftCopyWith<$Res> {
  __$AddressDraftCopyWithImpl(this._self, this._then);

  final _AddressDraft _self;
  final $Res Function(_AddressDraft) _then;

/// Create a copy of AddressDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? recipientName = null,Object? phone = null,Object? line1 = null,Object? line2 = freezed,Object? city = null,Object? provinceCode = freezed,Object? districtCode = freezed,Object? communeCode = freezed,Object? villageCode = freezed,Object? latitude = freezed,Object? longitude = freezed,}) {
  return _then(_AddressDraft(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,recipientName: null == recipientName ? _self.recipientName : recipientName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,line1: null == line1 ? _self.line1 : line1 // ignore: cast_nullable_to_non_nullable
as String,line2: freezed == line2 ? _self.line2 : line2 // ignore: cast_nullable_to_non_nullable
as String?,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,provinceCode: freezed == provinceCode ? _self.provinceCode : provinceCode // ignore: cast_nullable_to_non_nullable
as String?,districtCode: freezed == districtCode ? _self.districtCode : districtCode // ignore: cast_nullable_to_non_nullable
as String?,communeCode: freezed == communeCode ? _self.communeCode : communeCode // ignore: cast_nullable_to_non_nullable
as String?,villageCode: freezed == villageCode ? _self.villageCode : villageCode // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
