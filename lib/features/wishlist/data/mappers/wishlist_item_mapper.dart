import '../../domain/entities/wishlist_item.dart';
import '../dtos/wishlist_item_dto.dart';

extension WishlistItemDtoX on WishlistItemDto {
  WishlistItem toDomain({String? imageUrl}) {
    final product = products;
    return WishlistItem(
      id: id,
      productId: productId,
      productName: product?.name ?? 'Unknown product',
      priceMinor: product?.basePriceMinor ?? 0,
      stock: product?.stock ?? 0,
      status: product?.status,
      defaultVariantId: product?.productVariants.firstOrNull?.id,
      imageUrl: imageUrl,
    );
  }
}
