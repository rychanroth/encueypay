// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address_option.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AddressOption {

 String get id; String get label; String get recipientName; String get phone; String get line1; String? get line2; String get city;
/// Create a copy of AddressOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressOptionCopyWith<AddressOption> get copyWith => _$AddressOptionCopyWithImpl<AddressOption>(this as AddressOption, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressOption&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.recipientName, recipientName) || other.recipientName == recipientName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.line1, line1) || other.line1 == line1)&&(identical(other.line2, line2) || other.line2 == line2)&&(identical(other.city, city) || other.city == city));
}


@override
int get hashCode => Object.hash(runtimeType,id,label,recipientName,phone,line1,line2,city);

@override
String toString() {
  return 'AddressOption(id: $id, label: $label, recipientName: $recipientName, phone: $phone, line1: $line1, line2: $line2, city: $city)';
}


}

/// @nodoc
abstract mixin class $AddressOptionCopyWith<$Res>  {
  factory $AddressOptionCopyWith(AddressOption value, $Res Function(AddressOption) _then) = _$AddressOptionCopyWithImpl;
@useResult
$Res call({
 String id, String label, String recipientName, String phone, String line1, String? line2, String city
});




}
/// @nodoc
class _$AddressOptionCopyWithImpl<$Res>
    implements $AddressOptionCopyWith<$Res> {
  _$AddressOptionCopyWithImpl(this._self, this._then);

  final AddressOption _self;
  final $Res Function(AddressOption) _then;

/// Create a copy of AddressOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? recipientName = null,Object? phone = null,Object? line1 = null,Object? line2 = freezed,Object? city = null,}) {
  return _then(AddressOption(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,recipientName: null == recipientName ? _self.recipientName : recipientName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,line1: null == line1 ? _self.line1 : line1 // ignore: cast_nullable_to_non_nullable
as String,line2: freezed == line2 ? _self.line2 : line2 // ignore: cast_nullable_to_non_nullable
as String?,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AddressOption].
extension AddressOptionPatterns on AddressOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddressOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddressOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddressOption value)  $default,){
final _that = this;
switch (_that) {
case _AddressOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddressOption value)?  $default,){
final _that = this;
switch (_that) {
case _AddressOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String label,  String recipientName,  String phone,  String line1,  String? line2,  String city)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddressOption() when $default != null:
return $default(_that.id,_that.label,_that.recipientName,_that.phone,_that.line1,_that.line2,_that.city);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String label,  String recipientName,  String phone,  String line1,  String? line2,  String city)  $default,) {final _that = this;
switch (_that) {
case _AddressOption():
return $default(_that.id,_that.label,_that.recipientName,_that.phone,_that.line1,_that.line2,_that.city);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String label,  String recipientName,  String phone,  String line1,  String? line2,  String city)?  $default,) {final _that = this;
switch (_that) {
case _AddressOption() when $default != null:
return $default(_that.id,_that.label,_that.recipientName,_that.phone,_that.line1,_that.line2,_that.city);case _:
  return null;

}
}

}

/// @nodoc


class _AddressOption implements AddressOption {
  const _AddressOption({required this.id, required this.label, required this.recipientName, required this.phone, required this.line1, this.line2, required this.city});
  

@override final  String id;
@override final  String label;
@override final  String recipientName;
@override final  String phone;
@override final  String line1;
@override final  String? line2;
@override final  String city;

/// Create a copy of AddressOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddressOptionCopyWith<_AddressOption> get copyWith => __$AddressOptionCopyWithImpl<_AddressOption>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddressOption&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.recipientName, recipientName) || other.recipientName == recipientName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.line1, line1) || other.line1 == line1)&&(identical(other.line2, line2) || other.line2 == line2)&&(identical(other.city, city) || other.city == city));
}


@override
int get hashCode => Object.hash(runtimeType,id,label,recipientName,phone,line1,line2,city);

@override
String toString() {
  return 'AddressOption(id: $id, label: $label, recipientName: $recipientName, phone: $phone, line1: $line1, line2: $line2, city: $city)';
}


}

/// @nodoc
abstract mixin class _$AddressOptionCopyWith<$Res> implements $AddressOptionCopyWith<$Res> {
  factory _$AddressOptionCopyWith(_AddressOption value, $Res Function(_AddressOption) _then) = __$AddressOptionCopyWithImpl;
@override @useResult
$Res call({
 String id, String label, String recipientName, String phone, String line1, String? line2, String city
});




}
/// @nodoc
class __$AddressOptionCopyWithImpl<$Res>
    implements _$AddressOptionCopyWith<$Res> {
  __$AddressOptionCopyWithImpl(this._self, this._then);

  final _AddressOption _self;
  final $Res Function(_AddressOption) _then;

/// Create a copy of AddressOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? recipientName = null,Object? phone = null,Object? line1 = null,Object? line2 = freezed,Object? city = null,}) {
  return _then(_AddressOption(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,recipientName: null == recipientName ? _self.recipientName : recipientName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,line1: null == line1 ? _self.line1 : line1 // ignore: cast_nullable_to_non_nullable
as String,line2: freezed == line2 ? _self.line2 : line2 // ignore: cast_nullable_to_non_nullable
as String?,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
