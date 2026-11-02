// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'administrative_unit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdministrativeUnit {

 String get code; String get nameEn; String get nameKm; List<AdministrativeUnit> get children;
/// Create a copy of AdministrativeUnit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdministrativeUnitCopyWith<AdministrativeUnit> get copyWith => _$AdministrativeUnitCopyWithImpl<AdministrativeUnit>(this as AdministrativeUnit, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdministrativeUnit&&(identical(other.code, code) || other.code == code)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameKm, nameKm) || other.nameKm == nameKm)&&const DeepCollectionEquality().equals(other.children, children));
}


@override
int get hashCode => Object.hash(runtimeType,code,nameEn,nameKm,const DeepCollectionEquality().hash(children));

@override
String toString() {
  return 'AdministrativeUnit(code: $code, nameEn: $nameEn, nameKm: $nameKm, children: $children)';
}


}

/// @nodoc
abstract mixin class $AdministrativeUnitCopyWith<$Res>  {
  factory $AdministrativeUnitCopyWith(AdministrativeUnit value, $Res Function(AdministrativeUnit) _then) = _$AdministrativeUnitCopyWithImpl;
@useResult
$Res call({
 String code, String nameEn, String nameKm, List<AdministrativeUnit> children
});




}
/// @nodoc
class _$AdministrativeUnitCopyWithImpl<$Res>
    implements $AdministrativeUnitCopyWith<$Res> {
  _$AdministrativeUnitCopyWithImpl(this._self, this._then);

  final AdministrativeUnit _self;
  final $Res Function(AdministrativeUnit) _then;

/// Create a copy of AdministrativeUnit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? nameEn = null,Object? nameKm = null,Object? children = null,}) {
  return _then(AdministrativeUnit(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameKm: null == nameKm ? _self.nameKm : nameKm // ignore: cast_nullable_to_non_nullable
as String,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<AdministrativeUnit>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdministrativeUnit].
extension AdministrativeUnitPatterns on AdministrativeUnit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdministrativeUnit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdministrativeUnit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdministrativeUnit value)  $default,){
final _that = this;
switch (_that) {
case _AdministrativeUnit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdministrativeUnit value)?  $default,){
final _that = this;
switch (_that) {
case _AdministrativeUnit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String nameEn,  String nameKm,  List<AdministrativeUnit> children)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdministrativeUnit() when $default != null:
return $default(_that.code,_that.nameEn,_that.nameKm,_that.children);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String nameEn,  String nameKm,  List<AdministrativeUnit> children)  $default,) {final _that = this;
switch (_that) {
case _AdministrativeUnit():
return $default(_that.code,_that.nameEn,_that.nameKm,_that.children);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String nameEn,  String nameKm,  List<AdministrativeUnit> children)?  $default,) {final _that = this;
switch (_that) {
case _AdministrativeUnit() when $default != null:
return $default(_that.code,_that.nameEn,_that.nameKm,_that.children);case _:
  return null;

}
}

}

/// @nodoc


class _AdministrativeUnit extends AdministrativeUnit {
  const _AdministrativeUnit({required this.code, required this.nameEn, required this.nameKm,  List<AdministrativeUnit> children = const []}): _children = children,super._();
  

@override final  String code;
@override final  String nameEn;
@override final  String nameKm;
 final  List<AdministrativeUnit> _children;
@override@JsonKey() List<AdministrativeUnit> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}


/// Create a copy of AdministrativeUnit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdministrativeUnitCopyWith<_AdministrativeUnit> get copyWith => __$AdministrativeUnitCopyWithImpl<_AdministrativeUnit>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdministrativeUnit&&(identical(other.code, code) || other.code == code)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameKm, nameKm) || other.nameKm == nameKm)&&const DeepCollectionEquality().equals(other._children, _children));
}


@override
int get hashCode => Object.hash(runtimeType,code,nameEn,nameKm,const DeepCollectionEquality().hash(_children));

@override
String toString() {
  return 'AdministrativeUnit(code: $code, nameEn: $nameEn, nameKm: $nameKm, children: $children)';
}


}

/// @nodoc
abstract mixin class _$AdministrativeUnitCopyWith<$Res> implements $AdministrativeUnitCopyWith<$Res> {
  factory _$AdministrativeUnitCopyWith(_AdministrativeUnit value, $Res Function(_AdministrativeUnit) _then) = __$AdministrativeUnitCopyWithImpl;
@override @useResult
$Res call({
 String code, String nameEn, String nameKm, List<AdministrativeUnit> children
});




}
/// @nodoc
class __$AdministrativeUnitCopyWithImpl<$Res>
    implements _$AdministrativeUnitCopyWith<$Res> {
  __$AdministrativeUnitCopyWithImpl(this._self, this._then);

  final _AdministrativeUnit _self;
  final $Res Function(_AdministrativeUnit) _then;

/// Create a copy of AdministrativeUnit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? nameEn = null,Object? nameKm = null,Object? children = null,}) {
  return _then(_AdministrativeUnit(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameKm: null == nameKm ? _self.nameKm : nameKm // ignore: cast_nullable_to_non_nullable
as String,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<AdministrativeUnit>,
  ));
}


}

// dart format on
