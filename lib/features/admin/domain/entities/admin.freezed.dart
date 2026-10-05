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

 String get id; String get name; String? get imageUrl;
/// Create a copy of AdminCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminCategoryCopyWith<AdminCategory> get copyWith => _$AdminCategoryCopyWithImpl<AdminCategory>(this as AdminCategory, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,imageUrl);

@override
String toString() {
  return 'AdminCategory(id: $id, name: $name, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $AdminCategoryCopyWith<$Res>  {
  factory $AdminCategoryCopyWith(AdminCategory value, $Res Function(AdminCategory) _then) = _$AdminCategoryCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? imageUrl
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? imageUrl = freezed,}) {
  return _then(AdminCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminCategory() when $default != null:
return $default(_that.id,_that.name,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _AdminCategory():
return $default(_that.id,_that.name,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _AdminCategory() when $default != null:
return $default(_that.id,_that.name,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc


class _AdminCategory implements AdminCategory {
  const _AdminCategory({required this.id, required this.name, this.imageUrl});
  

@override final  String id;
@override final  String name;
@override final  String? imageUrl;

/// Create a copy of AdminCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminCategoryCopyWith<_AdminCategory> get copyWith => __$AdminCategoryCopyWithImpl<_AdminCategory>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,imageUrl);

@override
String toString() {
  return 'AdminCategory(id: $id, name: $name, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$AdminCategoryCopyWith<$Res> implements $AdminCategoryCopyWith<$Res> {
  factory _$AdminCategoryCopyWith(_AdminCategory value, $Res Function(_AdminCategory) _then) = __$AdminCategoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? imageUrl
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? imageUrl = freezed,}) {
  return _then(_AdminCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$AdminBrand {

 String get id; String get name; String get description; String? get imageUrl; AdminCatalogStatus get status;
/// Create a copy of AdminBrand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminBrandCopyWith<AdminBrand> get copyWith => _$AdminBrandCopyWithImpl<AdminBrand>(this as AdminBrand, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminBrand&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,imageUrl,status);

@override
String toString() {
  return 'AdminBrand(id: $id, name: $name, description: $description, imageUrl: $imageUrl, status: $status)';
}


}

/// @nodoc
abstract mixin class $AdminBrandCopyWith<$Res>  {
  factory $AdminBrandCopyWith(AdminBrand value, $Res Function(AdminBrand) _then) = _$AdminBrandCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, String? imageUrl, AdminCatalogStatus status
});




}
/// @nodoc
class _$AdminBrandCopyWithImpl<$Res>
    implements $AdminBrandCopyWith<$Res> {
  _$AdminBrandCopyWithImpl(this._self, this._then);

  final AdminBrand _self;
  final $Res Function(AdminBrand) _then;

/// Create a copy of AdminBrand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? imageUrl = freezed,Object? status = null,}) {
  return _then(AdminBrand(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AdminCatalogStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminBrand].
extension AdminBrandPatterns on AdminBrand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminBrand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminBrand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminBrand value)  $default,){
final _that = this;
switch (_that) {
case _AdminBrand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminBrand value)?  $default,){
final _that = this;
switch (_that) {
case _AdminBrand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String? imageUrl,  AdminCatalogStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminBrand() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.imageUrl,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String? imageUrl,  AdminCatalogStatus status)  $default,) {final _that = this;
switch (_that) {
case _AdminBrand():
return $default(_that.id,_that.name,_that.description,_that.imageUrl,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  String? imageUrl,  AdminCatalogStatus status)?  $default,) {final _that = this;
switch (_that) {
case _AdminBrand() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.imageUrl,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _AdminBrand implements AdminBrand {
  const _AdminBrand({required this.id, required this.name, this.description = '', this.imageUrl, this.status = AdminCatalogStatus.active});
  

@override final  String id;
@override final  String name;
@override@JsonKey() final  String description;
@override final  String? imageUrl;
@override@JsonKey() final  AdminCatalogStatus status;

/// Create a copy of AdminBrand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminBrandCopyWith<_AdminBrand> get copyWith => __$AdminBrandCopyWithImpl<_AdminBrand>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminBrand&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,imageUrl,status);

@override
String toString() {
  return 'AdminBrand(id: $id, name: $name, description: $description, imageUrl: $imageUrl, status: $status)';
}


}

/// @nodoc
abstract mixin class _$AdminBrandCopyWith<$Res> implements $AdminBrandCopyWith<$Res> {
  factory _$AdminBrandCopyWith(_AdminBrand value, $Res Function(_AdminBrand) _then) = __$AdminBrandCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, String? imageUrl, AdminCatalogStatus status
});




}
/// @nodoc
class __$AdminBrandCopyWithImpl<$Res>
    implements _$AdminBrandCopyWith<$Res> {
  __$AdminBrandCopyWithImpl(this._self, this._then);

  final _AdminBrand _self;
  final $Res Function(_AdminBrand) _then;

/// Create a copy of AdminBrand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? imageUrl = freezed,Object? status = null,}) {
  return _then(_AdminBrand(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AdminCatalogStatus,
  ));
}


}

/// @nodoc
mixin _$AdminProductSummary {

 String get id; String get name; String get categoryId; String get businessId; String get categoryName; String get businessName; int get basePriceMinor; int get variantCount; int get stock; String get description; AdminCatalogStatus get status; String? get brandId; String? get brandName; List<AdminProductImageRef> get images;
/// Create a copy of AdminProductSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminProductSummaryCopyWith<AdminProductSummary> get copyWith => _$AdminProductSummaryCopyWithImpl<AdminProductSummary>(this as AdminProductSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminProductSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.businessName, businessName) || other.businessName == businessName)&&(identical(other.basePriceMinor, basePriceMinor) || other.basePriceMinor == basePriceMinor)&&(identical(other.variantCount, variantCount) || other.variantCount == variantCount)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.brandId, brandId) || other.brandId == brandId)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&const DeepCollectionEquality().equals(other.images, images));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,categoryId,businessId,categoryName,businessName,basePriceMinor,variantCount,stock,description,status,brandId,brandName,const DeepCollectionEquality().hash(images));

@override
String toString() {
  return 'AdminProductSummary(id: $id, name: $name, categoryId: $categoryId, businessId: $businessId, categoryName: $categoryName, businessName: $businessName, basePriceMinor: $basePriceMinor, variantCount: $variantCount, stock: $stock, description: $description, status: $status, brandId: $brandId, brandName: $brandName, images: $images)';
}


}

/// @nodoc
abstract mixin class $AdminProductSummaryCopyWith<$Res>  {
  factory $AdminProductSummaryCopyWith(AdminProductSummary value, $Res Function(AdminProductSummary) _then) = _$AdminProductSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String name, String categoryId, String businessId, String categoryName, String businessName, int basePriceMinor, int variantCount, int stock, String description, AdminCatalogStatus status, String? brandId, String? brandName, List<AdminProductImageRef> images
});




}
/// @nodoc
class _$AdminProductSummaryCopyWithImpl<$Res>
    implements $AdminProductSummaryCopyWith<$Res> {
  _$AdminProductSummaryCopyWithImpl(this._self, this._then);

  final AdminProductSummary _self;
  final $Res Function(AdminProductSummary) _then;

/// Create a copy of AdminProductSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? categoryId = null,Object? businessId = null,Object? categoryName = null,Object? businessName = null,Object? basePriceMinor = null,Object? variantCount = null,Object? stock = null,Object? description = null,Object? status = null,Object? brandId = freezed,Object? brandName = freezed,Object? images = null,}) {
  return _then(AdminProductSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,businessName: null == businessName ? _self.businessName : businessName // ignore: cast_nullable_to_non_nullable
as String,basePriceMinor: null == basePriceMinor ? _self.basePriceMinor : basePriceMinor // ignore: cast_nullable_to_non_nullable
as int,variantCount: null == variantCount ? _self.variantCount : variantCount // ignore: cast_nullable_to_non_nullable
as int,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AdminCatalogStatus,brandId: freezed == brandId ? _self.brandId : brandId // ignore: cast_nullable_to_non_nullable
as String?,brandName: freezed == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String?,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<AdminProductImageRef>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminProductSummary].
extension AdminProductSummaryPatterns on AdminProductSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminProductSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminProductSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminProductSummary value)  $default,){
final _that = this;
switch (_that) {
case _AdminProductSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminProductSummary value)?  $default,){
final _that = this;
switch (_that) {
case _AdminProductSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String categoryId,  String businessId,  String categoryName,  String businessName,  int basePriceMinor,  int variantCount,  int stock,  String description,  AdminCatalogStatus status,  String? brandId,  String? brandName,  List<AdminProductImageRef> images)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminProductSummary() when $default != null:
return $default(_that.id,_that.name,_that.categoryId,_that.businessId,_that.categoryName,_that.businessName,_that.basePriceMinor,_that.variantCount,_that.stock,_that.description,_that.status,_that.brandId,_that.brandName,_that.images);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String categoryId,  String businessId,  String categoryName,  String businessName,  int basePriceMinor,  int variantCount,  int stock,  String description,  AdminCatalogStatus status,  String? brandId,  String? brandName,  List<AdminProductImageRef> images)  $default,) {final _that = this;
switch (_that) {
case _AdminProductSummary():
return $default(_that.id,_that.name,_that.categoryId,_that.businessId,_that.categoryName,_that.businessName,_that.basePriceMinor,_that.variantCount,_that.stock,_that.description,_that.status,_that.brandId,_that.brandName,_that.images);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String categoryId,  String businessId,  String categoryName,  String businessName,  int basePriceMinor,  int variantCount,  int stock,  String description,  AdminCatalogStatus status,  String? brandId,  String? brandName,  List<AdminProductImageRef> images)?  $default,) {final _that = this;
switch (_that) {
case _AdminProductSummary() when $default != null:
return $default(_that.id,_that.name,_that.categoryId,_that.businessId,_that.categoryName,_that.businessName,_that.basePriceMinor,_that.variantCount,_that.stock,_that.description,_that.status,_that.brandId,_that.brandName,_that.images);case _:
  return null;

}
}

}

