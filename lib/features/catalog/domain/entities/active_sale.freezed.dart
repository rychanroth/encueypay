// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'active_sale.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActiveSale {

 String get id; CatalogSaleScope get scope; CatalogSaleType get discountType; int get discountValue; String get name; String get description; DateTime? get startsAt; DateTime? get endsAt; String? get brandId; String? get categoryId;/// Category scope covers the whole subtree — the ids this sale applies
/// to, resolved by SQL (`active_sales.category_ids`).
 List<String> get categoryIds;
/// Create a copy of ActiveSale
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActiveSaleCopyWith<ActiveSale> get copyWith => _$ActiveSaleCopyWithImpl<ActiveSale>(this as ActiveSale, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActiveSale&&(identical(other.id, id) || other.id == id)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.brandId, brandId) || other.brandId == brandId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&const DeepCollectionEquality().equals(other.categoryIds, categoryIds));
}


@override
int get hashCode => Object.hash(runtimeType,id,scope,discountType,discountValue,name,description,startsAt,endsAt,brandId,categoryId,const DeepCollectionEquality().hash(categoryIds));

@override
String toString() {
  return 'ActiveSale(id: $id, scope: $scope, discountType: $discountType, discountValue: $discountValue, name: $name, description: $description, startsAt: $startsAt, endsAt: $endsAt, brandId: $brandId, categoryId: $categoryId, categoryIds: $categoryIds)';
}


}

/// @nodoc
abstract mixin class $ActiveSaleCopyWith<$Res>  {
  factory $ActiveSaleCopyWith(ActiveSale value, $Res Function(ActiveSale) _then) = _$ActiveSaleCopyWithImpl;
@useResult
$Res call({
 String id, CatalogSaleScope scope, CatalogSaleType discountType, int discountValue, String name, String description, DateTime? startsAt, DateTime? endsAt, String? brandId, String? categoryId, List<String> categoryIds
});




}
/// @nodoc
class _$ActiveSaleCopyWithImpl<$Res>
    implements $ActiveSaleCopyWith<$Res> {
  _$ActiveSaleCopyWithImpl(this._self, this._then);

  final ActiveSale _self;
  final $Res Function(ActiveSale) _then;

/// Create a copy of ActiveSale
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? scope = null,Object? discountType = null,Object? discountValue = null,Object? name = null,Object? description = null,Object? startsAt = freezed,Object? endsAt = freezed,Object? brandId = freezed,Object? categoryId = freezed,Object? categoryIds = null,}) {
  return _then(ActiveSale(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as CatalogSaleScope,discountType: null == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as CatalogSaleType,discountValue: null == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,brandId: freezed == brandId ? _self.brandId : brandId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,categoryIds: null == categoryIds ? _self.categoryIds : categoryIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ActiveSale].
extension ActiveSalePatterns on ActiveSale {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActiveSale value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActiveSale() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActiveSale value)  $default,){
final _that = this;
switch (_that) {
case _ActiveSale():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActiveSale value)?  $default,){
final _that = this;
switch (_that) {
case _ActiveSale() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  CatalogSaleScope scope,  CatalogSaleType discountType,  int discountValue,  String name,  String description,  DateTime? startsAt,  DateTime? endsAt,  String? brandId,  String? categoryId,  List<String> categoryIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActiveSale() when $default != null:
return $default(_that.id,_that.scope,_that.discountType,_that.discountValue,_that.name,_that.description,_that.startsAt,_that.endsAt,_that.brandId,_that.categoryId,_that.categoryIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  CatalogSaleScope scope,  CatalogSaleType discountType,  int discountValue,  String name,  String description,  DateTime? startsAt,  DateTime? endsAt,  String? brandId,  String? categoryId,  List<String> categoryIds)  $default,) {final _that = this;
switch (_that) {
case _ActiveSale():
return $default(_that.id,_that.scope,_that.discountType,_that.discountValue,_that.name,_that.description,_that.startsAt,_that.endsAt,_that.brandId,_that.categoryId,_that.categoryIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  CatalogSaleScope scope,  CatalogSaleType discountType,  int discountValue,  String name,  String description,  DateTime? startsAt,  DateTime? endsAt,  String? brandId,  String? categoryId,  List<String> categoryIds)?  $default,) {final _that = this;
switch (_that) {
case _ActiveSale() when $default != null:
return $default(_that.id,_that.scope,_that.discountType,_that.discountValue,_that.name,_that.description,_that.startsAt,_that.endsAt,_that.brandId,_that.categoryId,_that.categoryIds);case _:
  return null;

}
}

}

/// @nodoc


class _ActiveSale extends ActiveSale {
  const _ActiveSale({required this.id, required this.scope, required this.discountType, required this.discountValue, this.name = '', this.description = '', this.startsAt, this.endsAt, this.brandId, this.categoryId,  List<String> categoryIds = const <String>[]}): _categoryIds = categoryIds,super._();
  

@override final  String id;
@override final  CatalogSaleScope scope;
@override final  CatalogSaleType discountType;
@override final  int discountValue;
@override@JsonKey() final  String name;
@override@JsonKey() final  String description;
@override final  DateTime? startsAt;
@override final  DateTime? endsAt;
@override final  String? brandId;
@override final  String? categoryId;
/// Category scope covers the whole subtree — the ids this sale applies
/// to, resolved by SQL (`active_sales.category_ids`).
 final  List<String> _categoryIds;
/// Category scope covers the whole subtree — the ids this sale applies
/// to, resolved by SQL (`active_sales.category_ids`).
@override@JsonKey() List<String> get categoryIds {
  if (_categoryIds is EqualUnmodifiableListView) return _categoryIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categoryIds);
}


/// Create a copy of ActiveSale
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActiveSaleCopyWith<_ActiveSale> get copyWith => __$ActiveSaleCopyWithImpl<_ActiveSale>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActiveSale&&(identical(other.id, id) || other.id == id)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.brandId, brandId) || other.brandId == brandId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&const DeepCollectionEquality().equals(other._categoryIds, _categoryIds));
}


