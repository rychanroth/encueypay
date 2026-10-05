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

    /// Cheapest selectable price — min over variant effective prices, base
    /// price when the product has none. What grids/cards display.
    required int fromPriceMinor,
    @Default(ProductStatus.active) ProductStatus status,
    @Default([]) List<String> imageUrls,
  }) = _Product;

  const Product._();

  /// Public URLs resolved from Storage references in the data layer (§48).
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
