import 'product.dart';

/// A sellable variant of a product (spec §5.3). The variant is the selected
/// sellable unit in the cart where applicable. A variant price of `null`
/// falls back to the product's base price.
class ProductVariant {
  const ProductVariant({
    required this.id,
    required this.productId,
    required this.name,
    this.attributes,
    required this.priceMinor,
    required this.stock,
    required this.status,
  });

  final String id;
  final String productId;
  final String name;
  final Map<String, dynamic>? attributes;
  final int? priceMinor;
  final int stock;
  final ProductStatus status;

  int effectivePriceMinor(Product product) => priceMinor ?? product.basePriceMinor;
}
