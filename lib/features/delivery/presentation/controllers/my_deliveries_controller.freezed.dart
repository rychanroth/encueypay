// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_deliveries_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MyDeliveriesState {

 DriverDelivery? get activeDelivery; List<DriverDelivery> get history;
/// Create a copy of MyDeliveriesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyDeliveriesStateCopyWith<MyDeliveriesState> get copyWith => _$MyDeliveriesStateCopyWithImpl<MyDeliveriesState>(this as MyDeliveriesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyDeliveriesState&&(identical(other.activeDelivery, activeDelivery) || other.activeDelivery == activeDelivery)&&const DeepCollectionEquality().equals(other.history, history));
}


@override
int get hashCode => Object.hash(runtimeType,activeDelivery,const DeepCollectionEquality().hash(history));

@override
String toString() {
  return 'MyDeliveriesState(activeDelivery: $activeDelivery, history: $history)';
}


}

/// @nodoc
abstract mixin class $MyDeliveriesStateCopyWith<$Res>  {
  factory $MyDeliveriesStateCopyWith(MyDeliveriesState value, $Res Function(MyDeliveriesState) _then) = _$MyDeliveriesStateCopyWithImpl;
@useResult
$Res call({
 DriverDelivery? activeDelivery, List<DriverDelivery> history
});


$DriverDeliveryCopyWith<$Res>? get activeDelivery;

}
/// @nodoc
class _$MyDeliveriesStateCopyWithImpl<$Res>
    implements $MyDeliveriesStateCopyWith<$Res> {
  _$MyDeliveriesStateCopyWithImpl(this._self, this._then);

  final MyDeliveriesState _self;
  final $Res Function(MyDeliveriesState) _then;

/// Create a copy of MyDeliveriesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activeDelivery = freezed,Object? history = null,}) {
  return _then(MyDeliveriesState(
activeDelivery: freezed == activeDelivery ? _self.activeDelivery : activeDelivery // ignore: cast_nullable_to_non_nullable
as DriverDelivery?,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<DriverDelivery>,
  ));
}
/// Create a copy of MyDeliveriesState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DriverDeliveryCopyWith<$Res>? get activeDelivery {
    if (_self.activeDelivery == null) {
    return null;
  }

  return $DriverDeliveryCopyWith<$Res>(_self.activeDelivery!, (value) {
    return _then(_self.copyWith(activeDelivery: value));
  });
}
}


/// Adds pattern-matching-related methods to [MyDeliveriesState].
extension MyDeliveriesStatePatterns on MyDeliveriesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyDeliveriesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyDeliveriesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyDeliveriesState value)  $default,){
final _that = this;
switch (_that) {
case _MyDeliveriesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyDeliveriesState value)?  $default,){
final _that = this;
switch (_that) {
case _MyDeliveriesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DriverDelivery? activeDelivery,  List<DriverDelivery> history)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyDeliveriesState() when $default != null:
return $default(_that.activeDelivery,_that.history);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DriverDelivery? activeDelivery,  List<DriverDelivery> history)  $default,) {final _that = this;
switch (_that) {
case _MyDeliveriesState():
return $default(_that.activeDelivery,_that.history);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DriverDelivery? activeDelivery,  List<DriverDelivery> history)?  $default,) {final _that = this;
switch (_that) {
case _MyDeliveriesState() when $default != null:
return $default(_that.activeDelivery,_that.history);case _:
  return null;

}
}

}

/// @nodoc


class _MyDeliveriesState implements MyDeliveriesState {
  const _MyDeliveriesState({this.activeDelivery,  List<DriverDelivery> history = const []}): _history = history;
  

@override final  DriverDelivery? activeDelivery;
 final  List<DriverDelivery> _history;
@override@JsonKey() List<DriverDelivery> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}


/// Create a copy of MyDeliveriesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyDeliveriesStateCopyWith<_MyDeliveriesState> get copyWith => __$MyDeliveriesStateCopyWithImpl<_MyDeliveriesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyDeliveriesState&&(identical(other.activeDelivery, activeDelivery) || other.activeDelivery == activeDelivery)&&const DeepCollectionEquality().equals(other._history, _history));
}


@override
int get hashCode => Object.hash(runtimeType,activeDelivery,const DeepCollectionEquality().hash(_history));

@override
String toString() {
  return 'MyDeliveriesState(activeDelivery: $activeDelivery, history: $history)';
}


}

/// @nodoc
abstract mixin class _$MyDeliveriesStateCopyWith<$Res> implements $MyDeliveriesStateCopyWith<$Res> {
  factory _$MyDeliveriesStateCopyWith(_MyDeliveriesState value, $Res Function(_MyDeliveriesState) _then) = __$MyDeliveriesStateCopyWithImpl;
@override @useResult
$Res call({
 DriverDelivery? activeDelivery, List<DriverDelivery> history
});


@override $DriverDeliveryCopyWith<$Res>? get activeDelivery;

}
/// @nodoc
class __$MyDeliveriesStateCopyWithImpl<$Res>
    implements _$MyDeliveriesStateCopyWith<$Res> {
  __$MyDeliveriesStateCopyWithImpl(this._self, this._then);

  final _MyDeliveriesState _self;
  final $Res Function(_MyDeliveriesState) _then;

/// Create a copy of MyDeliveriesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activeDelivery = freezed,Object? history = null,}) {
  return _then(_MyDeliveriesState(
activeDelivery: freezed == activeDelivery ? _self.activeDelivery : activeDelivery // ignore: cast_nullable_to_non_nullable
as DriverDelivery?,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<DriverDelivery>,
  ));
}

/// Create a copy of MyDeliveriesState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DriverDeliveryCopyWith<$Res>? get activeDelivery {
    if (_self.activeDelivery == null) {
    return null;
  }

  return $DriverDeliveryCopyWith<$Res>(_self.activeDelivery!, (value) {
    return _then(_self.copyWith(activeDelivery: value));
  });
}
}

// dart format on
