// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OrderDetailController)
final orderDetailControllerProvider = OrderDetailControllerFamily._();

final class OrderDetailControllerProvider
    extends $AsyncNotifierProvider<OrderDetailController, CustomerOrder> {
  OrderDetailControllerProvider._({
    required OrderDetailControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'orderDetailControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$orderDetailControllerHash();

  @override
  String toString() {
    return r'orderDetailControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  OrderDetailController create() => OrderDetailController();

  @override
  bool operator ==(Object other) {
    return other is OrderDetailControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$orderDetailControllerHash() =>
    r'fb1f7e93acb17a964260a89954fe83847f1baaa5';

final class OrderDetailControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          OrderDetailController,
          AsyncValue<CustomerOrder>,
          CustomerOrder,
          FutureOr<CustomerOrder>,
          String
        > {
  OrderDetailControllerFamily._()
    : super(
        retry: null,
        name: r'orderDetailControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  OrderDetailControllerProvider call(String orderId) =>
      OrderDetailControllerProvider._(argument: orderId, from: this);

  @override
  String toString() => r'orderDetailControllerProvider';
}

abstract class _$OrderDetailController extends $AsyncNotifier<CustomerOrder> {
  late final _$args = ref.$arg as String;
  String get orderId => _$args;

  FutureOr<CustomerOrder> build(String orderId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<CustomerOrder>, CustomerOrder>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CustomerOrder>, CustomerOrder>,
              AsyncValue<CustomerOrder>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
