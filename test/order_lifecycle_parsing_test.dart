import 'package:flutter_test/flutter_test.dart';

import 'package:encueypay/features/admin/domain/entities/admin.dart';
import 'package:encueypay/features/orders/domain/entities/order.dart';

/// Pins the lifecycle/payment enum parsers to the WIRE vocabulary
/// (snake_case: 'out_for_delivery', 'bank_transfer',
/// 'awaiting_payment_verification'…). The parsers matched enum `.name`
/// (camelCase) only, so every multi-word wire value collapsed to the
/// fallback — the admin UI then offered 'out_for_delivery → confirmed'
/// ("Move to confirmed" on a pending-misparsed order), which the server
/// rightly rejected.
void main() {
  group('AdminOrderStatus.fromName', () {
    test('parses snake_case wire values', () {
      expect(AdminOrderStatus.fromName('out_for_delivery'),
          AdminOrderStatus.outForDelivery);
      expect(AdminOrderStatus.fromName('pending'), AdminOrderStatus.pending);
    });

    test('out_for_delivery offers "delivered" next (the reported path)', () {
      final status = AdminOrderStatus.fromName('out_for_delivery');
      final order = _summaryWith(status);
      expect(order.nextTransition, AdminOrderStatus.delivered);
    });

    test('terminal statuses offer nothing', () {
      expect(
          _summaryWith(AdminOrderStatus.fromName('delivered')).nextTransition,
          isNull);
      expect(
          _summaryWith(AdminOrderStatus.fromName('cancelled')).nextTransition,
          isNull);
    });

    test('unknown falls back to pending', () {
      expect(AdminOrderStatus.fromName('nonsense'), AdminOrderStatus.pending);
      expect(AdminOrderStatus.fromName(null), AdminOrderStatus.pending);
    });
  });

  group('customer OrderStatus.fromName', () {
    test('parses snake_case wire values', () {
      expect(OrderStatus.fromName('out_for_delivery'),
          OrderStatus.outForDelivery);
      expect(OrderStatus.fromName('returned'), OrderStatus.returned);
    });
  });

  group('PaymentMethodKind.fromName', () {
    test('parses bank_transfer', () {
      expect(PaymentMethodKind.fromName('bank_transfer'),
          PaymentMethodKind.bankTransfer);
      expect(PaymentMethodKind.fromName('cod'), PaymentMethodKind.cod);
      expect(PaymentMethodKind.fromName('qr'), PaymentMethodKind.qr);
    });
  });

  group('PaymentStatusState.fromName', () {
    test('parses snake_case wire values', () {
      expect(PaymentStatusState.fromName('awaiting_payment_verification'),
          PaymentStatusState.awaitingPaymentVerification);
      expect(PaymentStatusState.fromName('transaction_verified'),
          PaymentStatusState.transactionVerified);
      expect(PaymentStatusState.fromName('refund_required'),
          PaymentStatusState.refundRequired);
      expect(
          PaymentStatusState.fromName('refunded'), PaymentStatusState.refunded);
    });
  });
}

AdminOrderSummary _summaryWith(AdminOrderStatus status) => AdminOrderSummary(
      id: 'test',
      customerName: 'Test',
      subtotalMinor: 0,
      discountMinor: 0,
      deliveryFeeMinor: 0,
      totalMinor: 0,
      createdAt: DateTime(2026),
      status: status,
    );
