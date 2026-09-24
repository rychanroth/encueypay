import 'package:freezed_annotation/freezed_annotation.dart';

part 'business_profile.freezed.dart';

/// The signed-in business user's own store (spec §4: one Business per
/// business user). Management-oriented view — the public catalog feature
/// keeps its own slim display entity (ARCH-04).
@freezed
abstract class BusinessProfile with _$BusinessProfile {
  const factory BusinessProfile({
    required String id,
    required String name,
    @Default('') String description,
    String? imageUrl,
  }) = _BusinessProfile;
}

/// A product as managed by its business (spec §6–§7): all statuses visible,
/// archive instead of delete, per-variant stock.
@freezed
abstract class BusinessProduct with _$BusinessProduct {
  const factory BusinessProduct({
    required String id,
    required String categoryId,
    required String name,
    @Default('') String description,
    required int basePriceMinor,
    required int stock,
    required bool archived,
    required List<ManagementVariant> variants,
  }) = _BusinessProduct;
}

@freezed
abstract class ManagementVariant with _$ManagementVariant {
  const factory ManagementVariant({
    required String id,
    required String name,
    required int? priceMinor,
    required int stock,
  }) = _ManagementVariant;
}

/// Input shape for creating a product's variants (spec §5.3).
@freezed
abstract class VariantDraft with _$VariantDraft {
  const factory VariantDraft({
    required String name,
    required int? priceMinor,
    required int stock,
  }) = _VariantDraft;
}

/// Slim category option for the product form. Duplicate by design —
/// features never import each other (ARCH-04).
@freezed
abstract class CategoryOption with _$CategoryOption {
  const factory CategoryOption({required String id, required String name})
      = _CategoryOption;
}
