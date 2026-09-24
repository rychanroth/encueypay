import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'product.dart';
import 'product_variant.dart';

part 'product_detail.freezed.dart';

/// Composite read model for the product detail screen: the product, its
/// variants, enough business identity for display (spec §18), and the
/// product's reviews (read path; submission lives in the reviews feature).
@freezed
abstract class ProductDetail with _$ProductDetail {
  const factory ProductDetail({
    required Product product,
    required List<ProductVariant> variants,
    @Default('') String businessName,
    @Default([]) List<ProductReviewInfo> reviews,
  }) = _ProductDetail;

  const ProductDetail._();

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
@freezed
abstract class ProductReviewInfo with _$ProductReviewInfo {
  const factory ProductReviewInfo({
    required String authorName,
    required int rating,
    @Default('') String text,
    required DateTime createdAt,
  }) = _ProductReviewInfo;
}