/// @nodoc


class _AdminProductSummary implements AdminProductSummary {
  const _AdminProductSummary({required this.id, required this.name, required this.categoryId, required this.businessId, required this.categoryName, required this.businessName, required this.basePriceMinor, required this.variantCount, required this.stock, this.description = '', this.status = AdminCatalogStatus.active, this.brandId, this.brandName,  List<AdminProductImageRef> images = const []}): _images = images;
  

@override final  String id;
@override final  String name;
@override final  String categoryId;
@override final  String businessId;
@override final  String categoryName;
@override final  String businessName;
@override final  int basePriceMinor;
@override final  int variantCount;
@override final  int stock;
@override@JsonKey() final  String description;
@override@JsonKey() final  AdminCatalogStatus status;
@override final  String? brandId;
@override final  String? brandName;
 final  List<AdminProductImageRef> _images;
@override@JsonKey() List<AdminProductImageRef> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}


/// Create a copy of AdminProductSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminProductSummaryCopyWith<_AdminProductSummary> get copyWith => __$AdminProductSummaryCopyWithImpl<_AdminProductSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminProductSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.businessName, businessName) || other.businessName == businessName)&&(identical(other.basePriceMinor, basePriceMinor) || other.basePriceMinor == basePriceMinor)&&(identical(other.variantCount, variantCount) || other.variantCount == variantCount)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.brandId, brandId) || other.brandId == brandId)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&const DeepCollectionEquality().equals(other._images, _images));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,categoryId,businessId,categoryName,businessName,basePriceMinor,variantCount,stock,description,status,brandId,brandName,const DeepCollectionEquality().hash(_images));

