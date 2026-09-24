// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BusinessAnalytics {

 int get totalSalesMinor; int get orderCount; int get pendingCount; int get completedCount; int get rejectedCount; List<TopProduct> get topProducts;
/// Create a copy of BusinessAnalytics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BusinessAnalyticsCopyWith<BusinessAnalytics> get copyWith => _$BusinessAnalyticsCopyWithImpl<BusinessAnalytics>(this as BusinessAnalytics, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BusinessAnalytics&&(identical(other.totalSalesMinor, totalSalesMinor) || other.totalSalesMinor == totalSalesMinor)&&(identical(other.orderCount, orderCount) || other.orderCount == orderCount)&&(identical(other.pendingCount, pendingCount) || other.pendingCount == pendingCount)&&(identical(other.completedCount, completedCount) || other.completedCount == completedCount)&&(identical(other.rejectedCount, rejectedCount) || other.rejectedCount == rejectedCount)&&const DeepCollectionEquality().equals(other.topProducts, topProducts));
}


@override
int get hashCode => Object.hash(runtimeType,totalSalesMinor,orderCount,pendingCount,completedCount,rejectedCount,const DeepCollectionEquality().hash(topProducts));

@override
String toString() {
  return 'BusinessAnalytics(totalSalesMinor: $totalSalesMinor, orderCount: $orderCount, pendingCount: $pendingCount, completedCount: $completedCount, rejectedCount: $rejectedCount, topProducts: $topProducts)';
}


}

/// @nodoc
abstract mixin class $BusinessAnalyticsCopyWith<$Res>  {
  factory $BusinessAnalyticsCopyWith(BusinessAnalytics value, $Res Function(BusinessAnalytics) _then) = _$BusinessAnalyticsCopyWithImpl;
@useResult
$Res call({
 int totalSalesMinor, int orderCount, int pendingCount, int completedCount, int rejectedCount, List<TopProduct> topProducts
});




}
/// @nodoc
class _$BusinessAnalyticsCopyWithImpl<$Res>
    implements $BusinessAnalyticsCopyWith<$Res> {
  _$BusinessAnalyticsCopyWithImpl(this._self, this._then);

  final BusinessAnalytics _self;
  final $Res Function(BusinessAnalytics) _then;

/// Create a copy of BusinessAnalytics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalSalesMinor = null,Object? orderCount = null,Object? pendingCount = null,Object? completedCount = null,Object? rejectedCount = null,Object? topProducts = null,}) {
  return _then(BusinessAnalytics(
totalSalesMinor: null == totalSalesMinor ? _self.totalSalesMinor : totalSalesMinor // ignore: cast_nullable_to_non_nullable
as int,orderCount: null == orderCount ? _self.orderCount : orderCount // ignore: cast_nullable_to_non_nullable
as int,pendingCount: null == pendingCount ? _self.pendingCount : pendingCount // ignore: cast_nullable_to_non_nullable
as int,completedCount: null == completedCount ? _self.completedCount : completedCount // ignore: cast_nullable_to_non_nullable
as int,rejectedCount: null == rejectedCount ? _self.rejectedCount : rejectedCount // ignore: cast_nullable_to_non_nullable
as int,topProducts: null == topProducts ? _self.topProducts : topProducts // ignore: cast_nullable_to_non_nullable
as List<TopProduct>,
  ));
}

}


