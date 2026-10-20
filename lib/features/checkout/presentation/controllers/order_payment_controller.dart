import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/failure_mapping.dart';
import '../../data/khqr_generator.dart';
import '../../data/repository/checkout_repository_impl.dart';
import '../../domain/entities/order_payment.dart';

part 'order_payment_controller.g.dart';

/// The order's payment lifecycle on the order-success screen (Section 6b).
///
/// Two delivery paths feed ONE deduplicated stream:
///   * Supabase Realtime on the `payments` row (instant when healthy);
///   * a 3-second ground-truth REST refetch.
///
/// The refetch exists because Realtime can be unavailable in practice
/// (e.g. the websocket handshake 401s with a key the service rejects):
/// the registration writes the QR payload server-side, and without a
/// delivery path the screen would buffer forever. With the refetch merged
/// in, the screen converges no matter what Realtime does. Identical
/// consecutive states are dropped (freezed ==) so healthy-Realtime
/// rebuilds stay event-driven, not timer-driven.
///
/// Confirmation paths (webhook / poller / admin simulation) all flip the
/// row server-side — no optimistic UI.
@riverpod
class OrderPaymentController extends _$OrderPaymentController {
  @override
  Stream<OrderPayment> build(String orderId) async* {
    final repository = ref.watch(checkoutRepositoryProvider);
    OrderPayment mapRow(Map<String, dynamic>? row) {
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
    }

    // Immediate ground truth — covers the realtime-down case from the
    // first frame.
    yield mapRow(await repository.fetchOrderPayment(orderId));

    final controller = StreamController<OrderPayment>();
    OrderPayment? last;
    void push(OrderPayment payment) {
      // The registration refetch races the realtime event — dropping
      // identical consecutive states keeps rebuilds meaningful.
      if (payment == last) return;
      last = payment;
      controller.add(payment);
    }

    final subscription = repository
        .streamOrderPayment(orderId)
        .map(mapRow)
        .listen(push, onError: controller.addError);
    final refetchTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) async {
        try {
          push(mapRow(await repository.fetchOrderPayment(orderId)));
        } on Exception catch (error, stackTrace) {
          // Transient refetch failures keep the last state on screen —
          // the next tick retries.
          logSuppressedError(error, stackTrace);
        }
      },
    );
    ref.onDispose(() {
      refetchTimer.cancel();
      subscription.cancel();
      controller.close();
    });
    yield* controller.stream;
  }

  /// Generates the KHQR payload and registers it against the pending
  /// payment. Idempotent: registration only succeeds while the payment is
  /// pending and unregistered (server guard). The MD5 transaction key is
  /// computed server-side from the payload (never trusted from the client).
  Future<void> ensureQrRegistered({
    required String qrAccountId,
    required String merchantName,
    String accountInformation = '',
    String acquiringBank = '',
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
      accountInformation: accountInformation,
      acquiringBank: acquiringBank,
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