@override
String toString() {
  return 'AdminProductSummary(id: $id, name: $name, categoryId: $categoryId, businessId: $businessId, categoryName: $categoryName, businessName: $businessName, basePriceMinor: $basePriceMinor, variantCount: $variantCount, stock: $stock, description: $description, status: $status, brandId: $brandId, brandName: $brandName, images: $images)';
}


}

/// @nodoc
abstract mixin class _$AdminProductSummaryCopyWith<$Res> implements $AdminProductSummaryCopyWith<$Res> {
  factory _$AdminProductSummaryCopyWith(_AdminProductSummary value, $Res Function(_AdminProductSummary) _then) = __$AdminProductSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String categoryId, String businessId, String categoryName, String businessName, int basePriceMinor, int variantCount, int stock, String description, AdminCatalogStatus status, String? brandId, String? brandName, List<AdminProductImageRef> images
});




}
/// @nodoc
class __$AdminProductSummaryCopyWithImpl<$Res>
    implements _$AdminProductSummaryCopyWith<$Res> {
  __$AdminProductSummaryCopyWithImpl(this._self, this._then);

  final _AdminProductSummary _self;
  final $Res Function(_AdminProductSummary) _then;

/// Create a copy of AdminProductSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? categoryId = null,Object? businessId = null,Object? categoryName = null,Object? businessName = null,Object? basePriceMinor = null,Object? variantCount = null,Object? stock = null,Object? description = null,Object? status = null,Object? brandId = freezed,Object? brandName = freezed,Object? images = null,}) {
  return _then(_AdminProductSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,businessName: null == businessName ? _self.businessName : businessName // ignore: cast_nullable_to_non_nullable
as String,basePriceMinor: null == basePriceMinor ? _self.basePriceMinor : basePriceMinor // ignore: cast_nullable_to_non_nullable
as int,variantCount: null == variantCount ? _self.variantCount : variantCount // ignore: cast_nullable_to_non_nullable
as int,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AdminCatalogStatus,brandId: freezed == brandId ? _self.brandId : brandId // ignore: cast_nullable_to_non_nullable
as String?,brandName: freezed == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String?,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<AdminProductImageRef>,
  ));
}


}

/// @nodoc
mixin _$AdminProductImageRef {

 String get id; String get storagePath; String get url;
/// Create a copy of AdminProductImageRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminProductImageRefCopyWith<AdminProductImageRef> get copyWith => _$AdminProductImageRefCopyWithImpl<AdminProductImageRef>(this as AdminProductImageRef, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminProductImageRef&&(identical(other.id, id) || other.id == id)&&(identical(other.storagePath, storagePath) || other.storagePath == storagePath)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,id,storagePath,url);

@override
String toString() {
  return 'AdminProductImageRef(id: $id, storagePath: $storagePath, url: $url)';
}


}