/// Adds pattern-matching-related methods to [BusinessAnalytics].
extension BusinessAnalyticsPatterns on BusinessAnalytics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BusinessAnalytics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BusinessAnalytics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BusinessAnalytics value)  $default,){
final _that = this;
switch (_that) {
case _BusinessAnalytics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BusinessAnalytics value)?  $default,){
final _that = this;
switch (_that) {
case _BusinessAnalytics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalSalesMinor,  int orderCount,  int pendingCount,  int completedCount,  int rejectedCount,  List<TopProduct> topProducts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BusinessAnalytics() when $default != null:
return $default(_that.totalSalesMinor,_that.orderCount,_that.pendingCount,_that.completedCount,_that.rejectedCount,_that.topProducts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalSalesMinor,  int orderCount,  int pendingCount,  int completedCount,  int rejectedCount,  List<TopProduct> topProducts)  $default,) {final _that = this;
switch (_that) {
case _BusinessAnalytics():
return $default(_that.totalSalesMinor,_that.orderCount,_that.pendingCount,_that.completedCount,_that.rejectedCount,_that.topProducts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalSalesMinor,  int orderCount,  int pendingCount,  int completedCount,  int rejectedCount,  List<TopProduct> topProducts)?  $default,) {final _that = this;
switch (_that) {
case _BusinessAnalytics() when $default != null:
return $default(_that.totalSalesMinor,_that.orderCount,_that.pendingCount,_that.completedCount,_that.rejectedCount,_that.topProducts);case _:
  return null;

}
}

}

/// @nodoc


class _BusinessAnalytics implements BusinessAnalytics {
  const _BusinessAnalytics({required this.totalSalesMinor, required this.orderCount, required this.pendingCount, required this.completedCount, required this.rejectedCount, required  List<TopProduct> topProducts}): _topProducts = topProducts;
  

@override final  int totalSalesMinor;
@override final  int orderCount;
@override final  int pendingCount;
@override final  int completedCount;
@override final  int rejectedCount;
 final  List<TopProduct> _topProducts;
@override List<TopProduct> get topProducts {
  if (_topProducts is EqualUnmodifiableListView) return _topProducts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topProducts);
}


/// Create a copy of BusinessAnalytics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BusinessAnalyticsCopyWith<_BusinessAnalytics> get copyWith => __$BusinessAnalyticsCopyWithImpl<_BusinessAnalytics>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BusinessAnalytics&&(identical(other.totalSalesMinor, totalSalesMinor) || other.totalSalesMinor == totalSalesMinor)&&(identical(other.orderCount, orderCount) || other.orderCount == orderCount)&&(identical(other.pendingCount, pendingCount) || other.pendingCount == pendingCount)&&(identical(other.completedCount, completedCount) || other.completedCount == completedCount)&&(identical(other.rejectedCount, rejectedCount) || other.rejectedCount == rejectedCount)&&const DeepCollectionEquality().equals(other._topProducts, _topProducts));
}


@override
int get hashCode => Object.hash(runtimeType,totalSalesMinor,orderCount,pendingCount,completedCount,rejectedCount,const DeepCollectionEquality().hash(_topProducts));

@override
String toString() {
  return 'BusinessAnalytics(totalSalesMinor: $totalSalesMinor, orderCount: $orderCount, pendingCount: $pendingCount, completedCount: $completedCount, rejectedCount: $rejectedCount, topProducts: $topProducts)';
}


}

/// @nodoc
abstract mixin class _$BusinessAnalyticsCopyWith<$Res> implements $BusinessAnalyticsCopyWith<$Res> {
  factory _$BusinessAnalyticsCopyWith(_BusinessAnalytics value, $Res Function(_BusinessAnalytics) _then) = __$BusinessAnalyticsCopyWithImpl;
@override @useResult
$Res call({
 int totalSalesMinor, int orderCount, int pendingCount, int completedCount, int rejectedCount, List<TopProduct> topProducts
});




}
/// @nodoc
class __$BusinessAnalyticsCopyWithImpl<$Res>
    implements _$BusinessAnalyticsCopyWith<$Res> {
  __$BusinessAnalyticsCopyWithImpl(this._self, this._then);

  final _BusinessAnalytics _self;
  final $Res Function(_BusinessAnalytics) _then;

/// Create a copy of BusinessAnalytics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalSalesMinor = null,Object? orderCount = null,Object? pendingCount = null,Object? completedCount = null,Object? rejectedCount = null,Object? topProducts = null,}) {
  return _then(_BusinessAnalytics(
totalSalesMinor: null == totalSalesMinor ? _self.totalSalesMinor : totalSalesMinor // ignore: cast_nullable_to_non_nullable
as int,orderCount: null == orderCount ? _self.orderCount : orderCount // ignore: cast_nullable_to_non_nullable
as int,pendingCount: null == pendingCount ? _self.pendingCount : pendingCount // ignore: cast_nullable_to_non_nullable
as int,completedCount: null == completedCount ? _self.completedCount : completedCount // ignore: cast_nullable_to_non_nullable
as int,rejectedCount: null == rejectedCount ? _self.rejectedCount : rejectedCount // ignore: cast_nullable_to_non_nullable
as int,topProducts: null == topProducts ? _self._topProducts : topProducts // ignore: cast_nullable_to_non_nullable
as List<TopProduct>,
  ));
}


}

