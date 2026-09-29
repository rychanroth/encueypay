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
mixin _$BusinessTransactionEntry {

 String get id; DateTime get occurredAt; int get amountMinor; String get label;
/// Create a copy of BusinessTransactionEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BusinessTransactionEntryCopyWith<BusinessTransactionEntry> get copyWith => _$BusinessTransactionEntryCopyWithImpl<BusinessTransactionEntry>(this as BusinessTransactionEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BusinessTransactionEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.label, label) || other.label == label));
}


@override
int get hashCode => Object.hash(runtimeType,id,occurredAt,amountMinor,label);

@override
String toString() {
  return 'BusinessTransactionEntry(id: $id, occurredAt: $occurredAt, amountMinor: $amountMinor, label: $label)';
}


}

/// @nodoc
abstract mixin class $BusinessTransactionEntryCopyWith<$Res>  {
  factory $BusinessTransactionEntryCopyWith(BusinessTransactionEntry value, $Res Function(BusinessTransactionEntry) _then) = _$BusinessTransactionEntryCopyWithImpl;
@useResult
$Res call({
 String id, DateTime occurredAt, int amountMinor, String label
});




}
/// @nodoc
class _$BusinessTransactionEntryCopyWithImpl<$Res>
    implements $BusinessTransactionEntryCopyWith<$Res> {
  _$BusinessTransactionEntryCopyWithImpl(this._self, this._then);

  final BusinessTransactionEntry _self;
  final $Res Function(BusinessTransactionEntry) _then;

/// Create a copy of BusinessTransactionEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? occurredAt = null,Object? amountMinor = null,Object? label = null,}) {
  return _then(BusinessTransactionEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BusinessTransactionEntry].
extension BusinessTransactionEntryPatterns on BusinessTransactionEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BusinessTransactionEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BusinessTransactionEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BusinessTransactionEntry value)  $default,){
final _that = this;
switch (_that) {
case _BusinessTransactionEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BusinessTransactionEntry value)?  $default,){
final _that = this;
switch (_that) {
case _BusinessTransactionEntry() when $default != null:
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
case _BusinessTransactionEntry() when $default != null:
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
case _BusinessTransactionEntry():
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
case _BusinessTransactionEntry() when $default != null:
return $default(_that.id,_that.occurredAt,_that.amountMinor,_that.label);case _:
  return null;

}
}

}

/// @nodoc


class _BusinessTransactionEntry implements BusinessTransactionEntry {
  const _BusinessTransactionEntry({required this.id, required this.occurredAt, required this.amountMinor, required this.label});
  

@override final  String id;
@override final  DateTime occurredAt;
@override final  int amountMinor;
@override final  String label;

/// Create a copy of BusinessTransactionEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BusinessTransactionEntryCopyWith<_BusinessTransactionEntry> get copyWith => __$BusinessTransactionEntryCopyWithImpl<_BusinessTransactionEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BusinessTransactionEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.label, label) || other.label == label));
}


@override
int get hashCode => Object.hash(runtimeType,id,occurredAt,amountMinor,label);

@override
String toString() {
  return 'BusinessTransactionEntry(id: $id, occurredAt: $occurredAt, amountMinor: $amountMinor, label: $label)';
}


}

/// @nodoc
abstract mixin class _$BusinessTransactionEntryCopyWith<$Res> implements $BusinessTransactionEntryCopyWith<$Res> {
  factory _$BusinessTransactionEntryCopyWith(_BusinessTransactionEntry value, $Res Function(_BusinessTransactionEntry) _then) = __$BusinessTransactionEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime occurredAt, int amountMinor, String label
});




}
/// @nodoc
class __$BusinessTransactionEntryCopyWithImpl<$Res>
    implements _$BusinessTransactionEntryCopyWith<$Res> {
  __$BusinessTransactionEntryCopyWithImpl(this._self, this._then);

  final _BusinessTransactionEntry _self;
  final $Res Function(_BusinessTransactionEntry) _then;

/// Create a copy of BusinessTransactionEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? occurredAt = null,Object? amountMinor = null,Object? label = null,}) {
  return _then(_BusinessTransactionEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
