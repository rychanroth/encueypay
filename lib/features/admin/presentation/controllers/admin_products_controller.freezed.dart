// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_products_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdminProductsState {

 AdminProductQuery get query; List<AdminProductSummary> get products; int get totalCount; int get totalStockValueMinor; bool get loadingMore;
/// Create a copy of AdminProductsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminProductsStateCopyWith<AdminProductsState> get copyWith => _$AdminProductsStateCopyWithImpl<AdminProductsState>(this as AdminProductsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminProductsState&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other.products, products)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.totalStockValueMinor, totalStockValueMinor) || other.totalStockValueMinor == totalStockValueMinor)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore));
}


@override
int get hashCode => Object.hash(runtimeType,query,const DeepCollectionEquality().hash(products),totalCount,totalStockValueMinor,loadingMore);

@override
String toString() {
  return 'AdminProductsState(query: $query, products: $products, totalCount: $totalCount, totalStockValueMinor: $totalStockValueMinor, loadingMore: $loadingMore)';
}


}

/// @nodoc
abstract mixin class $AdminProductsStateCopyWith<$Res>  {
  factory $AdminProductsStateCopyWith(AdminProductsState value, $Res Function(AdminProductsState) _then) = _$AdminProductsStateCopyWithImpl;
@useResult
$Res call({
 AdminProductQuery query, List<AdminProductSummary> products, int totalCount, int totalStockValueMinor, bool loadingMore
});


$AdminProductQueryCopyWith<$Res> get query;

}
/// @nodoc
class _$AdminProductsStateCopyWithImpl<$Res>
    implements $AdminProductsStateCopyWith<$Res> {
  _$AdminProductsStateCopyWithImpl(this._self, this._then);

  final AdminProductsState _self;
  final $Res Function(AdminProductsState) _then;

/// Create a copy of AdminProductsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,Object? products = null,Object? totalCount = null,Object? totalStockValueMinor = null,Object? loadingMore = null,}) {
  return _then(AdminProductsState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as AdminProductQuery,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<AdminProductSummary>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,totalStockValueMinor: null == totalStockValueMinor ? _self.totalStockValueMinor : totalStockValueMinor // ignore: cast_nullable_to_non_nullable
as int,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of AdminProductsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminProductQueryCopyWith<$Res> get query {
  
  return $AdminProductQueryCopyWith<$Res>(_self.query, (value) {
    return _then(_self.copyWith(query: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdminProductsState].
extension AdminProductsStatePatterns on AdminProductsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminProductsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminProductsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminProductsState value)  $default,){
final _that = this;
switch (_that) {
case _AdminProductsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminProductsState value)?  $default,){
final _that = this;
switch (_that) {
case _AdminProductsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AdminProductQuery query,  List<AdminProductSummary> products,  int totalCount,  int totalStockValueMinor,  bool loadingMore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminProductsState() when $default != null:
return $default(_that.query,_that.products,_that.totalCount,_that.totalStockValueMinor,_that.loadingMore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AdminProductQuery query,  List<AdminProductSummary> products,  int totalCount,  int totalStockValueMinor,  bool loadingMore)  $default,) {final _that = this;
switch (_that) {
case _AdminProductsState():
return $default(_that.query,_that.products,_that.totalCount,_that.totalStockValueMinor,_that.loadingMore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AdminProductQuery query,  List<AdminProductSummary> products,  int totalCount,  int totalStockValueMinor,  bool loadingMore)?  $default,) {final _that = this;
switch (_that) {
case _AdminProductsState() when $default != null:
return $default(_that.query,_that.products,_that.totalCount,_that.totalStockValueMinor,_that.loadingMore);case _:
  return null;

}
}

}

/// @nodoc


class _AdminProductsState extends AdminProductsState {
  const _AdminProductsState({required this.query,  List<AdminProductSummary> products = const <AdminProductSummary>[], this.totalCount = 0, this.totalStockValueMinor = 0, this.loadingMore = false}): _products = products,super._();
  

@override final  AdminProductQuery query;
 final  List<AdminProductSummary> _products;
@override@JsonKey() List<AdminProductSummary> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

@override@JsonKey() final  int totalCount;
@override@JsonKey() final  int totalStockValueMinor;
@override@JsonKey() final  bool loadingMore;

/// Create a copy of AdminProductsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminProductsStateCopyWith<_AdminProductsState> get copyWith => __$AdminProductsStateCopyWithImpl<_AdminProductsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminProductsState&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other._products, _products)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.totalStockValueMinor, totalStockValueMinor) || other.totalStockValueMinor == totalStockValueMinor)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore));
}


@override
int get hashCode => Object.hash(runtimeType,query,const DeepCollectionEquality().hash(_products),totalCount,totalStockValueMinor,loadingMore);

@override
String toString() {
  return 'AdminProductsState(query: $query, products: $products, totalCount: $totalCount, totalStockValueMinor: $totalStockValueMinor, loadingMore: $loadingMore)';
}


}

/// @nodoc
abstract mixin class _$AdminProductsStateCopyWith<$Res> implements $AdminProductsStateCopyWith<$Res> {
  factory _$AdminProductsStateCopyWith(_AdminProductsState value, $Res Function(_AdminProductsState) _then) = __$AdminProductsStateCopyWithImpl;
@override @useResult
$Res call({
 AdminProductQuery query, List<AdminProductSummary> products, int totalCount, int totalStockValueMinor, bool loadingMore
});


@override $AdminProductQueryCopyWith<$Res> get query;

}
/// @nodoc
class __$AdminProductsStateCopyWithImpl<$Res>
    implements _$AdminProductsStateCopyWith<$Res> {
  __$AdminProductsStateCopyWithImpl(this._self, this._then);

  final _AdminProductsState _self;
  final $Res Function(_AdminProductsState) _then;

/// Create a copy of AdminProductsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? products = null,Object? totalCount = null,Object? totalStockValueMinor = null,Object? loadingMore = null,}) {
  return _then(_AdminProductsState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as AdminProductQuery,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<AdminProductSummary>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,totalStockValueMinor: null == totalStockValueMinor ? _self.totalStockValueMinor : totalStockValueMinor // ignore: cast_nullable_to_non_nullable
as int,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of AdminProductsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminProductQueryCopyWith<$Res> get query {
  
  return $AdminProductQueryCopyWith<$Res>(_self.query, (value) {
    return _then(_self.copyWith(query: value));
  });
}
}

// dart format on
