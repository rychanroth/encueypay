// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'role_application.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RoleApplication {

 String get id; String get requestedRole; RoleApplicationStatus get status; DateTime get createdAt; String? get decisionReason;
/// Create a copy of RoleApplication
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoleApplicationCopyWith<RoleApplication> get copyWith => _$RoleApplicationCopyWithImpl<RoleApplication>(this as RoleApplication, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoleApplication&&(identical(other.id, id) || other.id == id)&&(identical(other.requestedRole, requestedRole) || other.requestedRole == requestedRole)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.decisionReason, decisionReason) || other.decisionReason == decisionReason));
}


@override
int get hashCode => Object.hash(runtimeType,id,requestedRole,status,createdAt,decisionReason);

@override
String toString() {
  return 'RoleApplication(id: $id, requestedRole: $requestedRole, status: $status, createdAt: $createdAt, decisionReason: $decisionReason)';
}


}

/// @nodoc
abstract mixin class $RoleApplicationCopyWith<$Res>  {
  factory $RoleApplicationCopyWith(RoleApplication value, $Res Function(RoleApplication) _then) = _$RoleApplicationCopyWithImpl;
@useResult
$Res call({
 String id, String requestedRole, RoleApplicationStatus status, DateTime createdAt, String? decisionReason
});




}
/// @nodoc
class _$RoleApplicationCopyWithImpl<$Res>
    implements $RoleApplicationCopyWith<$Res> {
  _$RoleApplicationCopyWithImpl(this._self, this._then);

  final RoleApplication _self;
  final $Res Function(RoleApplication) _then;

/// Create a copy of RoleApplication
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? requestedRole = null,Object? status = null,Object? createdAt = null,Object? decisionReason = freezed,}) {
  return _then(RoleApplication(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requestedRole: null == requestedRole ? _self.requestedRole : requestedRole // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RoleApplicationStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,decisionReason: freezed == decisionReason ? _self.decisionReason : decisionReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RoleApplication].
extension RoleApplicationPatterns on RoleApplication {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoleApplication value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoleApplication() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoleApplication value)  $default,){
final _that = this;
switch (_that) {
case _RoleApplication():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoleApplication value)?  $default,){
final _that = this;
switch (_that) {
case _RoleApplication() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String requestedRole,  RoleApplicationStatus status,  DateTime createdAt,  String? decisionReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoleApplication() when $default != null:
return $default(_that.id,_that.requestedRole,_that.status,_that.createdAt,_that.decisionReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String requestedRole,  RoleApplicationStatus status,  DateTime createdAt,  String? decisionReason)  $default,) {final _that = this;
switch (_that) {
case _RoleApplication():
return $default(_that.id,_that.requestedRole,_that.status,_that.createdAt,_that.decisionReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String requestedRole,  RoleApplicationStatus status,  DateTime createdAt,  String? decisionReason)?  $default,) {final _that = this;
switch (_that) {
case _RoleApplication() when $default != null:
return $default(_that.id,_that.requestedRole,_that.status,_that.createdAt,_that.decisionReason);case _:
  return null;

}
}

}

/// @nodoc


class _RoleApplication implements RoleApplication {
  const _RoleApplication({required this.id, required this.requestedRole, required this.status, required this.createdAt, this.decisionReason});
  

@override final  String id;
@override final  String requestedRole;
@override final  RoleApplicationStatus status;
@override final  DateTime createdAt;
@override final  String? decisionReason;

/// Create a copy of RoleApplication
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoleApplicationCopyWith<_RoleApplication> get copyWith => __$RoleApplicationCopyWithImpl<_RoleApplication>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoleApplication&&(identical(other.id, id) || other.id == id)&&(identical(other.requestedRole, requestedRole) || other.requestedRole == requestedRole)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.decisionReason, decisionReason) || other.decisionReason == decisionReason));
}


@override
int get hashCode => Object.hash(runtimeType,id,requestedRole,status,createdAt,decisionReason);

@override
String toString() {
  return 'RoleApplication(id: $id, requestedRole: $requestedRole, status: $status, createdAt: $createdAt, decisionReason: $decisionReason)';
}


}

/// @nodoc
abstract mixin class _$RoleApplicationCopyWith<$Res> implements $RoleApplicationCopyWith<$Res> {
  factory _$RoleApplicationCopyWith(_RoleApplication value, $Res Function(_RoleApplication) _then) = __$RoleApplicationCopyWithImpl;
@override @useResult
$Res call({
 String id, String requestedRole, RoleApplicationStatus status, DateTime createdAt, String? decisionReason
});




}
/// @nodoc
class __$RoleApplicationCopyWithImpl<$Res>
    implements _$RoleApplicationCopyWith<$Res> {
  __$RoleApplicationCopyWithImpl(this._self, this._then);

  final _RoleApplication _self;
  final $Res Function(_RoleApplication) _then;

/// Create a copy of RoleApplication
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? requestedRole = null,Object? status = null,Object? createdAt = null,Object? decisionReason = freezed,}) {
  return _then(_RoleApplication(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requestedRole: null == requestedRole ? _self.requestedRole : requestedRole // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RoleApplicationStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,decisionReason: freezed == decisionReason ? _self.decisionReason : decisionReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
