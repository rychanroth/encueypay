import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';

/// Platform-level catalog structure (spec §5.1) with optional parent/child
/// hierarchy. Immutable via freezed (DOMAIN-01).
@freezed
abstract class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    String? parentId,
  }) = _Category;

  const Category._();

  bool get isTopLevel => parentId == null;
}