/// @nodoc
abstract mixin class $AdminProductImageRefCopyWith<$Res>  {
  factory $AdminProductImageRefCopyWith(AdminProductImageRef value, $Res Function(AdminProductImageRef) _then) = _$AdminProductImageRefCopyWithImpl;
@useResult
$Res call({
 String id, String storagePath, String url
});




}
/// @nodoc
class _$AdminProductImageRefCopyWithImpl<$Res>
    implements $AdminProductImageRefCopyWith<$Res> {
  _$AdminProductImageRefCopyWithImpl(this._self, this._then);

  final AdminProductImageRef _self;
  final $Res Function(AdminProductImageRef) _then;

/// Create a copy of AdminProductImageRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? storagePath = null,Object? url = null,}) {
  return _then(AdminProductImageRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storagePath: null == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminProductImageRef].
extension AdminProductImageRefPatterns on AdminProductImageRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminProductImageRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminProductImageRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminProductImageRef value)  $default,){
final _that = this;
switch (_that) {
case _AdminProductImageRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminProductImageRef value)?  $default,){
final _that = this;
switch (_that) {
case _AdminProductImageRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String storagePath,  String url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminProductImageRef() when $default != null:
return $default(_that.id,_that.storagePath,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String storagePath,  String url)  $default,) {final _that = this;
switch (_that) {
case _AdminProductImageRef():
return $default(_that.id,_that.storagePath,_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String storagePath,  String url)?  $default,) {final _that = this;
switch (_that) {
case _AdminProductImageRef() when $default != null:
return $default(_that.id,_that.storagePath,_that.url);case _:
  return null;

}
}

}

/// @nodoc


class _AdminProductImageRef implements AdminProductImageRef {
  const _AdminProductImageRef({required this.id, required this.storagePath, required this.url});
  

@override final  String id;
@override final  String storagePath;
@override final  String url;

/// Create a copy of AdminProductImageRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminProductImageRefCopyWith<_AdminProductImageRef> get copyWith => __$AdminProductImageRefCopyWithImpl<_AdminProductImageRef>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminProductImageRef&&(identical(other.id, id) || other.id == id)&&(identical(other.storagePath, storagePath) || other.storagePath == storagePath)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,id,storagePath,url);

@override
String toString() {
  return 'AdminProductImageRef(id: $id, storagePath: $storagePath, url: $url)';
}


}

/// @nodoc
abstract mixin class _$AdminProductImageRefCopyWith<$Res> implements $AdminProductImageRefCopyWith<$Res> {
  factory _$AdminProductImageRefCopyWith(_AdminProductImageRef value, $Res Function(_AdminProductImageRef) _then) = __$AdminProductImageRefCopyWithImpl;
@override @useResult
$Res call({
 String id, String storagePath, String url
});




}
/// @nodoc
class __$AdminProductImageRefCopyWithImpl<$Res>
    implements _$AdminProductImageRefCopyWith<$Res> {
  __$AdminProductImageRefCopyWithImpl(this._self, this._then);

  final _AdminProductImageRef _self;
  final $Res Function(_AdminProductImageRef) _then;

/// Create a copy of AdminProductImageRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? storagePath = null,Object? url = null,}) {
  return _then(_AdminProductImageRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storagePath: null == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$AdminBusinessRef {

 String get id; String get name;
/// Create a copy of AdminBusinessRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminBusinessRefCopyWith<AdminBusinessRef> get copyWith => _$AdminBusinessRefCopyWithImpl<AdminBusinessRef>(this as AdminBusinessRef, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminBusinessRef&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'AdminBusinessRef(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $AdminBusinessRefCopyWith<$Res>  {
  factory $AdminBusinessRefCopyWith(AdminBusinessRef value, $Res Function(AdminBusinessRef) _then) = _$AdminBusinessRefCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$AdminBusinessRefCopyWithImpl<$Res>
    implements $AdminBusinessRefCopyWith<$Res> {
  _$AdminBusinessRefCopyWithImpl(this._self, this._then);

  final AdminBusinessRef _self;
  final $Res Function(AdminBusinessRef) _then;

/// Create a copy of AdminBusinessRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(AdminBusinessRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminBusinessRef].
extension AdminBusinessRefPatterns on AdminBusinessRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminBusinessRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminBusinessRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminBusinessRef value)  $default,){
final _that = this;
switch (_that) {
case _AdminBusinessRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminBusinessRef value)?  $default,){
final _that = this;
switch (_that) {
case _AdminBusinessRef() when $default != null:
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
case _AdminBusinessRef() when $default != null:
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
case _AdminBusinessRef():
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
case _AdminBusinessRef() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _AdminBusinessRef implements AdminBusinessRef {
  const _AdminBusinessRef({required this.id, required this.name});
  

@override final  String id;
@override final  String name;

/// Create a copy of AdminBusinessRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminBusinessRefCopyWith<_AdminBusinessRef> get copyWith => __$AdminBusinessRefCopyWithImpl<_AdminBusinessRef>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminBusinessRef&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'AdminBusinessRef(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$AdminBusinessRefCopyWith<$Res> implements $AdminBusinessRefCopyWith<$Res> {
  factory _$AdminBusinessRefCopyWith(_AdminBusinessRef value, $Res Function(_AdminBusinessRef) _then) = __$AdminBusinessRefCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$AdminBusinessRefCopyWithImpl<$Res>
    implements _$AdminBusinessRefCopyWith<$Res> {
  __$AdminBusinessRefCopyWithImpl(this._self, this._then);

  final _AdminBusinessRef _self;
  final $Res Function(_AdminBusinessRef) _then;

/// Create a copy of AdminBusinessRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_AdminBusinessRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$AdminProductDraft {

 String? get id; String get businessId; String get categoryId; String? get brandId; String get name; String get description; int get basePriceMinor; int get stock;
/// Create a copy of AdminProductDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminProductDraftCopyWith<AdminProductDraft> get copyWith => _$AdminProductDraftCopyWithImpl<AdminProductDraft>(this as AdminProductDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminProductDraft&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.brandId, brandId) || other.brandId == brandId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.basePriceMinor, basePriceMinor) || other.basePriceMinor == basePriceMinor)&&(identical(other.stock, stock) || other.stock == stock));
}


@override
int get hashCode => Object.hash(runtimeType,id,businessId,categoryId,brandId,name,description,basePriceMinor,stock);

@override
String toString() {
  return 'AdminProductDraft(id: $id, businessId: $businessId, categoryId: $categoryId, brandId: $brandId, name: $name, description: $description, basePriceMinor: $basePriceMinor, stock: $stock)';
}


}

/// @nodoc
abstract mixin class $AdminProductDraftCopyWith<$Res>  {
  factory $AdminProductDraftCopyWith(AdminProductDraft value, $Res Function(AdminProductDraft) _then) = _$AdminProductDraftCopyWithImpl;
@useResult
$Res call({
 String? id, String businessId, String categoryId, String? brandId, String name, String description, int basePriceMinor, int stock
});




}
/// @nodoc
class _$AdminProductDraftCopyWithImpl<$Res>
    implements $AdminProductDraftCopyWith<$Res> {
  _$AdminProductDraftCopyWithImpl(this._self, this._then);

  final AdminProductDraft _self;
  final $Res Function(AdminProductDraft) _then;

/// Create a copy of AdminProductDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? businessId = null,Object? categoryId = null,Object? brandId = freezed,Object? name = null,Object? description = null,Object? basePriceMinor = null,Object? stock = null,}) {
  return _then(AdminProductDraft(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,brandId: freezed == brandId ? _self.brandId : brandId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,basePriceMinor: null == basePriceMinor ? _self.basePriceMinor : basePriceMinor // ignore: cast_nullable_to_non_nullable
as int,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminProductDraft].
extension AdminProductDraftPatterns on AdminProductDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminProductDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminProductDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminProductDraft value)  $default,){
final _that = this;
switch (_that) {
case _AdminProductDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminProductDraft value)?  $default,){
final _that = this;
switch (_that) {
case _AdminProductDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String businessId,  String categoryId,  String? brandId,  String name,  String description,  int basePriceMinor,  int stock)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminProductDraft() when $default != null:
return $default(_that.id,_that.businessId,_that.categoryId,_that.brandId,_that.name,_that.description,_that.basePriceMinor,_that.stock);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String businessId,  String categoryId,  String? brandId,  String name,  String description,  int basePriceMinor,  int stock)  $default,) {final _that = this;
switch (_that) {
case _AdminProductDraft():
return $default(_that.id,_that.businessId,_that.categoryId,_that.brandId,_that.name,_that.description,_that.basePriceMinor,_that.stock);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String businessId,  String categoryId,  String? brandId,  String name,  String description,  int basePriceMinor,  int stock)?  $default,) {final _that = this;
switch (_that) {
case _AdminProductDraft() when $default != null:
return $default(_that.id,_that.businessId,_that.categoryId,_that.brandId,_that.name,_that.description,_that.basePriceMinor,_that.stock);case _:
  return null;

}
}

}

/// @nodoc


class _AdminProductDraft implements AdminProductDraft {
  const _AdminProductDraft({this.id, required this.businessId, required this.categoryId, this.brandId, required this.name, this.description = '', required this.basePriceMinor, this.stock = 0});
  

@override final  String? id;
@override final  String businessId;
@override final  String categoryId;
@override final  String? brandId;
@override final  String name;
@override@JsonKey() final  String description;
@override final  int basePriceMinor;
@override@JsonKey() final  int stock;

/// Create a copy of AdminProductDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminProductDraftCopyWith<_AdminProductDraft> get copyWith => __$AdminProductDraftCopyWithImpl<_AdminProductDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminProductDraft&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.brandId, brandId) || other.brandId == brandId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.basePriceMinor, basePriceMinor) || other.basePriceMinor == basePriceMinor)&&(identical(other.stock, stock) || other.stock == stock));
}


@override
int get hashCode => Object.hash(runtimeType,id,businessId,categoryId,brandId,name,description,basePriceMinor,stock);

@override
String toString() {
  return 'AdminProductDraft(id: $id, businessId: $businessId, categoryId: $categoryId, brandId: $brandId, name: $name, description: $description, basePriceMinor: $basePriceMinor, stock: $stock)';
}


}

/// @nodoc
abstract mixin class _$AdminProductDraftCopyWith<$Res> implements $AdminProductDraftCopyWith<$Res> {
  factory _$AdminProductDraftCopyWith(_AdminProductDraft value, $Res Function(_AdminProductDraft) _then) = __$AdminProductDraftCopyWithImpl;
@override @useResult
$Res call({
 String? id, String businessId, String categoryId, String? brandId, String name, String description, int basePriceMinor, int stock
});




}
/// @nodoc
class __$AdminProductDraftCopyWithImpl<$Res>
    implements _$AdminProductDraftCopyWith<$Res> {
  __$AdminProductDraftCopyWithImpl(this._self, this._then);

  final _AdminProductDraft _self;
  final $Res Function(_AdminProductDraft) _then;

/// Create a copy of AdminProductDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? businessId = null,Object? categoryId = null,Object? brandId = freezed,Object? name = null,Object? description = null,Object? basePriceMinor = null,Object? stock = null,}) {
  return _then(_AdminProductDraft(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,brandId: freezed == brandId ? _self.brandId : brandId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,basePriceMinor: null == basePriceMinor ? _self.basePriceMinor : basePriceMinor // ignore: cast_nullable_to_non_nullable
as int,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$AdminOrderSummary {

 String get id; String get customerName; int get subtotalMinor; int get discountMinor; int get deliveryFeeMinor; int get totalMinor; DateTime get createdAt; String? get paymentMethod; String? get paymentStatus; List<AdminBusinessOrderPart> get parts; List<AdminReturnRequest> get returns;
/// Create a copy of AdminOrderSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminOrderSummaryCopyWith<AdminOrderSummary> get copyWith => _$AdminOrderSummaryCopyWithImpl<AdminOrderSummary>(this as AdminOrderSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminOrderSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.subtotalMinor, subtotalMinor) || other.subtotalMinor == subtotalMinor)&&(identical(other.discountMinor, discountMinor) || other.discountMinor == discountMinor)&&(identical(other.deliveryFeeMinor, deliveryFeeMinor) || other.deliveryFeeMinor == deliveryFeeMinor)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&const DeepCollectionEquality().equals(other.parts, parts)&&const DeepCollectionEquality().equals(other.returns, returns));
}


@override
int get hashCode => Object.hash(runtimeType,id,customerName,subtotalMinor,discountMinor,deliveryFeeMinor,totalMinor,createdAt,paymentMethod,paymentStatus,const DeepCollectionEquality().hash(parts),const DeepCollectionEquality().hash(returns));

@override
String toString() {
  return 'AdminOrderSummary(id: $id, customerName: $customerName, subtotalMinor: $subtotalMinor, discountMinor: $discountMinor, deliveryFeeMinor: $deliveryFeeMinor, totalMinor: $totalMinor, createdAt: $createdAt, paymentMethod: $paymentMethod, paymentStatus: $paymentStatus, parts: $parts, returns: $returns)';
}


}

/// @nodoc
abstract mixin class $AdminOrderSummaryCopyWith<$Res>  {
  factory $AdminOrderSummaryCopyWith(AdminOrderSummary value, $Res Function(AdminOrderSummary) _then) = _$AdminOrderSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String customerName, int subtotalMinor, int discountMinor, int deliveryFeeMinor, int totalMinor, DateTime createdAt, String? paymentMethod, String? paymentStatus, List<AdminBusinessOrderPart> parts, List<AdminReturnRequest> returns
});




}
/// @nodoc
class _$AdminOrderSummaryCopyWithImpl<$Res>
    implements $AdminOrderSummaryCopyWith<$Res> {
  _$AdminOrderSummaryCopyWithImpl(this._self, this._then);

  final AdminOrderSummary _self;
  final $Res Function(AdminOrderSummary) _then;

/// Create a copy of AdminOrderSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? customerName = null,Object? subtotalMinor = null,Object? discountMinor = null,Object? deliveryFeeMinor = null,Object? totalMinor = null,Object? createdAt = null,Object? paymentMethod = freezed,Object? paymentStatus = freezed,Object? parts = null,Object? returns = null,}) {
  return _then(AdminOrderSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,subtotalMinor: null == subtotalMinor ? _self.subtotalMinor : subtotalMinor // ignore: cast_nullable_to_non_nullable
as int,discountMinor: null == discountMinor ? _self.discountMinor : discountMinor // ignore: cast_nullable_to_non_nullable
as int,deliveryFeeMinor: null == deliveryFeeMinor ? _self.deliveryFeeMinor : deliveryFeeMinor // ignore: cast_nullable_to_non_nullable
as int,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,paymentStatus: freezed == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as String?,parts: null == parts ? _self.parts : parts // ignore: cast_nullable_to_non_nullable
as List<AdminBusinessOrderPart>,returns: null == returns ? _self.returns : returns // ignore: cast_nullable_to_non_nullable
as List<AdminReturnRequest>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminOrderSummary].
extension AdminOrderSummaryPatterns on AdminOrderSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminOrderSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminOrderSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminOrderSummary value)  $default,){
final _that = this;
switch (_that) {
case _AdminOrderSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminOrderSummary value)?  $default,){
final _that = this;
switch (_that) {
case _AdminOrderSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String customerName,  int subtotalMinor,  int discountMinor,  int deliveryFeeMinor,  int totalMinor,  DateTime createdAt,  String? paymentMethod,  String? paymentStatus,  List<AdminBusinessOrderPart> parts,  List<AdminReturnRequest> returns)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminOrderSummary() when $default != null:
return $default(_that.id,_that.customerName,_that.subtotalMinor,_that.discountMinor,_that.deliveryFeeMinor,_that.totalMinor,_that.createdAt,_that.paymentMethod,_that.paymentStatus,_that.parts,_that.returns);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String customerName,  int subtotalMinor,  int discountMinor,  int deliveryFeeMinor,  int totalMinor,  DateTime createdAt,  String? paymentMethod,  String? paymentStatus,  List<AdminBusinessOrderPart> parts,  List<AdminReturnRequest> returns)  $default,) {final _that = this;
switch (_that) {
case _AdminOrderSummary():
return $default(_that.id,_that.customerName,_that.subtotalMinor,_that.discountMinor,_that.deliveryFeeMinor,_that.totalMinor,_that.createdAt,_that.paymentMethod,_that.paymentStatus,_that.parts,_that.returns);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String customerName,  int subtotalMinor,  int discountMinor,  int deliveryFeeMinor,  int totalMinor,  DateTime createdAt,  String? paymentMethod,  String? paymentStatus,  List<AdminBusinessOrderPart> parts,  List<AdminReturnRequest> returns)?  $default,) {final _that = this;
switch (_that) {
case _AdminOrderSummary() when $default != null:
return $default(_that.id,_that.customerName,_that.subtotalMinor,_that.discountMinor,_that.deliveryFeeMinor,_that.totalMinor,_that.createdAt,_that.paymentMethod,_that.paymentStatus,_that.parts,_that.returns);case _:
  return null;

}
}

}

