/// A sellable product (spec §5.2/§6). Products are archived, never deleted;
/// historical orders keep their own snapshots (spec §19).
class Product {
  const Product({
    required this.id,
    required this.businessId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.basePriceMinor,
    required this.stock,
    required this.status,
    this.imageUrls = const [],
  });

  final String id;
  final String businessId;
  final String categoryId;
  final String name;
  final String description;
  final int basePriceMinor;
  final int stock;
  final ProductStatus status;

  /// Public URLs resolved from Storage references in the data layer (§48).
  final List<String> imageUrls;

  String get thumbnailUrl => imageUrls.isEmpty ? '' : imageUrls.first;
}

enum ProductStatus {
  active,
  archived;

  /// Unknown wire values fall back to [archived] — the safe default for
  /// public browsing (DATA-02).
  static ProductStatus fromName(String? name) =>
      ProductStatus.values.asNameMap()[name] ?? ProductStatus.archived;
}
