import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

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
    // Realtime sync signals (§31/§54): order + delivery changes refetch.
    final subscriptions = <StreamSubscription<StreamResult<bool>>>[
      repository.watchOrderChanges(orderId).listen((result) {
        if (result is StreamData) ref.invalidateSelf();
      }),
      repository.watchDeliveryChanges(orderId).listen((result) {
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

  Future<void> cancelOrder() async {
    final current = state.value;
    if (current == null) return;
    state = await AsyncValue.guard(() async {
      await ref.read(ordersRepositoryProvider).cancelOrder(orderId);
      ref.invalidateSelf();
      return current;
    });
    // Keep the list consistent too.
    ref.invalidate(ordersControllerProvider);
  }

  Future<void> uploadProof({
    required String filePath,
    required String fileName,
  }) async {
    final current = state.value;
    if (current == null) return;
    state = await AsyncValue.guard(() async {
      await ref.read(ordersRepositoryProvider).submitPaymentProof(
            orderId: orderId,
            filePath: filePath,
            fileName: fileName,
          );
      ref.invalidateSelf();
      return current;
    });
  }
}