/// @nodoc
mixin _$TopProduct {

 String get name; int get quantity; int get revenueMinor;
/// Create a copy of TopProduct
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopProductCopyWith<TopProduct> get copyWith => _$TopProductCopyWithImpl<TopProduct>(this as TopProduct, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TopProduct&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.revenueMinor, revenueMinor) || other.revenueMinor == revenueMinor));
}


@override
int get hashCode => Object.hash(runtimeType,name,quantity,revenueMinor);

@override
String toString() {
  return 'TopProduct(name: $name, quantity: $quantity, revenueMinor: $revenueMinor)';
}


}

/// @nodoc
abstract mixin class $TopProductCopyWith<$Res>  {
  factory $TopProductCopyWith(TopProduct value, $Res Function(TopProduct) _then) = _$TopProductCopyWithImpl;
@useResult
$Res call({
 String name, int quantity, int revenueMinor
});




}
/// @nodoc
class _$TopProductCopyWithImpl<$Res>
    implements $TopProductCopyWith<$Res> {
  _$TopProductCopyWithImpl(this._self, this._then);

  final TopProduct _self;
  final $Res Function(TopProduct) _then;

/// Create a copy of TopProduct
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? quantity = null,Object? revenueMinor = null,}) {
  return _then(TopProduct(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,revenueMinor: null == revenueMinor ? _self.revenueMinor : revenueMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TopProduct].
extension TopProductPatterns on TopProduct {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TopProduct value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TopProduct() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TopProduct value)  $default,){
final _that = this;
switch (_that) {
case _TopProduct():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TopProduct value)?  $default,){
final _that = this;
switch (_that) {
case _TopProduct() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int quantity,  int revenueMinor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TopProduct() when $default != null:
return $default(_that.name,_that.quantity,_that.revenueMinor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int quantity,  int revenueMinor)  $default,) {final _that = this;
switch (_that) {
case _TopProduct():
return $default(_that.name,_that.quantity,_that.revenueMinor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int quantity,  int revenueMinor)?  $default,) {final _that = this;
switch (_that) {
case _TopProduct() when $default != null:
return $default(_that.name,_that.quantity,_that.revenueMinor);case _:
  return null;

}
}

}

/// @nodoc


class _TopProduct implements TopProduct {
  const _TopProduct({required this.name, required this.quantity, required this.revenueMinor});
  

@override final  String name;
@override final  int quantity;
@override final  int revenueMinor;

/// Create a copy of TopProduct
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopProductCopyWith<_TopProduct> get copyWith => __$TopProductCopyWithImpl<_TopProduct>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopProduct&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.revenueMinor, revenueMinor) || other.revenueMinor == revenueMinor));
}


@override
int get hashCode => Object.hash(runtimeType,name,quantity,revenueMinor);

@override
String toString() {
  return 'TopProduct(name: $name, quantity: $quantity, revenueMinor: $revenueMinor)';
}


}

/// @nodoc
abstract mixin class _$TopProductCopyWith<$Res> implements $TopProductCopyWith<$Res> {
  factory _$TopProductCopyWith(_TopProduct value, $Res Function(_TopProduct) _then) = __$TopProductCopyWithImpl;
@override @useResult
$Res call({
 String name, int quantity, int revenueMinor
});




}
/// @nodoc
class __$TopProductCopyWithImpl<$Res>
    implements _$TopProductCopyWith<$Res> {
  __$TopProductCopyWithImpl(this._self, this._then);

  final _TopProduct _self;
  final $Res Function(_TopProduct) _then;

/// Create a copy of TopProduct
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? quantity = null,Object? revenueMinor = null,}) {
  return _then(_TopProduct(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,revenueMinor: null == revenueMinor ? _self.revenueMinor : revenueMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