/// @nodoc


class _AdminOrderSummary extends AdminOrderSummary {
  const _AdminOrderSummary({required this.id, required this.customerName, required this.subtotalMinor, required this.discountMinor, required this.deliveryFeeMinor, required this.totalMinor, required this.createdAt, this.paymentMethod, this.paymentStatus,  List<AdminBusinessOrderPart> parts = const [],  List<AdminReturnRequest> returns = const []}): _parts = parts,_returns = returns,super._();
  

@override final  String id;
@override final  String customerName;
@override final  int subtotalMinor;
@override final  int discountMinor;
@override final  int deliveryFeeMinor;
@override final  int totalMinor;
@override final  DateTime createdAt;
@override final  String? paymentMethod;
@override final  String? paymentStatus;
 final  List<AdminBusinessOrderPart> _parts;
@override@JsonKey() List<AdminBusinessOrderPart> get parts {
  if (_parts is EqualUnmodifiableListView) return _parts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parts);
}

 final  List<AdminReturnRequest> _returns;
@override@JsonKey() List<AdminReturnRequest> get returns {
  if (_returns is EqualUnmodifiableListView) return _returns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_returns);
}


/// Create a copy of AdminOrderSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminOrderSummaryCopyWith<_AdminOrderSummary> get copyWith => __$AdminOrderSummaryCopyWithImpl<_AdminOrderSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminOrderSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.subtotalMinor, subtotalMinor) || other.subtotalMinor == subtotalMinor)&&(identical(other.discountMinor, discountMinor) || other.discountMinor == discountMinor)&&(identical(other.deliveryFeeMinor, deliveryFeeMinor) || other.deliveryFeeMinor == deliveryFeeMinor)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&const DeepCollectionEquality().equals(other._parts, _parts)&&const DeepCollectionEquality().equals(other._returns, _returns));
}


