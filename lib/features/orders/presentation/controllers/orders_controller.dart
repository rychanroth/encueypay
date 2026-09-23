import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/orders_repository_impl.dart';
import '../../domain/entities/order.dart';

part 'orders_controller.g.dart';

/// Paginated "my orders" list. Plain one-shot fetches consumed directly
/// (DOMAIN-03).
@riverpod
class OrdersController extends _$OrdersController {
  static const _pageSize = 10;

  @override
  Future<List<CustomerOrder>> build() async {
    return ref.watch(ordersRepositoryProvider).fetchMyOrders(limit: _pageSize);
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.length < _pageSize) return;
    if (state.isLoading || state.isRefreshing) return;
    state = await AsyncValue.guard(() async {
      final page = await ref
          .read(ordersRepositoryProvider)
          .fetchMyOrders(limit: _pageSize, offset: current.length);
      return [...current, ...page];
    });
  }
}
