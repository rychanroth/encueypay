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

  /// Customer-facing options: active variants only. Archived rows stay in
  /// the table for order history and are never selectable. There is no
  /// placeholder filtering — a business-authored "Default" variant is a
  /// normal option.
  List<ProductVariantPriceDto> _visibleVariants() {
    return productVariants
        .where(
          (variant) => variant.status == null || variant.status == 'active',
        )
        .toList();
  }

  /// Cheapest visible price. The base price is only a defensive fallback for
  /// a product with no active variant (the server requires at least one).
  int _fromPriceMinor(List<ProductVariantPriceDto> variants) {
    if (variants.isEmpty) return basePriceMinor;
    return variants.map((variant) => variant.priceMinor).reduce(min);
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
      final price = variant.priceMinor;
      final bestPrice = best.priceMinor;
      final cheaper = price < bestPrice;
      final tie =
          price == bestPrice && (variant.id ?? '').compareTo(best.id ?? '') < 0;
      if (cheaper || tie) best = variant;
    }
    return best?.id;
  }
}
