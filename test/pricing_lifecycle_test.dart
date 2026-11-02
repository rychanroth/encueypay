import 'package:flutter_test/flutter_test.dart';

import 'package:encueypay/features/cart/domain/entities/cart_item.dart';
import 'package:encueypay/features/checkout/domain/entities/checkout_summary.dart';
import 'package:encueypay/features/orders/domain/entities/order.dart';

CustomerOrder _order({required OrderStatus status, OrderPayment? payment}) {
  return CustomerOrder(
    id: 'order-1',
    createdAt: DateTime.utc(2026, 11, 2),
    status: status,
    subtotalMinor: 455,
    discountMinor: 0,
    deliveryFeeMinor: 0,
    totalMinor: 455,
    shippingRecipientName: 'Test',
    shippingLine1: 'Street',
    shippingCity: 'Phnom Penh',
    payment: payment,
  );
}

void main() {
  test('cart line uses the server sale price for its total', () {
    const item = CartItem(
      id: 'line-1',
      variantId: 'variant-1',
      productId: 'product-1',
      productName: 'Nike 3000 Air',
      unitPriceMinor: 455,
      saleUnitPriceMinor: 410,
      quantity: 2,
    );

    expect(item.hasSale, isTrue);
    expect(item.effectiveUnitPriceMinor, 410);
    expect(item.lineTotalMinor, 820);
  });

  test('checkout line uses the same server sale price', () {
    const item = CheckoutItem(
      id: 'line-1',
      productName: 'Nike 3000 Air',
      unitPriceMinor: 455,
      saleUnitPriceMinor: 410,
      quantity: 3,
    );

    expect(item.hasSale, isTrue);
    expect(item.lineTotalMinor, 1230);
  });

  test('unpaid QR order is labelled awaiting payment', () {
    final order = _order(
      status: OrderStatus.pending,
      payment: const OrderPayment(
        method: PaymentMethodKind.qr,
        status: PaymentStatusState.pending,
        amountMinor: 455,
      ),
    );

    expect(order.statusLabel, 'Awaiting payment');
  });

  test('verified QR payment is labelled payment received', () {
    final order = _order(
      status: OrderStatus.pending,
      payment: const OrderPayment(
        method: PaymentMethodKind.qr,
        status: PaymentStatusState.transactionVerified,
        amountMinor: 455,
      ),
    );

    expect(order.statusLabel, 'Payment received');
  });

  test('COD keeps the placed label', () {
    final order = _order(
      status: OrderStatus.pending,
      payment: const OrderPayment(
        method: PaymentMethodKind.cod,
        status: PaymentStatusState.pending,
        amountMinor: 455,
      ),
    );

    expect(order.statusLabel, 'Order placed');
  });
}
