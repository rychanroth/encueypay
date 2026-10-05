// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_payment_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The order's payment lifecycle on the order-success screen (Section 6b):
/// realtime ground truth from the `payments` stream, KHQR registration on
/// first build, and the Bakong confirmation poll. Confirmation paths
/// (webhook / poller / admin simulation) all flip the row server-side;
/// realtime pushes the change here — no optimistic UI.

@ProviderFor(OrderPaymentController)
final orderPaymentControllerProvider = OrderPaymentControllerFamily._();

/// The order's payment lifecycle on the order-success screen (Section 6b):
/// realtime ground truth from the `payments` stream, KHQR registration on
/// first build, and the Bakong confirmation poll. Confirmation paths
/// (webhook / poller / admin simulation) all flip the row server-side;
/// realtime pushes the change here — no optimistic UI.
final class OrderPaymentControllerProvider
    extends $StreamNotifierProvider<OrderPaymentController, OrderPayment> {
  /// The order's payment lifecycle on the order-success screen (Section 6b):
  /// realtime ground truth from the `payments` stream, KHQR registration on
  /// first build, and the Bakong confirmation poll. Confirmation paths
  /// (webhook / poller / admin simulation) all flip the row server-side;
  /// realtime pushes the change here — no optimistic UI.
  OrderPaymentControllerProvider._({
    required OrderPaymentControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'orderPaymentControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$orderPaymentControllerHash();

  @override
  String toString() {
    return r'orderPaymentControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  OrderPaymentController create() => OrderPaymentController();

  @override
  bool operator ==(Object other) {
    return other is OrderPaymentControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$orderPaymentControllerHash() =>
    r'8f84e638a9f78e9d10c40cf7eab9149dc26ce1da';

/// The order's payment lifecycle on the order-success screen (Section 6b):
/// realtime ground truth from the `payments` stream, KHQR registration on
/// first build, and the Bakong confirmation poll. Confirmation paths
/// (webhook / poller / admin simulation) all flip the row server-side;
/// realtime pushes the change here — no optimistic UI.

final class OrderPaymentControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          OrderPaymentController,
          AsyncValue<OrderPayment>,
          OrderPayment,
          Stream<OrderPayment>,
          String
        > {
  OrderPaymentControllerFamily._()
    : super(
        retry: null,
        name: r'orderPaymentControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The order's payment lifecycle on the order-success screen (Section 6b):
  /// realtime ground truth from the `payments` stream, KHQR registration on
  /// first build, and the Bakong confirmation poll. Confirmation paths
  /// (webhook / poller / admin simulation) all flip the row server-side;
  /// realtime pushes the change here — no optimistic UI.

  OrderPaymentControllerProvider call(String orderId) =>
      OrderPaymentControllerProvider._(argument: orderId, from: this);

  @override
  String toString() => r'orderPaymentControllerProvider';
}

/// The order's payment lifecycle on the order-success screen (Section 6b):
/// realtime ground truth from the `payments` stream, KHQR registration on
/// first build, and the Bakong confirmation poll. Confirmation paths
/// (webhook / poller / admin simulation) all flip the row server-side;
/// realtime pushes the change here — no optimistic UI.

abstract class _$OrderPaymentController extends $StreamNotifier<OrderPayment> {
  late final _$args = ref.$arg as String;
  String get orderId => _$args;

  Stream<OrderPayment> build(String orderId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<OrderPayment>, OrderPayment>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<OrderPayment>, OrderPayment>,
              AsyncValue<OrderPayment>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
