// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_reports_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReportRange {

 DateTime get from; DateTime get to;
/// Create a copy of ReportRange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportRangeCopyWith<ReportRange> get copyWith => _$ReportRangeCopyWithImpl<ReportRange>(this as ReportRange, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportRange&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to));
}


@override
int get hashCode => Object.hash(runtimeType,from,to);

@override
String toString() {
  return 'ReportRange(from: $from, to: $to)';
}


}

/// @nodoc
abstract mixin class $ReportRangeCopyWith<$Res>  {
  factory $ReportRangeCopyWith(ReportRange value, $Res Function(ReportRange) _then) = _$ReportRangeCopyWithImpl;
@useResult
$Res call({
 DateTime from, DateTime to
});




}
/// @nodoc
class _$ReportRangeCopyWithImpl<$Res>
    implements $ReportRangeCopyWith<$Res> {
  _$ReportRangeCopyWithImpl(this._self, this._then);

  final ReportRange _self;
  final $Res Function(ReportRange) _then;

/// Create a copy of ReportRange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? to = null,}) {
  return _then(ReportRange(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportRange].
extension ReportRangePatterns on ReportRange {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportRange value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportRange() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportRange value)  $default,){
final _that = this;
switch (_that) {
case _ReportRange():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportRange value)?  $default,){
final _that = this;
switch (_that) {
case _ReportRange() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime from,  DateTime to)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportRange() when $default != null:
return $default(_that.from,_that.to);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime from,  DateTime to)  $default,) {final _that = this;
switch (_that) {
case _ReportRange():
return $default(_that.from,_that.to);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime from,  DateTime to)?  $default,) {final _that = this;
switch (_that) {
case _ReportRange() when $default != null:
return $default(_that.from,_that.to);case _:
  return null;

}
}

}

/// @nodoc


class _ReportRange implements ReportRange {
  const _ReportRange({required this.from, required this.to});
  

@override final  DateTime from;
@override final  DateTime to;

/// Create a copy of ReportRange
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportRangeCopyWith<_ReportRange> get copyWith => __$ReportRangeCopyWithImpl<_ReportRange>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportRange&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to));
}


@override
int get hashCode => Object.hash(runtimeType,from,to);

@override
String toString() {
  return 'ReportRange(from: $from, to: $to)';
}


}

/// @nodoc
abstract mixin class _$ReportRangeCopyWith<$Res> implements $ReportRangeCopyWith<$Res> {
  factory _$ReportRangeCopyWith(_ReportRange value, $Res Function(_ReportRange) _then) = __$ReportRangeCopyWithImpl;
@override @useResult
$Res call({
 DateTime from, DateTime to
});




}
/// @nodoc
class __$ReportRangeCopyWithImpl<$Res>
    implements _$ReportRangeCopyWith<$Res> {
  __$ReportRangeCopyWithImpl(this._self, this._then);

  final _ReportRange _self;
  final $Res Function(_ReportRange) _then;

/// Create a copy of ReportRange
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,}) {
  return _then(_ReportRange(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
