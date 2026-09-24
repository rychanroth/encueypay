// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdminApplication {

 String get id; String get applicantName; String get requestedRole; String get status; DateTime get createdAt;
/// Create a copy of AdminApplication
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminApplicationCopyWith<AdminApplication> get copyWith => _$AdminApplicationCopyWithImpl<AdminApplication>(this as AdminApplication, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminApplication&&(identical(other.id, id) || other.id == id)&&(identical(other.applicantName, applicantName) || other.applicantName == applicantName)&&(identical(other.requestedRole, requestedRole) || other.requestedRole == requestedRole)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,applicantName,requestedRole,status,createdAt);

@override
String toString() {
  return 'AdminApplication(id: $id, applicantName: $applicantName, requestedRole: $requestedRole, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AdminApplicationCopyWith<$Res>  {
  factory $AdminApplicationCopyWith(AdminApplication value, $Res Function(AdminApplication) _then) = _$AdminApplicationCopyWithImpl;
@useResult
$Res call({
 String id, String applicantName, String requestedRole, String status, DateTime createdAt
});




}
/// @nodoc
class _$AdminApplicationCopyWithImpl<$Res>
    implements $AdminApplicationCopyWith<$Res> {
  _$AdminApplicationCopyWithImpl(this._self, this._then);

  final AdminApplication _self;
  final $Res Function(AdminApplication) _then;

/// Create a copy of AdminApplication
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? applicantName = null,Object? requestedRole = null,Object? status = null,Object? createdAt = null,}) {
  return _then(AdminApplication(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,applicantName: null == applicantName ? _self.applicantName : applicantName // ignore: cast_nullable_to_non_nullable
as String,requestedRole: null == requestedRole ? _self.requestedRole : requestedRole // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminApplication].
extension AdminApplicationPatterns on AdminApplication {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminApplication value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminApplication() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminApplication value)  $default,){
final _that = this;
switch (_that) {
case _AdminApplication():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminApplication value)?  $default,){
final _that = this;
switch (_that) {
case _AdminApplication() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String applicantName,  String requestedRole,  String status,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminApplication() when $default != null:
return $default(_that.id,_that.applicantName,_that.requestedRole,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String applicantName,  String requestedRole,  String status,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _AdminApplication():
return $default(_that.id,_that.applicantName,_that.requestedRole,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String applicantName,  String requestedRole,  String status,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AdminApplication() when $default != null:
return $default(_that.id,_that.applicantName,_that.requestedRole,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _AdminApplication implements AdminApplication {
  const _AdminApplication({required this.id, required this.applicantName, required this.requestedRole, required this.status, required this.createdAt});
  

@override final  String id;
@override final  String applicantName;
@override final  String requestedRole;
@override final  String status;
@override final  DateTime createdAt;

/// Create a copy of AdminApplication
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminApplicationCopyWith<_AdminApplication> get copyWith => __$AdminApplicationCopyWithImpl<_AdminApplication>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminApplication&&(identical(other.id, id) || other.id == id)&&(identical(other.applicantName, applicantName) || other.applicantName == applicantName)&&(identical(other.requestedRole, requestedRole) || other.requestedRole == requestedRole)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,applicantName,requestedRole,status,createdAt);

@override
String toString() {
  return 'AdminApplication(id: $id, applicantName: $applicantName, requestedRole: $requestedRole, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AdminApplicationCopyWith<$Res> implements $AdminApplicationCopyWith<$Res> {
  factory _$AdminApplicationCopyWith(_AdminApplication value, $Res Function(_AdminApplication) _then) = __$AdminApplicationCopyWithImpl;
@override @useResult
$Res call({
 String id, String applicantName, String requestedRole, String status, DateTime createdAt
});




}
/// @nodoc
class __$AdminApplicationCopyWithImpl<$Res>
    implements _$AdminApplicationCopyWith<$Res> {
  __$AdminApplicationCopyWithImpl(this._self, this._then);

  final _AdminApplication _self;
  final $Res Function(_AdminApplication) _then;

/// Create a copy of AdminApplication
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? applicantName = null,Object? requestedRole = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_AdminApplication(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,applicantName: null == applicantName ? _self.applicantName : applicantName // ignore: cast_nullable_to_non_nullable
as String,requestedRole: null == requestedRole ? _self.requestedRole : requestedRole // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$AdminCategory {

 String get id; String get name;
/// Create a copy of AdminCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminCategoryCopyWith<AdminCategory> get copyWith => _$AdminCategoryCopyWithImpl<AdminCategory>(this as AdminCategory, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'AdminCategory(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $AdminCategoryCopyWith<$Res>  {
  factory $AdminCategoryCopyWith(AdminCategory value, $Res Function(AdminCategory) _then) = _$AdminCategoryCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$AdminCategoryCopyWithImpl<$Res>
    implements $AdminCategoryCopyWith<$Res> {
  _$AdminCategoryCopyWithImpl(this._self, this._then);

  final AdminCategory _self;
  final $Res Function(AdminCategory) _then;

/// Create a copy of AdminCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(AdminCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminCategory].
extension AdminCategoryPatterns on AdminCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminCategory value)  $default,){
final _that = this;
switch (_that) {
case _AdminCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminCategory value)?  $default,){
final _that = this;
switch (_that) {
case _AdminCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminCategory() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name)  $default,) {final _that = this;
switch (_that) {
case _AdminCategory():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _AdminCategory() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _AdminCategory implements AdminCategory {
  const _AdminCategory({required this.id, required this.name});
  

@override final  String id;
@override final  String name;

/// Create a copy of AdminCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminCategoryCopyWith<_AdminCategory> get copyWith => __$AdminCategoryCopyWithImpl<_AdminCategory>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'AdminCategory(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$AdminCategoryCopyWith<$Res> implements $AdminCategoryCopyWith<$Res> {
  factory _$AdminCategoryCopyWith(_AdminCategory value, $Res Function(_AdminCategory) _then) = __$AdminCategoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$AdminCategoryCopyWithImpl<$Res>
    implements _$AdminCategoryCopyWith<$Res> {
  __$AdminCategoryCopyWithImpl(this._self, this._then);

  final _AdminCategory _self;
  final $Res Function(_AdminCategory) _then;

/// Create a copy of AdminCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_AdminCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$AuditEntry {

 String get id; String get action; String get targetType; DateTime get createdAt; String? get actor; String? get targetId;
/// Create a copy of AuditEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditEntryCopyWith<AuditEntry> get copyWith => _$AuditEntryCopyWithImpl<AuditEntry>(this as AuditEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.action, action) || other.action == action)&&(identical(other.targetType, targetType) || other.targetType == targetType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.actor, actor) || other.actor == actor)&&(identical(other.targetId, targetId) || other.targetId == targetId));
}


@override
int get hashCode => Object.hash(runtimeType,id,action,targetType,createdAt,actor,targetId);

@override
String toString() {
  return 'AuditEntry(id: $id, action: $action, targetType: $targetType, createdAt: $createdAt, actor: $actor, targetId: $targetId)';
}


}

/// @nodoc
abstract mixin class $AuditEntryCopyWith<$Res>  {
  factory $AuditEntryCopyWith(AuditEntry value, $Res Function(AuditEntry) _then) = _$AuditEntryCopyWithImpl;
@useResult
$Res call({
 String id, String action, String targetType, DateTime createdAt, String? actor, String? targetId
});




}
/// @nodoc
class _$AuditEntryCopyWithImpl<$Res>
    implements $AuditEntryCopyWith<$Res> {
  _$AuditEntryCopyWithImpl(this._self, this._then);

  final AuditEntry _self;
  final $Res Function(AuditEntry) _then;

/// Create a copy of AuditEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? action = null,Object? targetType = null,Object? createdAt = null,Object? actor = freezed,Object? targetId = freezed,}) {
  return _then(AuditEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,targetType: null == targetType ? _self.targetType : targetType // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,actor: freezed == actor ? _self.actor : actor // ignore: cast_nullable_to_non_nullable
as String?,targetId: freezed == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditEntry].
extension AuditEntryPatterns on AuditEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditEntry value)  $default,){
final _that = this;
switch (_that) {
case _AuditEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditEntry value)?  $default,){
final _that = this;
switch (_that) {
case _AuditEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String action,  String targetType,  DateTime createdAt,  String? actor,  String? targetId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditEntry() when $default != null:
return $default(_that.id,_that.action,_that.targetType,_that.createdAt,_that.actor,_that.targetId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String action,  String targetType,  DateTime createdAt,  String? actor,  String? targetId)  $default,) {final _that = this;
switch (_that) {
case _AuditEntry():
return $default(_that.id,_that.action,_that.targetType,_that.createdAt,_that.actor,_that.targetId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String action,  String targetType,  DateTime createdAt,  String? actor,  String? targetId)?  $default,) {final _that = this;
switch (_that) {
case _AuditEntry() when $default != null:
return $default(_that.id,_that.action,_that.targetType,_that.createdAt,_that.actor,_that.targetId);case _:
  return null;

}
}

}

/// @nodoc


class _AuditEntry implements AuditEntry {
  const _AuditEntry({required this.id, required this.action, required this.targetType, required this.createdAt, this.actor, this.targetId});
  

@override final  String id;
@override final  String action;
@override final  String targetType;
@override final  DateTime createdAt;
@override final  String? actor;
@override final  String? targetId;

/// Create a copy of AuditEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditEntryCopyWith<_AuditEntry> get copyWith => __$AuditEntryCopyWithImpl<_AuditEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.action, action) || other.action == action)&&(identical(other.targetType, targetType) || other.targetType == targetType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.actor, actor) || other.actor == actor)&&(identical(other.targetId, targetId) || other.targetId == targetId));
}


@override
int get hashCode => Object.hash(runtimeType,id,action,targetType,createdAt,actor,targetId);

@override
String toString() {
  return 'AuditEntry(id: $id, action: $action, targetType: $targetType, createdAt: $createdAt, actor: $actor, targetId: $targetId)';
}


}

/// @nodoc
abstract mixin class _$AuditEntryCopyWith<$Res> implements $AuditEntryCopyWith<$Res> {
  factory _$AuditEntryCopyWith(_AuditEntry value, $Res Function(_AuditEntry) _then) = __$AuditEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String action, String targetType, DateTime createdAt, String? actor, String? targetId
});




}
/// @nodoc
class __$AuditEntryCopyWithImpl<$Res>
    implements _$AuditEntryCopyWith<$Res> {
  __$AuditEntryCopyWithImpl(this._self, this._then);

  final _AuditEntry _self;
  final $Res Function(_AuditEntry) _then;

/// Create a copy of AuditEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? action = null,Object? targetType = null,Object? createdAt = null,Object? actor = freezed,Object? targetId = freezed,}) {
  return _then(_AuditEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,targetType: null == targetType ? _self.targetType : targetType // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,actor: freezed == actor ? _self.actor : actor // ignore: cast_nullable_to_non_nullable
as String?,targetId: freezed == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$PlatformAnalyticsReport {

 int get orderCount; int get gmvMinor; int get deliveryFeesMinor; int get activeBusinesses; int get activeProducts; int get pendingApplications;
/// Create a copy of PlatformAnalyticsReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlatformAnalyticsReportCopyWith<PlatformAnalyticsReport> get copyWith => _$PlatformAnalyticsReportCopyWithImpl<PlatformAnalyticsReport>(this as PlatformAnalyticsReport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlatformAnalyticsReport&&(identical(other.orderCount, orderCount) || other.orderCount == orderCount)&&(identical(other.gmvMinor, gmvMinor) || other.gmvMinor == gmvMinor)&&(identical(other.deliveryFeesMinor, deliveryFeesMinor) || other.deliveryFeesMinor == deliveryFeesMinor)&&(identical(other.activeBusinesses, activeBusinesses) || other.activeBusinesses == activeBusinesses)&&(identical(other.activeProducts, activeProducts) || other.activeProducts == activeProducts)&&(identical(other.pendingApplications, pendingApplications) || other.pendingApplications == pendingApplications));
}


@override
int get hashCode => Object.hash(runtimeType,orderCount,gmvMinor,deliveryFeesMinor,activeBusinesses,activeProducts,pendingApplications);

@override
String toString() {
  return 'PlatformAnalyticsReport(orderCount: $orderCount, gmvMinor: $gmvMinor, deliveryFeesMinor: $deliveryFeesMinor, activeBusinesses: $activeBusinesses, activeProducts: $activeProducts, pendingApplications: $pendingApplications)';
}


}

/// @nodoc
abstract mixin class $PlatformAnalyticsReportCopyWith<$Res>  {
  factory $PlatformAnalyticsReportCopyWith(PlatformAnalyticsReport value, $Res Function(PlatformAnalyticsReport) _then) = _$PlatformAnalyticsReportCopyWithImpl;
@useResult
$Res call({
 int orderCount, int gmvMinor, int deliveryFeesMinor, int activeBusinesses, int activeProducts, int pendingApplications
});




}
/// @nodoc
class _$PlatformAnalyticsReportCopyWithImpl<$Res>
    implements $PlatformAnalyticsReportCopyWith<$Res> {
  _$PlatformAnalyticsReportCopyWithImpl(this._self, this._then);

  final PlatformAnalyticsReport _self;
  final $Res Function(PlatformAnalyticsReport) _then;

/// Create a copy of PlatformAnalyticsReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderCount = null,Object? gmvMinor = null,Object? deliveryFeesMinor = null,Object? activeBusinesses = null,Object? activeProducts = null,Object? pendingApplications = null,}) {
  return _then(PlatformAnalyticsReport(
orderCount: null == orderCount ? _self.orderCount : orderCount // ignore: cast_nullable_to_non_nullable
as int,gmvMinor: null == gmvMinor ? _self.gmvMinor : gmvMinor // ignore: cast_nullable_to_non_nullable
as int,deliveryFeesMinor: null == deliveryFeesMinor ? _self.deliveryFeesMinor : deliveryFeesMinor // ignore: cast_nullable_to_non_nullable
as int,activeBusinesses: null == activeBusinesses ? _self.activeBusinesses : activeBusinesses // ignore: cast_nullable_to_non_nullable
as int,activeProducts: null == activeProducts ? _self.activeProducts : activeProducts // ignore: cast_nullable_to_non_nullable
as int,pendingApplications: null == pendingApplications ? _self.pendingApplications : pendingApplications // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PlatformAnalyticsReport].
extension PlatformAnalyticsReportPatterns on PlatformAnalyticsReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlatformAnalyticsReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlatformAnalyticsReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlatformAnalyticsReport value)  $default,){
final _that = this;
switch (_that) {
case _PlatformAnalyticsReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlatformAnalyticsReport value)?  $default,){
final _that = this;
switch (_that) {
case _PlatformAnalyticsReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int orderCount,  int gmvMinor,  int deliveryFeesMinor,  int activeBusinesses,  int activeProducts,  int pendingApplications)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlatformAnalyticsReport() when $default != null:
return $default(_that.orderCount,_that.gmvMinor,_that.deliveryFeesMinor,_that.activeBusinesses,_that.activeProducts,_that.pendingApplications);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int orderCount,  int gmvMinor,  int deliveryFeesMinor,  int activeBusinesses,  int activeProducts,  int pendingApplications)  $default,) {final _that = this;
switch (_that) {
case _PlatformAnalyticsReport():
return $default(_that.orderCount,_that.gmvMinor,_that.deliveryFeesMinor,_that.activeBusinesses,_that.activeProducts,_that.pendingApplications);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int orderCount,  int gmvMinor,  int deliveryFeesMinor,  int activeBusinesses,  int activeProducts,  int pendingApplications)?  $default,) {final _that = this;
switch (_that) {
case _PlatformAnalyticsReport() when $default != null:
return $default(_that.orderCount,_that.gmvMinor,_that.deliveryFeesMinor,_that.activeBusinesses,_that.activeProducts,_that.pendingApplications);case _:
  return null;

}
}

}

/// @nodoc


class _PlatformAnalyticsReport implements PlatformAnalyticsReport {
  const _PlatformAnalyticsReport({required this.orderCount, required this.gmvMinor, required this.deliveryFeesMinor, required this.activeBusinesses, required this.activeProducts, required this.pendingApplications});
  

@override final  int orderCount;
@override final  int gmvMinor;
@override final  int deliveryFeesMinor;
@override final  int activeBusinesses;
@override final  int activeProducts;
@override final  int pendingApplications;

/// Create a copy of PlatformAnalyticsReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlatformAnalyticsReportCopyWith<_PlatformAnalyticsReport> get copyWith => __$PlatformAnalyticsReportCopyWithImpl<_PlatformAnalyticsReport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlatformAnalyticsReport&&(identical(other.orderCount, orderCount) || other.orderCount == orderCount)&&(identical(other.gmvMinor, gmvMinor) || other.gmvMinor == gmvMinor)&&(identical(other.deliveryFeesMinor, deliveryFeesMinor) || other.deliveryFeesMinor == deliveryFeesMinor)&&(identical(other.activeBusinesses, activeBusinesses) || other.activeBusinesses == activeBusinesses)&&(identical(other.activeProducts, activeProducts) || other.activeProducts == activeProducts)&&(identical(other.pendingApplications, pendingApplications) || other.pendingApplications == pendingApplications));
}


@override
int get hashCode => Object.hash(runtimeType,orderCount,gmvMinor,deliveryFeesMinor,activeBusinesses,activeProducts,pendingApplications);

@override
String toString() {
  return 'PlatformAnalyticsReport(orderCount: $orderCount, gmvMinor: $gmvMinor, deliveryFeesMinor: $deliveryFeesMinor, activeBusinesses: $activeBusinesses, activeProducts: $activeProducts, pendingApplications: $pendingApplications)';
}


}

/// @nodoc
abstract mixin class _$PlatformAnalyticsReportCopyWith<$Res> implements $PlatformAnalyticsReportCopyWith<$Res> {
  factory _$PlatformAnalyticsReportCopyWith(_PlatformAnalyticsReport value, $Res Function(_PlatformAnalyticsReport) _then) = __$PlatformAnalyticsReportCopyWithImpl;
@override @useResult
$Res call({
 int orderCount, int gmvMinor, int deliveryFeesMinor, int activeBusinesses, int activeProducts, int pendingApplications
});




}
/// @nodoc
class __$PlatformAnalyticsReportCopyWithImpl<$Res>
    implements _$PlatformAnalyticsReportCopyWith<$Res> {
  __$PlatformAnalyticsReportCopyWithImpl(this._self, this._then);

  final _PlatformAnalyticsReport _self;
  final $Res Function(_PlatformAnalyticsReport) _then;

/// Create a copy of PlatformAnalyticsReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderCount = null,Object? gmvMinor = null,Object? deliveryFeesMinor = null,Object? activeBusinesses = null,Object? activeProducts = null,Object? pendingApplications = null,}) {
  return _then(_PlatformAnalyticsReport(
orderCount: null == orderCount ? _self.orderCount : orderCount // ignore: cast_nullable_to_non_nullable
as int,gmvMinor: null == gmvMinor ? _self.gmvMinor : gmvMinor // ignore: cast_nullable_to_non_nullable
as int,deliveryFeesMinor: null == deliveryFeesMinor ? _self.deliveryFeesMinor : deliveryFeesMinor // ignore: cast_nullable_to_non_nullable
as int,activeBusinesses: null == activeBusinesses ? _self.activeBusinesses : activeBusinesses // ignore: cast_nullable_to_non_nullable
as int,activeProducts: null == activeProducts ? _self.activeProducts : activeProducts // ignore: cast_nullable_to_non_nullable
as int,pendingApplications: null == pendingApplications ? _self.pendingApplications : pendingApplications // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$PlatformSettings {

 int get deliveryFeeMinor; int get platformCommissionPercent; int get driverCommissionPercent; String get paymentAccount;
/// Create a copy of PlatformSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlatformSettingsCopyWith<PlatformSettings> get copyWith => _$PlatformSettingsCopyWithImpl<PlatformSettings>(this as PlatformSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlatformSettings&&(identical(other.deliveryFeeMinor, deliveryFeeMinor) || other.deliveryFeeMinor == deliveryFeeMinor)&&(identical(other.platformCommissionPercent, platformCommissionPercent) || other.platformCommissionPercent == platformCommissionPercent)&&(identical(other.driverCommissionPercent, driverCommissionPercent) || other.driverCommissionPercent == driverCommissionPercent)&&(identical(other.paymentAccount, paymentAccount) || other.paymentAccount == paymentAccount));
}


@override
int get hashCode => Object.hash(runtimeType,deliveryFeeMinor,platformCommissionPercent,driverCommissionPercent,paymentAccount);

@override
String toString() {
  return 'PlatformSettings(deliveryFeeMinor: $deliveryFeeMinor, platformCommissionPercent: $platformCommissionPercent, driverCommissionPercent: $driverCommissionPercent, paymentAccount: $paymentAccount)';
}


}

/// @nodoc
abstract mixin class $PlatformSettingsCopyWith<$Res>  {
  factory $PlatformSettingsCopyWith(PlatformSettings value, $Res Function(PlatformSettings) _then) = _$PlatformSettingsCopyWithImpl;
@useResult
$Res call({
 int deliveryFeeMinor, int platformCommissionPercent, int driverCommissionPercent, String paymentAccount
});




}
/// @nodoc
class _$PlatformSettingsCopyWithImpl<$Res>
    implements $PlatformSettingsCopyWith<$Res> {
  _$PlatformSettingsCopyWithImpl(this._self, this._then);

  final PlatformSettings _self;
  final $Res Function(PlatformSettings) _then;

/// Create a copy of PlatformSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deliveryFeeMinor = null,Object? platformCommissionPercent = null,Object? driverCommissionPercent = null,Object? paymentAccount = null,}) {
  return _then(PlatformSettings(
deliveryFeeMinor: null == deliveryFeeMinor ? _self.deliveryFeeMinor : deliveryFeeMinor // ignore: cast_nullable_to_non_nullable
as int,platformCommissionPercent: null == platformCommissionPercent ? _self.platformCommissionPercent : platformCommissionPercent // ignore: cast_nullable_to_non_nullable
as int,driverCommissionPercent: null == driverCommissionPercent ? _self.driverCommissionPercent : driverCommissionPercent // ignore: cast_nullable_to_non_nullable
as int,paymentAccount: null == paymentAccount ? _self.paymentAccount : paymentAccount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PlatformSettings].
extension PlatformSettingsPatterns on PlatformSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlatformSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlatformSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlatformSettings value)  $default,){
final _that = this;
switch (_that) {
case _PlatformSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlatformSettings value)?  $default,){
final _that = this;
switch (_that) {
case _PlatformSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int deliveryFeeMinor,  int platformCommissionPercent,  int driverCommissionPercent,  String paymentAccount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlatformSettings() when $default != null:
return $default(_that.deliveryFeeMinor,_that.platformCommissionPercent,_that.driverCommissionPercent,_that.paymentAccount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int deliveryFeeMinor,  int platformCommissionPercent,  int driverCommissionPercent,  String paymentAccount)  $default,) {final _that = this;
switch (_that) {
case _PlatformSettings():
return $default(_that.deliveryFeeMinor,_that.platformCommissionPercent,_that.driverCommissionPercent,_that.paymentAccount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int deliveryFeeMinor,  int platformCommissionPercent,  int driverCommissionPercent,  String paymentAccount)?  $default,) {final _that = this;
switch (_that) {
case _PlatformSettings() when $default != null:
return $default(_that.deliveryFeeMinor,_that.platformCommissionPercent,_that.driverCommissionPercent,_that.paymentAccount);case _:
  return null;

}
}

}

/// @nodoc


class _PlatformSettings implements PlatformSettings {
  const _PlatformSettings({required this.deliveryFeeMinor, required this.platformCommissionPercent, required this.driverCommissionPercent, required this.paymentAccount});
  

@override final  int deliveryFeeMinor;
@override final  int platformCommissionPercent;
@override final  int driverCommissionPercent;
@override final  String paymentAccount;

/// Create a copy of PlatformSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlatformSettingsCopyWith<_PlatformSettings> get copyWith => __$PlatformSettingsCopyWithImpl<_PlatformSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlatformSettings&&(identical(other.deliveryFeeMinor, deliveryFeeMinor) || other.deliveryFeeMinor == deliveryFeeMinor)&&(identical(other.platformCommissionPercent, platformCommissionPercent) || other.platformCommissionPercent == platformCommissionPercent)&&(identical(other.driverCommissionPercent, driverCommissionPercent) || other.driverCommissionPercent == driverCommissionPercent)&&(identical(other.paymentAccount, paymentAccount) || other.paymentAccount == paymentAccount));
}


@override
int get hashCode => Object.hash(runtimeType,deliveryFeeMinor,platformCommissionPercent,driverCommissionPercent,paymentAccount);

@override
String toString() {
  return 'PlatformSettings(deliveryFeeMinor: $deliveryFeeMinor, platformCommissionPercent: $platformCommissionPercent, driverCommissionPercent: $driverCommissionPercent, paymentAccount: $paymentAccount)';
}


}

/// @nodoc
abstract mixin class _$PlatformSettingsCopyWith<$Res> implements $PlatformSettingsCopyWith<$Res> {
  factory _$PlatformSettingsCopyWith(_PlatformSettings value, $Res Function(_PlatformSettings) _then) = __$PlatformSettingsCopyWithImpl;
@override @useResult
$Res call({
 int deliveryFeeMinor, int platformCommissionPercent, int driverCommissionPercent, String paymentAccount
});




}
/// @nodoc
class __$PlatformSettingsCopyWithImpl<$Res>
    implements _$PlatformSettingsCopyWith<$Res> {
  __$PlatformSettingsCopyWithImpl(this._self, this._then);

  final _PlatformSettings _self;
  final $Res Function(_PlatformSettings) _then;

/// Create a copy of PlatformSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deliveryFeeMinor = null,Object? platformCommissionPercent = null,Object? driverCommissionPercent = null,Object? paymentAccount = null,}) {
  return _then(_PlatformSettings(
deliveryFeeMinor: null == deliveryFeeMinor ? _self.deliveryFeeMinor : deliveryFeeMinor // ignore: cast_nullable_to_non_nullable
as int,platformCommissionPercent: null == platformCommissionPercent ? _self.platformCommissionPercent : platformCommissionPercent // ignore: cast_nullable_to_non_nullable
as int,driverCommissionPercent: null == driverCommissionPercent ? _self.driverCommissionPercent : driverCommissionPercent // ignore: cast_nullable_to_non_nullable
as int,paymentAccount: null == paymentAccount ? _self.paymentAccount : paymentAccount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
