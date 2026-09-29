import '../../domain/entities/order.dart';
import '../dtos/order_dtos.dart';

extension OrderDtoX on OrderDto {
  CustomerOrder toDomain() {
    return CustomerOrder(
      id: id,
      createdAt: createdAt,
      subtotalMinor: subtotalMinor,
      discountMinor: discountMinor,
      deliveryFeeMinor: deliveryFeeMinor,
      totalMinor: totalMinor,
      shippingRecipientName: shippingRecipientName,
      shippingPhone: shippingPhone,
      shippingLine1: shippingLine1,
      shippingLine2: shippingLine2,
      shippingCity: shippingCity,
      businessParts: businessOrders.map((bo) => bo.toDomain()).toList(),
      payment: payments == null
          ? null
          : OrderPayment(
              method: PaymentMethodKind.fromName(payments!.method),
              status: PaymentStatusState.fromName(payments!.status),
              amountMinor: payments!.amountMinor ?? 0,
            ),
      delivery: deliveries == null
          ? null
          : OrderDelivery(
              status: DeliveryState.fromName(deliveries!.status),
            ),
    );
  }
}

extension BusinessOrderJoinDtoX on BusinessOrderJoinDto {
  OrderBusinessPart toDomain() {
    return OrderBusinessPart(
      id: id,
      businessId: businessId,
      businessName: businesses?.name ?? 'Business',
      status: BusinessOrderStatus.fromName(status),
      rejectionReason: rejectionReason,
      items: orderItems.map((item) => item.toDomain()).toList(),
      pickupStop: pickupStops?.toDomain(),
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
    );
  }
}

extension PickupStopJoinDtoX on PickupStopJoinDto {
  PickupStopInfo toDomain() {
    return PickupStopInfo(
      id: id,
      sequence: sequence,
      status: PickupStopState.fromName(status),
    );
  }
}