@override
int get hashCode => Object.hash(runtimeType,id,customerName,subtotalMinor,discountMinor,deliveryFeeMinor,totalMinor,createdAt,paymentMethod,paymentStatus,const DeepCollectionEquality().hash(_parts),const DeepCollectionEquality().hash(_returns));

@override
String toString() {
  return 'AdminOrderSummary(id: $id, customerName: $customerName, subtotalMinor: $subtotalMinor, discountMinor: $discountMinor, deliveryFeeMinor: $deliveryFeeMinor, totalMinor: $totalMinor, createdAt: $createdAt, paymentMethod: $paymentMethod, paymentStatus: $paymentStatus, parts: $parts, returns: $returns)';
}


}

/// @nodoc
abstract mixin class _$AdminOrderSummaryCopyWith<$Res> implements $AdminOrderSummaryCopyWith<$Res> {
  factory _$AdminOrderSummaryCopyWith(_AdminOrderSummary value, $Res Function(_AdminOrderSummary) _then) = __$AdminOrderSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String customerName, int subtotalMinor, int discountMinor, int deliveryFeeMinor, int totalMinor, DateTime createdAt, String? paymentMethod, String? paymentStatus, List<AdminBusinessOrderPart> parts, List<AdminReturnRequest> returns
});




}
/// @nodoc
class __$AdminOrderSummaryCopyWithImpl<$Res>
    implements _$AdminOrderSummaryCopyWith<$Res> {
  __$AdminOrderSummaryCopyWithImpl(this._self, this._then);

  final _AdminOrderSummary _self;
  final $Res Function(_AdminOrderSummary) _then;

/// Create a copy of AdminOrderSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? customerName = null,Object? subtotalMinor = null,Object? discountMinor = null,Object? deliveryFeeMinor = null,Object? totalMinor = null,Object? createdAt = null,Object? paymentMethod = freezed,Object? paymentStatus = freezed,Object? parts = null,Object? returns = null,}) {
  return _then(_AdminOrderSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,subtotalMinor: null == subtotalMinor ? _self.subtotalMinor : subtotalMinor // ignore: cast_nullable_to_non_nullable
as int,discountMinor: null == discountMinor ? _self.discountMinor : discountMinor // ignore: cast_nullable_to_non_nullable
as int,deliveryFeeMinor: null == deliveryFeeMinor ? _self.deliveryFeeMinor : deliveryFeeMinor // ignore: cast_nullable_to_non_nullable
as int,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,paymentStatus: freezed == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as String?,parts: null == parts ? _self._parts : parts // ignore: cast_nullable_to_non_nullable
as List<AdminBusinessOrderPart>,returns: null == returns ? _self._returns : returns // ignore: cast_nullable_to_non_nullable
as List<AdminReturnRequest>,
  ));
}


}

