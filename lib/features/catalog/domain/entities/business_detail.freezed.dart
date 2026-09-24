// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BusinessDetail {

 Business get business; List<Product> get products;
/// Create a copy of BusinessDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BusinessDetailCopyWith<BusinessDetail> get copyWith => _$BusinessDetailCopyWithImpl<BusinessDetail>(this as BusinessDetail, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BusinessDetail&&(identical(other.business, business) || other.business == business)&&const DeepCollectionEquality().equals(other.products, products));
}


@override
int get hashCode => Object.hash(runtimeType,business,const DeepCollectionEquality().hash(products));

@override
String toString() {
  return 'BusinessDetail(business: $business, products: $products)';
}


}

/// @nodoc
abstract mixin class $BusinessDetailCopyWith<$Res>  {
  factory $BusinessDetailCopyWith(BusinessDetail value, $Res Function(BusinessDetail) _then) = _$BusinessDetailCopyWithImpl;
@useResult
$Res call({
 Business business, List<Product> products
});


$BusinessCopyWith<$Res> get business;

}
/// @nodoc
class _$BusinessDetailCopyWithImpl<$Res>
    implements $BusinessDetailCopyWith<$Res> {
  _$BusinessDetailCopyWithImpl(this._self, this._then);

  final BusinessDetail _self;
  final $Res Function(BusinessDetail) _then;

/// Create a copy of BusinessDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? business = null,Object? products = null,}) {
  return _then(BusinessDetail(
business: null == business ? _self.business : business // ignore: cast_nullable_to_non_nullable
as Business,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,
  ));
}
/// Create a copy of BusinessDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BusinessCopyWith<$Res> get business {
  
  return $BusinessCopyWith<$Res>(_self.business, (value) {
    return _then(_self.copyWith(business: value));
  });
}
}


/// Adds pattern-matching-related methods to [BusinessDetail].
extension BusinessDetailPatterns on BusinessDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BusinessDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BusinessDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BusinessDetail value)  $default,){
final _that = this;
switch (_that) {
case _BusinessDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BusinessDetail value)?  $default,){
final _that = this;
switch (_that) {
case _BusinessDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Business business,  List<Product> products)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BusinessDetail() when $default != null:
return $default(_that.business,_that.products);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Business business,  List<Product> products)  $default,) {final _that = this;
switch (_that) {
case _BusinessDetail():
return $default(_that.business,_that.products);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Business business,  List<Product> products)?  $default,) {final _that = this;
switch (_that) {
case _BusinessDetail() when $default != null:
return $default(_that.business,_that.products);case _:
  return null;

}
}

}

/// @nodoc


class _BusinessDetail implements BusinessDetail {
  const _BusinessDetail({required this.business, required  List<Product> products}): _products = products;
  

@override final  Business business;
 final  List<Product> _products;
@override List<Product> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}


/// Create a copy of BusinessDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BusinessDetailCopyWith<_BusinessDetail> get copyWith => __$BusinessDetailCopyWithImpl<_BusinessDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BusinessDetail&&(identical(other.business, business) || other.business == business)&&const DeepCollectionEquality().equals(other._products, _products));
}


@override
int get hashCode => Object.hash(runtimeType,business,const DeepCollectionEquality().hash(_products));

@override
String toString() {
  return 'BusinessDetail(business: $business, products: $products)';
}


}

/// @nodoc
abstract mixin class _$BusinessDetailCopyWith<$Res> implements $BusinessDetailCopyWith<$Res> {
  factory _$BusinessDetailCopyWith(_BusinessDetail value, $Res Function(_BusinessDetail) _then) = __$BusinessDetailCopyWithImpl;
@override @useResult
$Res call({
 Business business, List<Product> products
});


@override $BusinessCopyWith<$Res> get business;

}
/// @nodoc
class __$BusinessDetailCopyWithImpl<$Res>
    implements _$BusinessDetailCopyWith<$Res> {
  __$BusinessDetailCopyWithImpl(this._self, this._then);

  final _BusinessDetail _self;
  final $Res Function(_BusinessDetail) _then;

/// Create a copy of BusinessDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? business = null,Object? products = null,}) {
  return _then(_BusinessDetail(
business: null == business ? _self.business : business // ignore: cast_nullable_to_non_nullable
as Business,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,
  ));
}

/// Create a copy of BusinessDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BusinessCopyWith<$Res> get business {
  
  return $BusinessCopyWith<$Res>(_self.business, (value) {
    return _then(_self.copyWith(business: value));
  });
}
}

// dart format on
