import '../../domain/entities/return_request.dart';
import '../dtos/return_dtos.dart';

extension ReturnRequestDtoX on ReturnRequestDto {
  ReturnRequest toDomain() {
    return ReturnRequest(
      id: id,
      orderId: orderId,
      status: ReturnStatus.fromName(status),
      createdAt: createdAt,
      items: returnItems
          .map((item) => ReturnItemInfo(
                id: item.id,
                orderItemId: item.orderItemId,
                quantity: item.quantity,
                reason: item.reason,
                productName:
                    item.orderItems?.productName ?? 'Item',
              ))
          .toList(),
    );
  }
}

extension ReturnableItemDtoX on ReturnableItemDto {
  ReturnableItem toDomain() {
    return ReturnableItem(
      orderItemId: id,
      productName: productName,
      variantName: variantName,
      purchasedQuantity: quantity,
    );
  }
}