/// @nodoc
mixin _$AdminBusinessOrderPart {

 String get id; String get businessName; String get status; int get subtotalMinor; int get discountMinor; String? get rejectionReason;
/// Create a copy of AdminBusinessOrderPart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminBusinessOrderPartCopyWith<AdminBusinessOrderPart> get copyWith => _$AdminBusinessOrderPartCopyWithImpl<AdminBusinessOrderPart>(this as AdminBusinessOrderPart, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminBusinessOrderPart&&(identical(other.id, id) || other.id == id)&&(identical(other.businessName, businessName) || other.businessName == businessName)&&(identical(other.status, status) || other.status == status)&&(identical(other.subtotalMinor, subtotalMinor) || other.subtotalMinor == subtotalMinor)&&(identical(other.discountMinor, discountMinor) || other.discountMinor == discountMinor)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason));
}


@override
int get hashCode => Object.hash(runtimeType,id,businessName,status,subtotalMinor,discountMinor,rejectionReason);

@override
String toString() {
  return 'AdminBusinessOrderPart(id: $id, businessName: $businessName, status: $status, subtotalMinor: $subtotalMinor, discountMinor: $discountMinor, rejectionReason: $rejectionReason)';
}


}

/// @nodoc
abstract mixin class $AdminBusinessOrderPartCopyWith<$Res>  {
  factory $AdminBusinessOrderPartCopyWith(AdminBusinessOrderPart value, $Res Function(AdminBusinessOrderPart) _then) = _$AdminBusinessOrderPartCopyWithImpl;
@useResult
$Res call({
 String id, String businessName, String status, int subtotalMinor, int discountMinor, String? rejectionReason
});




}
/// @nodoc
class _$AdminBusinessOrderPartCopyWithImpl<$Res>
    implements $AdminBusinessOrderPartCopyWith<$Res> {
  _$AdminBusinessOrderPartCopyWithImpl(this._self, this._then);

  final AdminBusinessOrderPart _self;
  final $Res Function(AdminBusinessOrderPart) _then;

/// Create a copy of AdminBusinessOrderPart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessName = null,Object? status = null,Object? subtotalMinor = null,Object? discountMinor = null,Object? rejectionReason = freezed,}) {
  return _then(AdminBusinessOrderPart(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessName: null == businessName ? _self.businessName : businessName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,subtotalMinor: null == subtotalMinor ? _self.subtotalMinor : subtotalMinor // ignore: cast_nullable_to_non_nullable
as int,discountMinor: null == discountMinor ? _self.discountMinor : discountMinor // ignore: cast_nullable_to_non_nullable
as int,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminBusinessOrderPart].
extension AdminBusinessOrderPartPatterns on AdminBusinessOrderPart {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminBusinessOrderPart value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminBusinessOrderPart() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminBusinessOrderPart value)  $default,){
final _that = this;
switch (_that) {
case _AdminBusinessOrderPart():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminBusinessOrderPart value)?  $default,){
final _that = this;
switch (_that) {
case _AdminBusinessOrderPart() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String businessName,  String status,  int subtotalMinor,  int discountMinor,  String? rejectionReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminBusinessOrderPart() when $default != null:
return $default(_that.id,_that.businessName,_that.status,_that.subtotalMinor,_that.discountMinor,_that.rejectionReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String businessName,  String status,  int subtotalMinor,  int discountMinor,  String? rejectionReason)  $default,) {final _that = this;
switch (_that) {
case _AdminBusinessOrderPart():
return $default(_that.id,_that.businessName,_that.status,_that.subtotalMinor,_that.discountMinor,_that.rejectionReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String businessName,  String status,  int subtotalMinor,  int discountMinor,  String? rejectionReason)?  $default,) {final _that = this;
switch (_that) {
case _AdminBusinessOrderPart() when $default != null:
return $default(_that.id,_that.businessName,_that.status,_that.subtotalMinor,_that.discountMinor,_that.rejectionReason);case _:
  return null;

}
}

}

/// @nodoc


class _AdminBusinessOrderPart implements AdminBusinessOrderPart {
  const _AdminBusinessOrderPart({required this.id, required this.businessName, required this.status, required this.subtotalMinor, required this.discountMinor, this.rejectionReason});
  

@override final  String id;
@override final  String businessName;
@override final  String status;
@override final  int subtotalMinor;
@override final  int discountMinor;
@override final  String? rejectionReason;

/// Create a copy of AdminBusinessOrderPart
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminBusinessOrderPartCopyWith<_AdminBusinessOrderPart> get copyWith => __$AdminBusinessOrderPartCopyWithImpl<_AdminBusinessOrderPart>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminBusinessOrderPart&&(identical(other.id, id) || other.id == id)&&(identical(other.businessName, businessName) || other.businessName == businessName)&&(identical(other.status, status) || other.status == status)&&(identical(other.subtotalMinor, subtotalMinor) || other.subtotalMinor == subtotalMinor)&&(identical(other.discountMinor, discountMinor) || other.discountMinor == discountMinor)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason));
}


