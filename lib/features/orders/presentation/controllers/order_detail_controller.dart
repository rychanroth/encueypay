import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/picked_file.dart';
import '../../../../core/domain/stream_result.dart';
import '../../data/repository/orders_repository_impl.dart';
import '../../domain/entities/order.dart';
import 'orders_controller.dart';

part 'order_detail_controller.g.dart';

@riverpod
class OrderDetailController extends _$OrderDetailController {
  @override
  Future<CustomerOrder> build(String orderId) async {
    final repository = ref.watch(ordersRepositoryProvider);
    // Realtime sync signal (§31/§54): order changes (incl. status) refetch.
    // skipInitialSnapshot drops the subscription's initial row snapshot —
    // treating it as a change would invalidate → resubscribe → snapshot, a
    // permanent rebuild loop.
    final subscriptions = <StreamSubscription<StreamResult<bool>>>[
      repository.watchOrderChanges(orderId).skipInitialSnapshot().listen((
        result,
      ) {
        if (result is StreamData) ref.invalidateSelf();
      }),
    ];
    ref.onDispose(() {
      for (final subscription in subscriptions) {
        subscription.cancel();
      }
    });
    return repository.fetchOrder(orderId);
  }

  /// Cancels the order while keeping the order content on screen. Returns
  /// true on success; failures land in [OrderActionError] as a snackbar
  /// message instead of replacing the detail with an AsyncError.
  Future<bool> cancelOrder() async {
    if (state.value == null) return false;
    final result = await AsyncValue.guard(() async {
      await ref.read(ordersRepositoryProvider).cancelOrder(orderId);
      ref.invalidateSelf();
    });
    if (result.hasError) {
      ref
          .read(orderActionErrorProvider(orderId).notifier)
          .show(userMessageFor(result.error!));
      return false;
    }
    // Keep the list consistent too.
    ref.invalidate(ordersControllerProvider);
    return true;
  }

  Future<bool> uploadProof({required PickedFile proof}) async {
    if (state.value == null) return false;
    final result = await AsyncValue.guard(() async {
      await ref
          .read(ordersRepositoryProvider)
          .submitPaymentProof(orderId: orderId, proof: proof);
      ref.invalidateSelf();
    });
    if (result.hasError) {
      ref
          .read(orderActionErrorProvider(orderId).notifier)
          .show(userMessageFor(result.error!));
      return false;
    }
    return true;
  }
}

/// Transient action failure for one order detail screen. Kept separate from
/// the order AsyncValue so a failed cancel/upload never wipes the order.
@riverpod
class OrderActionError extends _$OrderActionError {
  @override
  String? build(String orderId) => null;

  void show(String message) => state = message;

  void clear() => state = null;
}
