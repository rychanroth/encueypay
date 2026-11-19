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
    r'4d2138ca3569eec58d44b00a0f3161e86668597e';

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

/// Server-logged lifecycle transitions for the detail screen's exact-status
/// timeline. Depends on the order provider so a realtime status change
/// refreshes the timestamps together with the order.

@ProviderFor(OrderStatusHistoryController)
final orderStatusHistoryControllerProvider =
    OrderStatusHistoryControllerFamily._();

/// Server-logged lifecycle transitions for the detail screen's exact-status
/// timeline. Depends on the order provider so a realtime status change
/// refreshes the timestamps together with the order.
final class OrderStatusHistoryControllerProvider
    extends
        $AsyncNotifierProvider<
          OrderStatusHistoryController,
          List<OrderStatusEvent>
        > {
  /// Server-logged lifecycle transitions for the detail screen's exact-status
  /// timeline. Depends on the order provider so a realtime status change
  /// refreshes the timestamps together with the order.
  OrderStatusHistoryControllerProvider._({
    required OrderStatusHistoryControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'orderStatusHistoryControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$orderStatusHistoryControllerHash();

  @override
  String toString() {
    return r'orderStatusHistoryControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  OrderStatusHistoryController create() => OrderStatusHistoryController();

  @override
  bool operator ==(Object other) {
    return other is OrderStatusHistoryControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$orderStatusHistoryControllerHash() =>
    r'e0739d76c17390da549c38e50cede831dd78bc7a';

/// Server-logged lifecycle transitions for the detail screen's exact-status
/// timeline. Depends on the order provider so a realtime status change
/// refreshes the timestamps together with the order.

final class OrderStatusHistoryControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          OrderStatusHistoryController,
          AsyncValue<List<OrderStatusEvent>>,
          List<OrderStatusEvent>,
          FutureOr<List<OrderStatusEvent>>,
          String
        > {
  OrderStatusHistoryControllerFamily._()
    : super(
        retry: null,
        name: r'orderStatusHistoryControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Server-logged lifecycle transitions for the detail screen's exact-status
  /// timeline. Depends on the order provider so a realtime status change
  /// refreshes the timestamps together with the order.

  OrderStatusHistoryControllerProvider call(String orderId) =>
      OrderStatusHistoryControllerProvider._(argument: orderId, from: this);

  @override
  String toString() => r'orderStatusHistoryControllerProvider';
}

/// Server-logged lifecycle transitions for the detail screen's exact-status
/// timeline. Depends on the order provider so a realtime status change
/// refreshes the timestamps together with the order.

abstract class _$OrderStatusHistoryController
    extends $AsyncNotifier<List<OrderStatusEvent>> {
  late final _$args = ref.$arg as String;
  String get orderId => _$args;

  FutureOr<List<OrderStatusEvent>> build(String orderId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<OrderStatusEvent>>, List<OrderStatusEvent>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<OrderStatusEvent>>,
                List<OrderStatusEvent>
              >,
              AsyncValue<List<OrderStatusEvent>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// Transient action failure for one order detail screen. Kept separate from
/// the order AsyncValue so a failed cancel/upload never wipes the order.

@ProviderFor(OrderActionError)
final orderActionErrorProvider = OrderActionErrorFamily._();

/// Transient action failure for one order detail screen. Kept separate from
/// the order AsyncValue so a failed cancel/upload never wipes the order.
final class OrderActionErrorProvider
    extends $NotifierProvider<OrderActionError, String?> {
  /// Transient action failure for one order detail screen. Kept separate from
  /// the order AsyncValue so a failed cancel/upload never wipes the order.
  OrderActionErrorProvider._({
    required OrderActionErrorFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'orderActionErrorProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$orderActionErrorHash();

  @override
  String toString() {
    return r'orderActionErrorProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  OrderActionError create() => OrderActionError();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is OrderActionErrorProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$orderActionErrorHash() => r'10c3dd0baedd89d0a8df7f99400a7639fcc26e2e';

/// Transient action failure for one order detail screen. Kept separate from
/// the order AsyncValue so a failed cancel/upload never wipes the order.

final class OrderActionErrorFamily extends $Family
    with
        $ClassFamilyOverride<
          OrderActionError,
          String?,
          String?,
          String?,
          String
        > {
  OrderActionErrorFamily._()
    : super(
        retry: null,
        name: r'orderActionErrorProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Transient action failure for one order detail screen. Kept separate from
  /// the order AsyncValue so a failed cancel/upload never wipes the order.

  OrderActionErrorProvider call(String orderId) =>
      OrderActionErrorProvider._(argument: orderId, from: this);

  @override
  String toString() => r'orderActionErrorProvider';
}

/// Transient action failure for one order detail screen. Kept separate from
/// the order AsyncValue so a failed cancel/upload never wipes the order.

abstract class _$OrderActionError extends $Notifier<String?> {
  late final _$args = ref.$arg as String;
  String get orderId => _$args;

  String? build(String orderId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