@override
int get hashCode => Object.hash(runtimeType,id,businessName,status,subtotalMinor,discountMinor,rejectionReason);

@override
String toString() {
  return 'AdminBusinessOrderPart(id: $id, businessName: $businessName, status: $status, subtotalMinor: $subtotalMinor, discountMinor: $discountMinor, rejectionReason: $rejectionReason)';
}


}

/// @nodoc
abstract mixin class _$AdminBusinessOrderPartCopyWith<$Res> implements $AdminBusinessOrderPartCopyWith<$Res> {
  factory _$AdminBusinessOrderPartCopyWith(_AdminBusinessOrderPart value, $Res Function(_AdminBusinessOrderPart) _then) = __$AdminBusinessOrderPartCopyWithImpl;
@override @useResult
$Res call({
 String id, String businessName, String status, int subtotalMinor, int discountMinor, String? rejectionReason
});




}
/// @nodoc
class __$AdminBusinessOrderPartCopyWithImpl<$Res>
    implements _$AdminBusinessOrderPartCopyWith<$Res> {
  __$AdminBusinessOrderPartCopyWithImpl(this._self, this._then);

  final _AdminBusinessOrderPart _self;
  final $Res Function(_AdminBusinessOrderPart) _then;

/// Create a copy of AdminBusinessOrderPart
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessName = null,Object? status = null,Object? subtotalMinor = null,Object? discountMinor = null,Object? rejectionReason = freezed,}) {
  return _then(_AdminBusinessOrderPart(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessName: null == businessName ? _self.businessName : businessName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,subtotalMinor: null == subtotalMinor ? _self.subtotalMinor : subtotalMinor // ignore: cast_nullable_to_non_nullable
as int,discountMinor: null == discountMinor ? _self.discountMinor : discountMinor // ignore: cast_nullable_to_non_nullable
as int,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$AdminReturnRequest {

 String get id; String get status; String get reason;
/// Create a copy of AdminReturnRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminReturnRequestCopyWith<AdminReturnRequest> get copyWith => _$AdminReturnRequestCopyWithImpl<AdminReturnRequest>(this as AdminReturnRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminReturnRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,id,status,reason);

@override
String toString() {
  return 'AdminReturnRequest(id: $id, status: $status, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $AdminReturnRequestCopyWith<$Res>  {
  factory $AdminReturnRequestCopyWith(AdminReturnRequest value, $Res Function(AdminReturnRequest) _then) = _$AdminReturnRequestCopyWithImpl;
@useResult
$Res call({
 String id, String status, String reason
});




}
/// @nodoc
class _$AdminReturnRequestCopyWithImpl<$Res>
    implements $AdminReturnRequestCopyWith<$Res> {
  _$AdminReturnRequestCopyWithImpl(this._self, this._then);

  final AdminReturnRequest _self;
  final $Res Function(AdminReturnRequest) _then;

/// Create a copy of AdminReturnRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? reason = null,}) {
  return _then(AdminReturnRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminReturnRequest].
extension AdminReturnRequestPatterns on AdminReturnRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminReturnRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminReturnRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminReturnRequest value)  $default,){
final _that = this;
switch (_that) {
case _AdminReturnRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminReturnRequest value)?  $default,){
final _that = this;
switch (_that) {
case _AdminReturnRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String status,  String reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminReturnRequest() when $default != null:
return $default(_that.id,_that.status,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String status,  String reason)  $default,) {final _that = this;
switch (_that) {
case _AdminReturnRequest():
return $default(_that.id,_that.status,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String status,  String reason)?  $default,) {final _that = this;
switch (_that) {
case _AdminReturnRequest() when $default != null:
return $default(_that.id,_that.status,_that.reason);case _:
  return null;

}
}

}

/// @nodoc


class _AdminReturnRequest implements AdminReturnRequest {
  const _AdminReturnRequest({required this.id, required this.status, this.reason = ''});
  

@override final  String id;
@override final  String status;
@override@JsonKey() final  String reason;

/// Create a copy of AdminReturnRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminReturnRequestCopyWith<_AdminReturnRequest> get copyWith => __$AdminReturnRequestCopyWithImpl<_AdminReturnRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminReturnRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,id,status,reason);

@override
String toString() {
  return 'AdminReturnRequest(id: $id, status: $status, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$AdminReturnRequestCopyWith<$Res> implements $AdminReturnRequestCopyWith<$Res> {
  factory _$AdminReturnRequestCopyWith(_AdminReturnRequest value, $Res Function(_AdminReturnRequest) _then) = __$AdminReturnRequestCopyWithImpl;
@override @useResult
$Res call({
 String id, String status, String reason
});




}
/// @nodoc
class __$AdminReturnRequestCopyWithImpl<$Res>
    implements _$AdminReturnRequestCopyWith<$Res> {
  __$AdminReturnRequestCopyWithImpl(this._self, this._then);

  final _AdminReturnRequest _self;
  final $Res Function(_AdminReturnRequest) _then;

/// Create a copy of AdminReturnRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? reason = null,}) {
  return _then(_AdminReturnRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
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
