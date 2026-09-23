/// A cart line with denormalized display data (product/variant/business)
/// joined server-side. Slim, purpose-shaped entity — features never import
/// each other (ARCH-04); the server stays authoritative for price/stock
/// (spec §8).
class CartItem {
  const CartItem({
    required this.id,
    required this.variantId,
    required this.productId,
    required this.productName,
    required this.unitPriceMinor,
    required this.quantity,
    required this.stock,
    this.variantName,
    this.businessId,
    this.businessName,
    this.imageUrl,
  });

  final String id;
  final String variantId;
  final String productId;
  final String productName;
  final String? variantName;

  /// Effective unit price: variant price, else product base price.
  final int unitPriceMinor;
  final int quantity;
  final int stock;
  final String? businessId;
  final String? businessName;
  final String? imageUrl;

  int get lineTotalMinor => unitPriceMinor * quantity;
}
