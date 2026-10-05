// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Paginated "my orders" list with server-side history filters
/// (Section 7B: status group + date range). Changing a filter refetches
/// page 0; loadMore carries the active filter set.

@ProviderFor(OrdersController)
final ordersControllerProvider = OrdersControllerProvider._();

/// Paginated "my orders" list with server-side history filters
/// (Section 7B: status group + date range). Changing a filter refetches
/// page 0; loadMore carries the active filter set.
final class OrdersControllerProvider
    extends $AsyncNotifierProvider<OrdersController, OrderHistoryState> {
  /// Paginated "my orders" list with server-side history filters
  /// (Section 7B: status group + date range). Changing a filter refetches
  /// page 0; loadMore carries the active filter set.
  OrdersControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ordersControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ordersControllerHash();

  @$internal
  @override
  OrdersController create() => OrdersController();
}

String _$ordersControllerHash() => r'91160c5f251d713003ea661e4d45d5e8bfeab532';

/// Paginated "my orders" list with server-side history filters
/// (Section 7B: status group + date range). Changing a filter refetches
/// page 0; loadMore carries the active filter set.

abstract class _$OrdersController extends $AsyncNotifier<OrderHistoryState> {
  FutureOr<OrderHistoryState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<OrderHistoryState>, OrderHistoryState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<OrderHistoryState>, OrderHistoryState>,
              AsyncValue<OrderHistoryState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
