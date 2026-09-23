import '../../domain/entities/product.dart';
import '../../domain/entities/product_variant.dart';
import '../../domain/entities/product_detail.dart';

/// Immutable state for the product detail screen (PRES-02). The selected
/// variant is UI-only state and lives here, not on the controller.
class ProductDetailState {
  const ProductDetailState({
    required this.detail,
    required this.relatedProducts,
    this.selectedVariantId,
  });

  final ProductDetail detail;
  final List<Product> relatedProducts;
  final String? selectedVariantId;

  ProductVariant? get selectedVariant {
    final id = selectedVariantId;
    if (id == null) return null;
    for (final variant in detail.variants) {
      if (variant.id == id) return variant;
    }
    return null;
  }

  ProductDetailState copyWith({String? selectedVariantId}) {
    return ProductDetailState(
      detail: detail,
      relatedProducts: relatedProducts,
      selectedVariantId: selectedVariantId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductDetailState &&
          other.detail.product.id == detail.product.id &&
          other.selectedVariantId == selectedVariantId;

  @override
  int get hashCode => Object.hash(detail.product.id, selectedVariantId);
}
