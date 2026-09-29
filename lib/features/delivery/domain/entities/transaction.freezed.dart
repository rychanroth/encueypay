// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DriverTransactionEntry {

 String get id; DateTime get occurredAt; int get amountMinor; String get label;
/// Create a copy of DriverTransactionEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DriverTransactionEntryCopyWith<DriverTransactionEntry> get copyWith => _$DriverTransactionEntryCopyWithImpl<DriverTransactionEntry>(this as DriverTransactionEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DriverTransactionEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.label, label) || other.label == label));
}


@override
int get hashCode => Object.hash(runtimeType,id,occurredAt,amountMinor,label);

@override
String toString() {
  return 'DriverTransactionEntry(id: $id, occurredAt: $occurredAt, amountMinor: $amountMinor, label: $label)';
}


}

/// @nodoc
abstract mixin class $DriverTransactionEntryCopyWith<$Res>  {
  factory $DriverTransactionEntryCopyWith(DriverTransactionEntry value, $Res Function(DriverTransactionEntry) _then) = _$DriverTransactionEntryCopyWithImpl;
@useResult
$Res call({
 String id, DateTime occurredAt, int amountMinor, String label
});




}
/// @nodoc
class _$DriverTransactionEntryCopyWithImpl<$Res>
    implements $DriverTransactionEntryCopyWith<$Res> {
  _$DriverTransactionEntryCopyWithImpl(this._self, this._then);

  final DriverTransactionEntry _self;
  final $Res Function(DriverTransactionEntry) _then;

/// Create a copy of DriverTransactionEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? occurredAt = null,Object? amountMinor = null,Object? label = null,}) {
  return _then(DriverTransactionEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DriverTransactionEntry].
extension DriverTransactionEntryPatterns on DriverTransactionEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DriverTransactionEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DriverTransactionEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DriverTransactionEntry value)  $default,){
final _that = this;
switch (_that) {
case _DriverTransactionEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DriverTransactionEntry value)?  $default,){
final _that = this;
switch (_that) {
case _DriverTransactionEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime occurredAt,  int amountMinor,  String label)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DriverTransactionEntry() when $default != null:
return $default(_that.id,_that.occurredAt,_that.amountMinor,_that.label);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime occurredAt,  int amountMinor,  String label)  $default,) {final _that = this;
switch (_that) {
case _DriverTransactionEntry():
return $default(_that.id,_that.occurredAt,_that.amountMinor,_that.label);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime occurredAt,  int amountMinor,  String label)?  $default,) {final _that = this;
switch (_that) {
case _DriverTransactionEntry() when $default != null:
return $default(_that.id,_that.occurredAt,_that.amountMinor,_that.label);case _:
  return null;

}
}

}

/// @nodoc


class _DriverTransactionEntry implements DriverTransactionEntry {
  const _DriverTransactionEntry({required this.id, required this.occurredAt, required this.amountMinor, required this.label});
  

@override final  String id;
@override final  DateTime occurredAt;
@override final  int amountMinor;
@override final  String label;

/// Create a copy of DriverTransactionEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DriverTransactionEntryCopyWith<_DriverTransactionEntry> get copyWith => __$DriverTransactionEntryCopyWithImpl<_DriverTransactionEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DriverTransactionEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.label, label) || other.label == label));
}


@override
int get hashCode => Object.hash(runtimeType,id,occurredAt,amountMinor,label);

@override
String toString() {
  return 'DriverTransactionEntry(id: $id, occurredAt: $occurredAt, amountMinor: $amountMinor, label: $label)';
}


}

/// @nodoc
abstract mixin class _$DriverTransactionEntryCopyWith<$Res> implements $DriverTransactionEntryCopyWith<$Res> {
  factory _$DriverTransactionEntryCopyWith(_DriverTransactionEntry value, $Res Function(_DriverTransactionEntry) _then) = __$DriverTransactionEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime occurredAt, int amountMinor, String label
});




}
/// @nodoc
class __$DriverTransactionEntryCopyWithImpl<$Res>
    implements _$DriverTransactionEntryCopyWith<$Res> {
  __$DriverTransactionEntryCopyWithImpl(this._self, this._then);

  final _DriverTransactionEntry _self;
  final $Res Function(_DriverTransactionEntry) _then;

/// Create a copy of DriverTransactionEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? occurredAt = null,Object? amountMinor = null,Object? label = null,}) {
  return _then(_DriverTransactionEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
