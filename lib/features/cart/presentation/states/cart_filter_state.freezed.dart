// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_filter_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CartFilterState {

 String get query; CartFilter get filter; CartSort get sort;
/// Create a copy of CartFilterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartFilterStateCopyWith<CartFilterState> get copyWith => _$CartFilterStateCopyWithImpl<CartFilterState>(this as CartFilterState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartFilterState&&(identical(other.query, query) || other.query == query)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.sort, sort) || other.sort == sort));
}


@override
int get hashCode => Object.hash(runtimeType,query,filter,sort);

@override
String toString() {
  return 'CartFilterState(query: $query, filter: $filter, sort: $sort)';
}


}

/// @nodoc
abstract mixin class $CartFilterStateCopyWith<$Res>  {
  factory $CartFilterStateCopyWith(CartFilterState value, $Res Function(CartFilterState) _then) = _$CartFilterStateCopyWithImpl;
@useResult
$Res call({
 String query, CartFilter filter, CartSort sort
});




}
/// @nodoc
class _$CartFilterStateCopyWithImpl<$Res>
    implements $CartFilterStateCopyWith<$Res> {
  _$CartFilterStateCopyWithImpl(this._self, this._then);

  final CartFilterState _self;
  final $Res Function(CartFilterState) _then;

/// Create a copy of CartFilterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,Object? filter = null,Object? sort = null,}) {
  return _then(CartFilterState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as CartFilter,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as CartSort,
  ));
}

}


/// Adds pattern-matching-related methods to [CartFilterState].
extension CartFilterStatePatterns on CartFilterState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CartFilterState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CartFilterState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CartFilterState value)  $default,){
final _that = this;
switch (_that) {
case _CartFilterState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CartFilterState value)?  $default,){
final _that = this;
switch (_that) {
case _CartFilterState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String query,  CartFilter filter,  CartSort sort)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CartFilterState() when $default != null:
return $default(_that.query,_that.filter,_that.sort);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String query,  CartFilter filter,  CartSort sort)  $default,) {final _that = this;
switch (_that) {
case _CartFilterState():
return $default(_that.query,_that.filter,_that.sort);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String query,  CartFilter filter,  CartSort sort)?  $default,) {final _that = this;
switch (_that) {
case _CartFilterState() when $default != null:
return $default(_that.query,_that.filter,_that.sort);case _:
  return null;

}
}

}

/// @nodoc


class _CartFilterState extends CartFilterState {
  const _CartFilterState({this.query = '', this.filter = CartFilter.all, this.sort = CartSort.newest}): super._();
  

@override@JsonKey() final  String query;
@override@JsonKey() final  CartFilter filter;
@override@JsonKey() final  CartSort sort;

/// Create a copy of CartFilterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartFilterStateCopyWith<_CartFilterState> get copyWith => __$CartFilterStateCopyWithImpl<_CartFilterState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CartFilterState&&(identical(other.query, query) || other.query == query)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.sort, sort) || other.sort == sort));
}


@override
int get hashCode => Object.hash(runtimeType,query,filter,sort);

@override
String toString() {
  return 'CartFilterState(query: $query, filter: $filter, sort: $sort)';
}


}

/// @nodoc
abstract mixin class _$CartFilterStateCopyWith<$Res> implements $CartFilterStateCopyWith<$Res> {
  factory _$CartFilterStateCopyWith(_CartFilterState value, $Res Function(_CartFilterState) _then) = __$CartFilterStateCopyWithImpl;
@override @useResult
$Res call({
 String query, CartFilter filter, CartSort sort
});




}
/// @nodoc
class __$CartFilterStateCopyWithImpl<$Res>
    implements _$CartFilterStateCopyWith<$Res> {
  __$CartFilterStateCopyWithImpl(this._self, this._then);

  final _CartFilterState _self;
  final $Res Function(_CartFilterState) _then;

/// Create a copy of CartFilterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? filter = null,Object? sort = null,}) {
  return _then(_CartFilterState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as CartFilter,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as CartSort,
  ));
}


}

// dart format on
