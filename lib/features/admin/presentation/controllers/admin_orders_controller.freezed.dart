// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_orders_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdminOrdersState {

 AdminOrderQuery get query; List<AdminOrderSummary> get orders; int get totalCount; int get totalMinor; bool get loadingMore;
/// Create a copy of AdminOrdersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminOrdersStateCopyWith<AdminOrdersState> get copyWith => _$AdminOrdersStateCopyWithImpl<AdminOrdersState>(this as AdminOrdersState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminOrdersState&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other.orders, orders)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore));
}


@override
int get hashCode => Object.hash(runtimeType,query,const DeepCollectionEquality().hash(orders),totalCount,totalMinor,loadingMore);

@override
String toString() {
  return 'AdminOrdersState(query: $query, orders: $orders, totalCount: $totalCount, totalMinor: $totalMinor, loadingMore: $loadingMore)';
}


}

/// @nodoc
abstract mixin class $AdminOrdersStateCopyWith<$Res>  {
  factory $AdminOrdersStateCopyWith(AdminOrdersState value, $Res Function(AdminOrdersState) _then) = _$AdminOrdersStateCopyWithImpl;
@useResult
$Res call({
 AdminOrderQuery query, List<AdminOrderSummary> orders, int totalCount, int totalMinor, bool loadingMore
});


$AdminOrderQueryCopyWith<$Res> get query;

}
/// @nodoc
class _$AdminOrdersStateCopyWithImpl<$Res>
    implements $AdminOrdersStateCopyWith<$Res> {
  _$AdminOrdersStateCopyWithImpl(this._self, this._then);

  final AdminOrdersState _self;
  final $Res Function(AdminOrdersState) _then;

/// Create a copy of AdminOrdersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,Object? orders = null,Object? totalCount = null,Object? totalMinor = null,Object? loadingMore = null,}) {
  return _then(AdminOrdersState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as AdminOrderQuery,orders: null == orders ? _self.orders : orders // ignore: cast_nullable_to_non_nullable
as List<AdminOrderSummary>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of AdminOrdersState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminOrderQueryCopyWith<$Res> get query {
  
  return $AdminOrderQueryCopyWith<$Res>(_self.query, (value) {
    return _then(_self.copyWith(query: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdminOrdersState].
extension AdminOrdersStatePatterns on AdminOrdersState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminOrdersState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminOrdersState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminOrdersState value)  $default,){
final _that = this;
switch (_that) {
case _AdminOrdersState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminOrdersState value)?  $default,){
final _that = this;
switch (_that) {
case _AdminOrdersState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AdminOrderQuery query,  List<AdminOrderSummary> orders,  int totalCount,  int totalMinor,  bool loadingMore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminOrdersState() when $default != null:
return $default(_that.query,_that.orders,_that.totalCount,_that.totalMinor,_that.loadingMore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AdminOrderQuery query,  List<AdminOrderSummary> orders,  int totalCount,  int totalMinor,  bool loadingMore)  $default,) {final _that = this;
switch (_that) {
case _AdminOrdersState():
return $default(_that.query,_that.orders,_that.totalCount,_that.totalMinor,_that.loadingMore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AdminOrderQuery query,  List<AdminOrderSummary> orders,  int totalCount,  int totalMinor,  bool loadingMore)?  $default,) {final _that = this;
switch (_that) {
case _AdminOrdersState() when $default != null:
return $default(_that.query,_that.orders,_that.totalCount,_that.totalMinor,_that.loadingMore);case _:
  return null;

}
}

}

/// @nodoc


class _AdminOrdersState extends AdminOrdersState {
  const _AdminOrdersState({required this.query,  List<AdminOrderSummary> orders = const <AdminOrderSummary>[], this.totalCount = 0, this.totalMinor = 0, this.loadingMore = false}): _orders = orders,super._();
  

@override final  AdminOrderQuery query;
 final  List<AdminOrderSummary> _orders;
@override@JsonKey() List<AdminOrderSummary> get orders {
  if (_orders is EqualUnmodifiableListView) return _orders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_orders);
}

@override@JsonKey() final  int totalCount;
@override@JsonKey() final  int totalMinor;
@override@JsonKey() final  bool loadingMore;

/// Create a copy of AdminOrdersState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminOrdersStateCopyWith<_AdminOrdersState> get copyWith => __$AdminOrdersStateCopyWithImpl<_AdminOrdersState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminOrdersState&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other._orders, _orders)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore));
}


@override
int get hashCode => Object.hash(runtimeType,query,const DeepCollectionEquality().hash(_orders),totalCount,totalMinor,loadingMore);

@override
String toString() {
  return 'AdminOrdersState(query: $query, orders: $orders, totalCount: $totalCount, totalMinor: $totalMinor, loadingMore: $loadingMore)';
}


}

/// @nodoc
abstract mixin class _$AdminOrdersStateCopyWith<$Res> implements $AdminOrdersStateCopyWith<$Res> {
  factory _$AdminOrdersStateCopyWith(_AdminOrdersState value, $Res Function(_AdminOrdersState) _then) = __$AdminOrdersStateCopyWithImpl;
@override @useResult
$Res call({
 AdminOrderQuery query, List<AdminOrderSummary> orders, int totalCount, int totalMinor, bool loadingMore
});


@override $AdminOrderQueryCopyWith<$Res> get query;

}
/// @nodoc
class __$AdminOrdersStateCopyWithImpl<$Res>
    implements _$AdminOrdersStateCopyWith<$Res> {
  __$AdminOrdersStateCopyWithImpl(this._self, this._then);

  final _AdminOrdersState _self;
  final $Res Function(_AdminOrdersState) _then;

/// Create a copy of AdminOrdersState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? orders = null,Object? totalCount = null,Object? totalMinor = null,Object? loadingMore = null,}) {
  return _then(_AdminOrdersState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as AdminOrderQuery,orders: null == orders ? _self._orders : orders // ignore: cast_nullable_to_non_nullable
as List<AdminOrderSummary>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of AdminOrdersState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminOrderQueryCopyWith<$Res> get query {
  
  return $AdminOrderQueryCopyWith<$Res>(_self.query, (value) {
    return _then(_self.copyWith(query: value));
  });
}
}

// dart format on
