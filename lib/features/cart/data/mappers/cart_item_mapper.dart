import '../../domain/entities/cart_item.dart';
import '../dtos/cart_item_dto.dart';

extension CartItemDtoX on CartItemDto {
  /// Null defaults live here — never in the UI (DATA-02).
  CartItem toDomain({String? imageUrl}) {
    return CartItem(
      id: id,
      variantId: variantId,
      productId: productId,
      productName: productName,
      variantName: variantName,
      unitPriceMinor: unitPriceMinor,
      saleUnitPriceMinor: saleUnitPriceMinor,
      quantity: quantity,
      stock: stock,
      imageUrl: imageUrl,
      createdAt: createdAt,
      brandId: brandId,
      categoryId: categoryId,
    );
  }
}
