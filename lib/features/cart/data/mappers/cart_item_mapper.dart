import '../../domain/entities/cart_item.dart';
import '../dtos/cart_item_dto.dart';

extension CartItemDtoX on CartItemDto {
  /// Null defaults live here — never in the UI (DATA-02). Unit price falls
  /// back variant → product base price.
  CartItem toDomain({String? imageUrl}) {
    final variant = productVariants;
    final product = variant?.products;
    return CartItem(
      id: id,
      variantId: variant?.id ?? '',
      productId: product?.id ?? '',
      productName: product?.name ?? 'Unknown product',
      variantName: variant?.name,
      unitPriceMinor: variant?.priceMinor ?? product?.basePriceMinor ?? 0,
      quantity: quantity,
      stock: variant?.stock ?? 0,
      businessId: product?.businesses?.id,
      businessName: product?.businesses?.name,
      imageUrl: imageUrl,
    );
  }
}
