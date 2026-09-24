import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/product.dart';
import '../../domain/entities/product_variant.dart';
import '../../domain/entities/product_detail.dart';

part 'product_detail_state.freezed.dart';

/// Immutable state for the product detail screen (PRES-02). The selected
/// variant is UI-only state and lives here, not on the controller.
@freezed
abstract class ProductDetailState with _$ProductDetailState {
  const factory ProductDetailState({
    required ProductDetail detail,
    @Default([]) List<Product> relatedProducts,
    String? selectedVariantId,
  }) = _ProductDetailState;

  const ProductDetailState._();

  ProductVariant? get selectedVariant {
    final id = selectedVariantId;
    if (id == null) return null;
    for (final variant in detail.variants) {
      if (variant.id == id) return variant;
    }
    return null;
  }
}
