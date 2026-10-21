import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/failure_mapping.dart';
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
/// QR creation writes the payload server-side, and without a delivery
/// path the screen would buffer forever. With the refetch merged in, the
/// screen converges no matter what Realtime does. Identical consecutive
/// states are dropped (freezed ==) so healthy-Realtime rebuilds stay
/// event-driven, not timer-driven.
///
/// Confirmation paths (PayWay webhook / admin simulation) all flip the
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

  /// Asks the payway-create Edge Function to create the PayWay transaction
  /// and register the returned KHQR on the pending payment. Idempotent at
  /// the call site (only fires while pending and unregistered) and on the
  /// server (stable tran_id, pending-guarded row update). Throws [Failure]
  /// — the screen surfaces it; the payload also reaches the UI through the
  /// stream because the function stores it server-side.
  Future<void> ensureQrRegistered() async {
    // Riverpod 3: AsyncValue.value is the nullable current value.
    final payment = state.value;
    if (payment == null || !payment.isPendingQr || payment.qrPayload != null) {
      return;
    }
    await ref
        .read(checkoutRepositoryProvider)
        .createPaywayQr(orderId: orderId);
  }
}
