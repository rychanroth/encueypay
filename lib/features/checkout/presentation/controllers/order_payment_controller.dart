import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/khqr_generator.dart';
import '../../data/repository/checkout_repository_impl.dart';
import '../../domain/entities/order_payment.dart';

part 'order_payment_controller.g.dart';

/// The order's payment lifecycle on the order-success screen (Section 6b):
/// realtime ground truth from the `payments` stream, KHQR registration on
/// first build, and the Bakong confirmation poll. Confirmation paths
/// (webhook / poller / admin simulation) all flip the row server-side;
/// realtime pushes the change here — no optimistic UI.
@riverpod
class OrderPaymentController extends _$OrderPaymentController {
  @override
  Stream<OrderPayment> build(String orderId) {
    final repository = ref.watch(checkoutRepositoryProvider);
    return repository.streamOrderPayment(orderId).map((row) {
      if (row == null) {
        throw StateError('Payment not found');
      }
      return OrderPayment(
        status: (row['status'] as String?) ?? 'pending',
        method: (row['method'] as String?) ?? 'cod',
        amountMinor: (row['amount_minor'] as int?) ?? 0,
        qrPayload: row['qr_payload'] as String?,
        transactionReference: row['transaction_reference'] as String?,
      );
    });
  }

  /// Generates the KHQR payload and registers it against the pending
  /// payment. Idempotent: registration only succeeds while the payment is
  /// pending and unregistered (server guard). The MD5 transaction key is
  /// computed server-side from the payload (never trusted from the client).
  Future<void> ensureQrRegistered({
    required String qrAccountId,
    required String merchantName,
  }) async {
    // Riverpod 3: AsyncValue.value is the nullable current value.
    final payment = state.value;
    if (payment == null || !payment.isPendingQr || payment.qrPayload != null) {
      return;
    }
    if (qrAccountId.isEmpty) return; // QR unconfigured — surfaced by UI.
    final payload = KhqrGenerator.build(
      accountId: qrAccountId,
      merchantName: merchantName,
      amountMinor: payment.amountMinor,
      billNumber: orderId.substring(0, 8).toUpperCase(),
    );
    await ref
        .read(checkoutRepositoryProvider)
        .registerQrPayment(orderId: orderId, payload: payload);
  }

  /// Asks the bakong-check Edge Function to confirm the transaction (the
  /// Bakong path — polling, not push). Returns null when the function is
  /// not configured/running.
  Future<bool?> pollBakong() {
    return ref.read(checkoutRepositoryProvider).checkBakongPayment(orderId);
  }
}
