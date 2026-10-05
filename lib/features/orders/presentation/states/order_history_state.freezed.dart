// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_history_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderHistoryState {

 List<CustomerOrder> get items; bool get hasMore; bool get isLoadingMore; OrderHistoryGroup get group; DateTime? get fromDate; DateTime? get toDate;
/// Create a copy of OrderHistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderHistoryStateCopyWith<OrderHistoryState> get copyWith => _$OrderHistoryStateCopyWithImpl<OrderHistoryState>(this as OrderHistoryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderHistoryState&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.group, group) || other.group == group)&&(identical(other.fromDate, fromDate) || other.fromDate == fromDate)&&(identical(other.toDate, toDate) || other.toDate == toDate));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),hasMore,isLoadingMore,group,fromDate,toDate);

@override
String toString() {
  return 'OrderHistoryState(items: $items, hasMore: $hasMore, isLoadingMore: $isLoadingMore, group: $group, fromDate: $fromDate, toDate: $toDate)';
}


}

/// @nodoc
abstract mixin class $OrderHistoryStateCopyWith<$Res>  {
  factory $OrderHistoryStateCopyWith(OrderHistoryState value, $Res Function(OrderHistoryState) _then) = _$OrderHistoryStateCopyWithImpl;
@useResult
$Res call({
 List<CustomerOrder> items, bool hasMore, bool isLoadingMore, OrderHistoryGroup group, DateTime? fromDate, DateTime? toDate
});




}
/// @nodoc
class _$OrderHistoryStateCopyWithImpl<$Res>
    implements $OrderHistoryStateCopyWith<$Res> {
  _$OrderHistoryStateCopyWithImpl(this._self, this._then);

  final OrderHistoryState _self;
  final $Res Function(OrderHistoryState) _then;

/// Create a copy of OrderHistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? hasMore = null,Object? isLoadingMore = null,Object? group = null,Object? fromDate = freezed,Object? toDate = freezed,}) {
  return _then(OrderHistoryState(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CustomerOrder>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as OrderHistoryGroup,fromDate: freezed == fromDate ? _self.fromDate : fromDate // ignore: cast_nullable_to_non_nullable
as DateTime?,toDate: freezed == toDate ? _self.toDate : toDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderHistoryState].
extension OrderHistoryStatePatterns on OrderHistoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderHistoryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderHistoryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderHistoryState value)  $default,){
final _that = this;
switch (_that) {
case _OrderHistoryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderHistoryState value)?  $default,){
final _that = this;
switch (_that) {
case _OrderHistoryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CustomerOrder> items,  bool hasMore,  bool isLoadingMore,  OrderHistoryGroup group,  DateTime? fromDate,  DateTime? toDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderHistoryState() when $default != null:
return $default(_that.items,_that.hasMore,_that.isLoadingMore,_that.group,_that.fromDate,_that.toDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CustomerOrder> items,  bool hasMore,  bool isLoadingMore,  OrderHistoryGroup group,  DateTime? fromDate,  DateTime? toDate)  $default,) {final _that = this;
switch (_that) {
case _OrderHistoryState():
return $default(_that.items,_that.hasMore,_that.isLoadingMore,_that.group,_that.fromDate,_that.toDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CustomerOrder> items,  bool hasMore,  bool isLoadingMore,  OrderHistoryGroup group,  DateTime? fromDate,  DateTime? toDate)?  $default,) {final _that = this;
switch (_that) {
case _OrderHistoryState() when $default != null:
return $default(_that.items,_that.hasMore,_that.isLoadingMore,_that.group,_that.fromDate,_that.toDate);case _:
  return null;

}
}

}

/// @nodoc


class _OrderHistoryState implements OrderHistoryState {
  const _OrderHistoryState({ List<CustomerOrder> items = const [], this.hasMore = true, this.isLoadingMore = false, this.group = OrderHistoryGroup.all, this.fromDate, this.toDate}): _items = items;
  

 final  List<CustomerOrder> _items;
@override@JsonKey() List<CustomerOrder> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  bool hasMore;
@override@JsonKey() final  bool isLoadingMore;
@override@JsonKey() final  OrderHistoryGroup group;
@override final  DateTime? fromDate;
@override final  DateTime? toDate;

/// Create a copy of OrderHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderHistoryStateCopyWith<_OrderHistoryState> get copyWith => __$OrderHistoryStateCopyWithImpl<_OrderHistoryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderHistoryState&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.group, group) || other.group == group)&&(identical(other.fromDate, fromDate) || other.fromDate == fromDate)&&(identical(other.toDate, toDate) || other.toDate == toDate));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),hasMore,isLoadingMore,group,fromDate,toDate);

@override
String toString() {
  return 'OrderHistoryState(items: $items, hasMore: $hasMore, isLoadingMore: $isLoadingMore, group: $group, fromDate: $fromDate, toDate: $toDate)';
}


}

/// @nodoc
abstract mixin class _$OrderHistoryStateCopyWith<$Res> implements $OrderHistoryStateCopyWith<$Res> {
  factory _$OrderHistoryStateCopyWith(_OrderHistoryState value, $Res Function(_OrderHistoryState) _then) = __$OrderHistoryStateCopyWithImpl;
@override @useResult
$Res call({
 List<CustomerOrder> items, bool hasMore, bool isLoadingMore, OrderHistoryGroup group, DateTime? fromDate, DateTime? toDate
});




}
/// @nodoc
class __$OrderHistoryStateCopyWithImpl<$Res>
    implements _$OrderHistoryStateCopyWith<$Res> {
  __$OrderHistoryStateCopyWithImpl(this._self, this._then);

  final _OrderHistoryState _self;
  final $Res Function(_OrderHistoryState) _then;

/// Create a copy of OrderHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? hasMore = null,Object? isLoadingMore = null,Object? group = null,Object? fromDate = freezed,Object? toDate = freezed,}) {
  return _then(_OrderHistoryState(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CustomerOrder>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as OrderHistoryGroup,fromDate: freezed == fromDate ? _self.fromDate : fromDate // ignore: cast_nullable_to_non_nullable
as DateTime?,toDate: freezed == toDate ? _self.toDate : toDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
