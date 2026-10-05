// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardSummary {

 int get activeOrders; int get wishlistCount; int get cartItemCount; int get cartSubtotalMinor; int get totalSpendingMinor; int get completedOrders; int get cancelledOrders; int get totalOrders; List<DashboardOrder> get recentOrders;
/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardSummaryCopyWith<DashboardSummary> get copyWith => _$DashboardSummaryCopyWithImpl<DashboardSummary>(this as DashboardSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardSummary&&(identical(other.activeOrders, activeOrders) || other.activeOrders == activeOrders)&&(identical(other.wishlistCount, wishlistCount) || other.wishlistCount == wishlistCount)&&(identical(other.cartItemCount, cartItemCount) || other.cartItemCount == cartItemCount)&&(identical(other.cartSubtotalMinor, cartSubtotalMinor) || other.cartSubtotalMinor == cartSubtotalMinor)&&(identical(other.totalSpendingMinor, totalSpendingMinor) || other.totalSpendingMinor == totalSpendingMinor)&&(identical(other.completedOrders, completedOrders) || other.completedOrders == completedOrders)&&(identical(other.cancelledOrders, cancelledOrders) || other.cancelledOrders == cancelledOrders)&&(identical(other.totalOrders, totalOrders) || other.totalOrders == totalOrders)&&const DeepCollectionEquality().equals(other.recentOrders, recentOrders));
}


@override
int get hashCode => Object.hash(runtimeType,activeOrders,wishlistCount,cartItemCount,cartSubtotalMinor,totalSpendingMinor,completedOrders,cancelledOrders,totalOrders,const DeepCollectionEquality().hash(recentOrders));

@override
String toString() {
  return 'DashboardSummary(activeOrders: $activeOrders, wishlistCount: $wishlistCount, cartItemCount: $cartItemCount, cartSubtotalMinor: $cartSubtotalMinor, totalSpendingMinor: $totalSpendingMinor, completedOrders: $completedOrders, cancelledOrders: $cancelledOrders, totalOrders: $totalOrders, recentOrders: $recentOrders)';
}


}

