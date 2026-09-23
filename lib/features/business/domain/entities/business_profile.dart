/// The signed-in business user's own store (spec §4: one Business per
/// business user). Management-oriented view — the public catalog feature
/// keeps its own slim display entity (ARCH-04).
class BusinessProfile {
  const BusinessProfile({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String description;
  final String? imageUrl;
}

/// A product as managed by its business (spec §6–§7): all statuses visible,
/// archive instead of delete, per-variant stock.
class BusinessProduct {
  const BusinessProduct({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.basePriceMinor,
    required this.stock,
    required this.archived,
    required this.variants,
  });

  final String id;
  final String categoryId;
  final String name;
  final String description;
  final int basePriceMinor;
  final int stock;
  final bool archived;
  final List<ManagementVariant> variants;
}

class ManagementVariant {
  const ManagementVariant({
    required this.id,
    required this.name,
    required this.priceMinor,
    required this.stock,
  });

  final String id;
  final String name;

  /// null → falls back to the product's base price (spec §5.3).
  final int? priceMinor;
  final int stock;
}

/// Input shape for creating a product's variants (spec §5.3).
class VariantDraft {
  const VariantDraft({required this.name, this.priceMinor, required this.stock});

  final String name;
  final int? priceMinor;
  final int stock;
}

/// Slim category option for the product form. Duplicate by design —
/// features never import each other (ARCH-04).
class CategoryOption {
  const CategoryOption({required this.id, required this.name});

  final String id;
  final String name;
}
