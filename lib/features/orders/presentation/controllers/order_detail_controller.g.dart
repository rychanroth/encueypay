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
    r'3cb6eba6058eca03d915fbb8a467d88a376108b5';

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