/// @nodoc
abstract mixin class $DashboardSummaryCopyWith<$Res>  {
  factory $DashboardSummaryCopyWith(DashboardSummary value, $Res Function(DashboardSummary) _then) = _$DashboardSummaryCopyWithImpl;
@useResult
$Res call({
 int activeOrders, int wishlistCount, int cartItemCount, int cartSubtotalMinor, int totalSpendingMinor, int completedOrders, int cancelledOrders, int totalOrders, List<DashboardOrder> recentOrders
});




}
/// @nodoc
class _$DashboardSummaryCopyWithImpl<$Res>
    implements $DashboardSummaryCopyWith<$Res> {
  _$DashboardSummaryCopyWithImpl(this._self, this._then);

  final DashboardSummary _self;
  final $Res Function(DashboardSummary) _then;

/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activeOrders = null,Object? wishlistCount = null,Object? cartItemCount = null,Object? cartSubtotalMinor = null,Object? totalSpendingMinor = null,Object? completedOrders = null,Object? cancelledOrders = null,Object? totalOrders = null,Object? recentOrders = null,}) {
  return _then(DashboardSummary(
activeOrders: null == activeOrders ? _self.activeOrders : activeOrders // ignore: cast_nullable_to_non_nullable
as int,wishlistCount: null == wishlistCount ? _self.wishlistCount : wishlistCount // ignore: cast_nullable_to_non_nullable
as int,cartItemCount: null == cartItemCount ? _self.cartItemCount : cartItemCount // ignore: cast_nullable_to_non_nullable
as int,cartSubtotalMinor: null == cartSubtotalMinor ? _self.cartSubtotalMinor : cartSubtotalMinor // ignore: cast_nullable_to_non_nullable
as int,totalSpendingMinor: null == totalSpendingMinor ? _self.totalSpendingMinor : totalSpendingMinor // ignore: cast_nullable_to_non_nullable
as int,completedOrders: null == completedOrders ? _self.completedOrders : completedOrders // ignore: cast_nullable_to_non_nullable
as int,cancelledOrders: null == cancelledOrders ? _self.cancelledOrders : cancelledOrders // ignore: cast_nullable_to_non_nullable
as int,totalOrders: null == totalOrders ? _self.totalOrders : totalOrders // ignore: cast_nullable_to_non_nullable
as int,recentOrders: null == recentOrders ? _self.recentOrders : recentOrders // ignore: cast_nullable_to_non_nullable
as List<DashboardOrder>,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardSummary].
extension DashboardSummaryPatterns on DashboardSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardSummary value)  $default,){
final _that = this;
switch (_that) {
case _DashboardSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardSummary value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int activeOrders,  int wishlistCount,  int cartItemCount,  int cartSubtotalMinor,  int totalSpendingMinor,  int completedOrders,  int cancelledOrders,  int totalOrders,  List<DashboardOrder> recentOrders)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
return $default(_that.activeOrders,_that.wishlistCount,_that.cartItemCount,_that.cartSubtotalMinor,_that.totalSpendingMinor,_that.completedOrders,_that.cancelledOrders,_that.totalOrders,_that.recentOrders);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int activeOrders,  int wishlistCount,  int cartItemCount,  int cartSubtotalMinor,  int totalSpendingMinor,  int completedOrders,  int cancelledOrders,  int totalOrders,  List<DashboardOrder> recentOrders)  $default,) {final _that = this;
switch (_that) {
case _DashboardSummary():
return $default(_that.activeOrders,_that.wishlistCount,_that.cartItemCount,_that.cartSubtotalMinor,_that.totalSpendingMinor,_that.completedOrders,_that.cancelledOrders,_that.totalOrders,_that.recentOrders);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int activeOrders,  int wishlistCount,  int cartItemCount,  int cartSubtotalMinor,  int totalSpendingMinor,  int completedOrders,  int cancelledOrders,  int totalOrders,  List<DashboardOrder> recentOrders)?  $default,) {final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
return $default(_that.activeOrders,_that.wishlistCount,_that.cartItemCount,_that.cartSubtotalMinor,_that.totalSpendingMinor,_that.completedOrders,_that.cancelledOrders,_that.totalOrders,_that.recentOrders);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardSummary implements DashboardSummary {
  const _DashboardSummary({required this.activeOrders, required this.wishlistCount, required this.cartItemCount, required this.cartSubtotalMinor, required this.totalSpendingMinor, required this.completedOrders, required this.cancelledOrders, required this.totalOrders,  List<DashboardOrder> recentOrders = const []}): _recentOrders = recentOrders;
  

@override final  int activeOrders;
@override final  int wishlistCount;
@override final  int cartItemCount;
@override final  int cartSubtotalMinor;
@override final  int totalSpendingMinor;
@override final  int completedOrders;
@override final  int cancelledOrders;
@override final  int totalOrders;
 final  List<DashboardOrder> _recentOrders;
@override@JsonKey() List<DashboardOrder> get recentOrders {
  if (_recentOrders is EqualUnmodifiableListView) return _recentOrders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentOrders);
}


/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardSummaryCopyWith<_DashboardSummary> get copyWith => __$DashboardSummaryCopyWithImpl<_DashboardSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardSummary&&(identical(other.activeOrders, activeOrders) || other.activeOrders == activeOrders)&&(identical(other.wishlistCount, wishlistCount) || other.wishlistCount == wishlistCount)&&(identical(other.cartItemCount, cartItemCount) || other.cartItemCount == cartItemCount)&&(identical(other.cartSubtotalMinor, cartSubtotalMinor) || other.cartSubtotalMinor == cartSubtotalMinor)&&(identical(other.totalSpendingMinor, totalSpendingMinor) || other.totalSpendingMinor == totalSpendingMinor)&&(identical(other.completedOrders, completedOrders) || other.completedOrders == completedOrders)&&(identical(other.cancelledOrders, cancelledOrders) || other.cancelledOrders == cancelledOrders)&&(identical(other.totalOrders, totalOrders) || other.totalOrders == totalOrders)&&const DeepCollectionEquality().equals(other._recentOrders, _recentOrders));
}


@override
int get hashCode => Object.hash(runtimeType,activeOrders,wishlistCount,cartItemCount,cartSubtotalMinor,totalSpendingMinor,completedOrders,cancelledOrders,totalOrders,const DeepCollectionEquality().hash(_recentOrders));

@override
String toString() {
  return 'DashboardSummary(activeOrders: $activeOrders, wishlistCount: $wishlistCount, cartItemCount: $cartItemCount, cartSubtotalMinor: $cartSubtotalMinor, totalSpendingMinor: $totalSpendingMinor, completedOrders: $completedOrders, cancelledOrders: $cancelledOrders, totalOrders: $totalOrders, recentOrders: $recentOrders)';
}


}

