// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Paginated "my orders" list. Plain one-shot fetches consumed directly
/// (DOMAIN-03).

@ProviderFor(OrdersController)
final ordersControllerProvider = OrdersControllerProvider._();

/// Paginated "my orders" list. Plain one-shot fetches consumed directly
/// (DOMAIN-03).
final class OrdersControllerProvider
    extends $AsyncNotifierProvider<OrdersController, List<CustomerOrder>> {
  /// Paginated "my orders" list. Plain one-shot fetches consumed directly
  /// (DOMAIN-03).
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

String _$ordersControllerHash() => r'd881d9fcc361e1e04550ab7044efc18d1a9f62ea';

/// Paginated "my orders" list. Plain one-shot fetches consumed directly
/// (DOMAIN-03).

abstract class _$OrdersController extends $AsyncNotifier<List<CustomerOrder>> {
  FutureOr<List<CustomerOrder>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<CustomerOrder>>, List<CustomerOrder>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<CustomerOrder>>, List<CustomerOrder>>,
              AsyncValue<List<CustomerOrder>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
