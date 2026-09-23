import 'dart:math';

import 'product.dart';
import 'product_variant.dart';

/// Composite read model for the product detail screen: the product, its
/// variants, enough business identity for display (spec §18), and the
/// product's reviews (read path; submission lives in the reviews feature).
class ProductDetail {
  const ProductDetail({
    required this.product,
    required this.variants,
    required this.businessName,
    this.reviews = const [],
  });

  final Product product;
  final List<ProductVariant> variants;
  final String businessName;
  final List<ProductReviewInfo> reviews;

  bool get hasVariants => variants.isNotEmpty;

  /// Cheapest selectable price — "from" price for display.
  int get fromPriceMinor => variants.isEmpty
      ? product.basePriceMinor
      : variants
          .map((v) => v.effectivePriceMinor(product))
          .reduce(min);

  double? get averageRating {
    if (reviews.isEmpty) return null;
    final sum = reviews.fold<int>(0, (total, review) => total + review.rating);
    return sum / reviews.length;
  }
}

/// Slim review display model (spec §29 display side).
class ProductReviewInfo {
  const ProductReviewInfo({
    required this.authorName,
    required this.rating,
    required this.text,
    required this.createdAt,
  });

  final String authorName;
  final int rating;
  final String text;
  final DateTime createdAt;
}