/// @nodoc
abstract mixin class _$DashboardSummaryCopyWith<$Res> implements $DashboardSummaryCopyWith<$Res> {
  factory _$DashboardSummaryCopyWith(_DashboardSummary value, $Res Function(_DashboardSummary) _then) = __$DashboardSummaryCopyWithImpl;
@override @useResult
$Res call({
 int activeOrders, int wishlistCount, int cartItemCount, int cartSubtotalMinor, int totalSpendingMinor, int completedOrders, int cancelledOrders, int totalOrders, List<DashboardOrder> recentOrders
});




}
/// @nodoc
class __$DashboardSummaryCopyWithImpl<$Res>
    implements _$DashboardSummaryCopyWith<$Res> {
  __$DashboardSummaryCopyWithImpl(this._self, this._then);

  final _DashboardSummary _self;
  final $Res Function(_DashboardSummary) _then;

/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activeOrders = null,Object? wishlistCount = null,Object? cartItemCount = null,Object? cartSubtotalMinor = null,Object? totalSpendingMinor = null,Object? completedOrders = null,Object? cancelledOrders = null,Object? totalOrders = null,Object? recentOrders = null,}) {
  return _then(_DashboardSummary(
activeOrders: null == activeOrders ? _self.activeOrders : activeOrders // ignore: cast_nullable_to_non_nullable
as int,wishlistCount: null == wishlistCount ? _self.wishlistCount : wishlistCount // ignore: cast_nullable_to_non_nullable
as int,cartItemCount: null == cartItemCount ? _self.cartItemCount : cartItemCount // ignore: cast_nullable_to_non_nullable
as int,cartSubtotalMinor: null == cartSubtotalMinor ? _self.cartSubtotalMinor : cartSubtotalMinor // ignore: cast_nullable_to_non_nullable
as int,totalSpendingMinor: null == totalSpendingMinor ? _self.totalSpendingMinor : totalSpendingMinor // ignore: cast_nullable_to_non_nullable
as int,completedOrders: null == completedOrders ? _self.completedOrders : completedOrders // ignore: cast_nullable_to_non_nullable
as int,cancelledOrders: null == cancelledOrders ? _self.cancelledOrders : cancelledOrders // ignore: cast_nullable_to_non_nullable
as int,totalOrders: null == totalOrders ? _self.totalOrders : totalOrders // ignore: cast_nullable_to_non_nullable
as int,recentOrders: null == recentOrders ? _self._recentOrders : recentOrders // ignore: cast_nullable_to_non_nullable
as List<DashboardOrder>,
  ));
}


}

/// @nodoc
mixin _$DashboardOrder {

 String get id; int get totalMinor; DateTime get createdAt; String get state;
/// Create a copy of DashboardOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardOrderCopyWith<DashboardOrder> get copyWith => _$DashboardOrderCopyWithImpl<DashboardOrder>(this as DashboardOrder, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.state, state) || other.state == state));
}


@override
int get hashCode => Object.hash(runtimeType,id,totalMinor,createdAt,state);

@override
String toString() {
  return 'DashboardOrder(id: $id, totalMinor: $totalMinor, createdAt: $createdAt, state: $state)';
}


}

/// @nodoc
abstract mixin class $DashboardOrderCopyWith<$Res>  {
  factory $DashboardOrderCopyWith(DashboardOrder value, $Res Function(DashboardOrder) _then) = _$DashboardOrderCopyWithImpl;
@useResult
$Res call({
 String id, int totalMinor, DateTime createdAt, String state
});




}
/// @nodoc
class _$DashboardOrderCopyWithImpl<$Res>
    implements $DashboardOrderCopyWith<$Res> {
  _$DashboardOrderCopyWithImpl(this._self, this._then);

  final DashboardOrder _self;
  final $Res Function(DashboardOrder) _then;

/// Create a copy of DashboardOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? totalMinor = null,Object? createdAt = null,Object? state = null,}) {
  return _then(DashboardOrder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardOrder].
extension DashboardOrderPatterns on DashboardOrder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardOrder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardOrder value)  $default,){
final _that = this;
switch (_that) {
case _DashboardOrder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardOrder value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardOrder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int totalMinor,  DateTime createdAt,  String state)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardOrder() when $default != null:
return $default(_that.id,_that.totalMinor,_that.createdAt,_that.state);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int totalMinor,  DateTime createdAt,  String state)  $default,) {final _that = this;
switch (_that) {
case _DashboardOrder():
return $default(_that.id,_that.totalMinor,_that.createdAt,_that.state);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int totalMinor,  DateTime createdAt,  String state)?  $default,) {final _that = this;
switch (_that) {
case _DashboardOrder() when $default != null:
return $default(_that.id,_that.totalMinor,_that.createdAt,_that.state);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardOrder implements DashboardOrder {
  const _DashboardOrder({required this.id, required this.totalMinor, required this.createdAt, this.state = 'active'});
  

@override final  String id;
@override final  int totalMinor;
@override final  DateTime createdAt;
@override@JsonKey() final  String state;

/// Create a copy of DashboardOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardOrderCopyWith<_DashboardOrder> get copyWith => __$DashboardOrderCopyWithImpl<_DashboardOrder>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.state, state) || other.state == state));
}


@override
int get hashCode => Object.hash(runtimeType,id,totalMinor,createdAt,state);

@override
String toString() {
  return 'DashboardOrder(id: $id, totalMinor: $totalMinor, createdAt: $createdAt, state: $state)';
}


}

/// @nodoc
abstract mixin class _$DashboardOrderCopyWith<$Res> implements $DashboardOrderCopyWith<$Res> {
  factory _$DashboardOrderCopyWith(_DashboardOrder value, $Res Function(_DashboardOrder) _then) = __$DashboardOrderCopyWithImpl;
@override @useResult
$Res call({
 String id, int totalMinor, DateTime createdAt, String state
});




}
/// @nodoc
class __$DashboardOrderCopyWithImpl<$Res>
    implements _$DashboardOrderCopyWith<$Res> {
  __$DashboardOrderCopyWithImpl(this._self, this._then);

  final _DashboardOrder _self;
  final $Res Function(_DashboardOrder) _then;

/// Create a copy of DashboardOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? totalMinor = null,Object? createdAt = null,Object? state = null,}) {
  return _then(_DashboardOrder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
