import 'dart:math';

import 'product.dart';
import 'product_variant.dart';

/// Composite read model for the product detail screen: the product, its
/// variants, and enough business identity for display (spec §18).
class ProductDetail {
  const ProductDetail({
    required this.product,
    required this.variants,
    required this.businessName,
  });

  final Product product;
  final List<ProductVariant> variants;
  final String businessName;

  bool get hasVariants => variants.isNotEmpty;

  /// Cheapest selectable price — "from" price for display.
  int get fromPriceMinor => variants.isEmpty
      ? product.basePriceMinor
      : variants
          .map((v) => v.effectivePriceMinor(product))
          .reduce(min);
}
