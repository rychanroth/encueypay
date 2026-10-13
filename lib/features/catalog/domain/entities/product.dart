import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';

/// A sellable product (spec §5.2/§6). Products are archived, never deleted;
/// historical orders keep their own snapshots (spec §19).
@freezed
abstract class Product with _$Product {
  const factory Product({
    required String id,
    required String businessId,
    required String categoryId,
    String? brandId,
    required String name,
    @Default('') String description,
    required int basePriceMinor,

    /// Product-wide stock (Section 2d, assignment §3): purchasing any
    /// variant deducts this counter; variants carry no stock of their own.
    @Default(0) int stock,

    /// Cheapest selectable price — min over variant effective prices, base
    /// price when the product has none. What grids/cards display.
    required int fromPriceMinor,

    /// First variant id (Section 6): the quick-action "add to cart" uses
    /// the product's default variant. Never null in practice —
    /// `create_product` auto-creates 'Default' — but tolerated here.
    String? defaultVariantId,
    @Default('') String brandName,
    double? ratingAvg,
    @Default(0) int reviewCount,
    @Default(ProductStatus.active) ProductStatus status,
    @Default([]) List<String> imageUrls,
  }) = _Product;

  const Product._();

  /// Public URLs resolved from Storage references in the data layer (§48).
  String get thumbnailUrl => imageUrls.isEmpty ? '' : imageUrls.first;

  /// Disabled products (archived) and out-of-stock products are both shown
  /// to customers (Section 2d) but cannot be purchased.
  bool get isPurchasable =>
      status == ProductStatus.active && stock > 0;

  /// Short availability label for cards/detail (Section 2d).
  String? get availabilityLabel {
    if (status == ProductStatus.archived) return 'Unavailable';
    if (stock <= 0) return 'Out of stock';
    return null;
  }
}

enum ProductStatus {
  active,
  archived;

  /// Unknown wire values fall back to [archived] — the safe default for
  /// public browsing (DATA-02).
  static ProductStatus fromName(String? name) =>
      ProductStatus.values.asNameMap()[name] ?? ProductStatus.archived;
}
