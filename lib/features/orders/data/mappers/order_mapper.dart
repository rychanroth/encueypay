import '../../domain/entities/order.dart';
import '../dtos/order_dtos.dart';

extension OrderDtoX on OrderDto {
  CustomerOrder toDomain() {
    return CustomerOrder(
      id: id,
      createdAt: createdAt,
      status: OrderStatus.fromName(status),
      subtotalMinor: subtotalMinor,
      discountMinor: discountMinor,
      deliveryFeeMinor: deliveryFeeMinor,
      totalMinor: totalMinor,
      shippingRecipientName: shippingRecipientName,
      shippingPhone: shippingPhone,
      shippingLine1: shippingLine1,
      shippingLine2: shippingLine2,
      shippingCity: shippingCity,
      note: note ?? '',
      cancellationReason: cancellationReason ?? '',
      items: items.map((item) => item.toDomain()).toList(),
      returns: returnRequests
          .map((request) => ReturnRequestInfo(
                id: request.id,
                status: ReturnStatus.fromName(request.status),
                // Aggregate the per-line reasons into one display string.
                reason: request.returnItems
                    .map((item) => item.reason)
                    .where((reason) => reason.isNotEmpty)
                    .join(' · '),
              ))
          .toList(),
      payment: payments == null
          ? null
          : OrderPayment(
              method: PaymentMethodKind.fromName(payments!.method),
              status: PaymentStatusState.fromName(payments!.status),
              amountMinor: payments!.amountMinor ?? 0,
            ),
    );
  }
}

extension OrderItemJoinDtoX on OrderItemJoinDto {
  OrderItemSnapshot toDomain() {
    return OrderItemSnapshot(
      id: id,
      productName: productName,
      variantName: variantName,
      unitPriceMinor: unitPriceMinor,
      discountMinor: discountMinor ?? 0,
      quantity: quantity,
      lineTotalMinor: lineTotalMinor,
      businessName: businessName ?? '',
    );
  }
}
