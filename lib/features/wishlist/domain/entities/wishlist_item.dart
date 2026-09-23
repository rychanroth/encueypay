/// A wishlisted product with display data joined server-side (spec §38).
class WishlistItem {
  const WishlistItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.priceMinor,
    this.imageUrl,
  });

  final String id;
  final String productId;
  final String productName;
  final int priceMinor;
  final String? imageUrl;
}
