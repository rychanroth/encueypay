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

  /// Creates the PayWay transaction for this order's pending QR payment.
  ///
  /// Reads the payment row directly instead of trusting [state]: the
  /// screen fires this once from a post-frame callback, which lands while
  /// the provider's initial fetch is still in flight — a state.value
  /// guard would silently bail there, and with the one-shot call the QR
  /// would never be created (endless buffering).
  Future<void> ensureQrRegistered() async {
    final repository = ref.read(checkoutRepositoryProvider);
    final row = await repository.fetchOrderPayment(orderId);
    if (row == null) return;
    final status = (row['status'] as String?) ?? 'pending';
    final method = (row['method'] as String?) ?? 'cod';
    if (method != 'qr' || status != 'pending' || row['qr_payload'] != null) {
      return;
    }
    await repository.createPaywayQr(orderId: orderId);
  }
}