@override
int get hashCode => Object.hash(runtimeType,id,scope,discountType,discountValue,name,description,startsAt,endsAt,brandId,categoryId,const DeepCollectionEquality().hash(_categoryIds));

@override
String toString() {
  return 'ActiveSale(id: $id, scope: $scope, discountType: $discountType, discountValue: $discountValue, name: $name, description: $description, startsAt: $startsAt, endsAt: $endsAt, brandId: $brandId, categoryId: $categoryId, categoryIds: $categoryIds)';
}


}

/// @nodoc
abstract mixin class _$ActiveSaleCopyWith<$Res> implements $ActiveSaleCopyWith<$Res> {
  factory _$ActiveSaleCopyWith(_ActiveSale value, $Res Function(_ActiveSale) _then) = __$ActiveSaleCopyWithImpl;
@override @useResult
$Res call({
 String id, CatalogSaleScope scope, CatalogSaleType discountType, int discountValue, String name, String description, DateTime? startsAt, DateTime? endsAt, String? brandId, String? categoryId, List<String> categoryIds
});




}
/// @nodoc
class __$ActiveSaleCopyWithImpl<$Res>
    implements _$ActiveSaleCopyWith<$Res> {
  __$ActiveSaleCopyWithImpl(this._self, this._then);

  final _ActiveSale _self;
  final $Res Function(_ActiveSale) _then;

/// Create a copy of ActiveSale
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? scope = null,Object? discountType = null,Object? discountValue = null,Object? name = null,Object? description = null,Object? startsAt = freezed,Object? endsAt = freezed,Object? brandId = freezed,Object? categoryId = freezed,Object? categoryIds = null,}) {
  return _then(_ActiveSale(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as CatalogSaleScope,discountType: null == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as CatalogSaleType,discountValue: null == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,brandId: freezed == brandId ? _self.brandId : brandId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,categoryIds: null == categoryIds ? _self._categoryIds : categoryIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
