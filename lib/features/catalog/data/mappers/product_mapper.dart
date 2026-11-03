import 'dart:math';

import '../../domain/entities/product.dart';
import '../dtos/product_dto.dart';
import '../dtos/product_variant_dto.dart';

extension ProductDtoX on ProductDto {
  /// [imageUrls] are resolved from Storage references by the repository
  /// impl (§48: Storage owns the file, records own the reference).
  Product toDomain({List<String> imageUrls = const []}) {
    final variants = _visibleVariants();
    return Product(
      id: id,
      categoryId: categoryId,
      brandId: brandId,
      name: name,
      description: description,
      basePriceMinor: basePriceMinor,
      stock: stock,
      fromPriceMinor: _fromPriceMinor(variants),
      defaultVariantId: _defaultVariantId(variants),
      brandName: brand?.name ?? '',
      ratingAvg: reviews.firstOrNull?.ratingAvg,
      reviewCount: reviews.firstOrNull?.reviewCount ?? 0,
      createdAt: createdAt,
      status: ProductStatus.fromName(status),
      imageUrls: imageUrls,
    );
  }

  /// Customer-facing options: active variants only. When at least one is
  /// priced, the null-price single-price placeholder is excluded — it is a
  /// base-price tracking row, not a selectable choice. A placeholder-only
  /// product keeps its sole row so add-to-cart can resolve a concrete
  /// variant id.
  List<ProductVariantPriceDto> _visibleVariants() {
    final active = productVariants
        .where(
          (variant) => variant.status == null || variant.status == 'active',
        )
        .toList();
    final priced = active
        .where((variant) => variant.priceMinor != null)
        .toList();
    return priced.isNotEmpty ? priced : active;
  }

  /// Cheapest visible price; the null-price placeholder falls back to the
  /// product's base price.
  int _fromPriceMinor(List<ProductVariantPriceDto> variants) {
    if (variants.isEmpty) return basePriceMinor;
    return variants
        .map((variant) => variant.priceMinor ?? basePriceMinor)
        .reduce(min);
  }

  /// The variant the quick-add and detail page default to: cheapest visible
  /// option, with the id as a deterministic tie-break. This matches the
  /// card's "from" price instead of relying on PostgREST's row order.
  String? _defaultVariantId(List<ProductVariantPriceDto> variants) {
    ProductVariantPriceDto? best;
    for (final variant in variants) {
      if (best == null) {
        best = variant;
        continue;
      }
      final price = variant.priceMinor ?? basePriceMinor;
      final bestPrice = best.priceMinor ?? basePriceMinor;
      final cheaper = price < bestPrice;
      final tie =
          price == bestPrice && (variant.id ?? '').compareTo(best.id ?? '') < 0;
      if (cheaper || tie) best = variant;
    }
    return best?.id;
  }
}
