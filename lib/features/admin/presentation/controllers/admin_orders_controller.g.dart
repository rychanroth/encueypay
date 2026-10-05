// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_orders_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Admin order oversight + fulfillment (Section 3, spec §8 "manages
/// Orders"): the admin drives the per-business lifecycle and completes the
/// delivery administratively while the operator portals are bypassed
/// (ledger L-07). Mutations persist-then-invalidate (PRES-03); the customer
/// keeps receiving trigger-generated status notifications.

@ProviderFor(AdminOrdersController)
final adminOrdersControllerProvider = AdminOrdersControllerProvider._();

/// Admin order oversight + fulfillment (Section 3, spec §8 "manages
/// Orders"): the admin drives the per-business lifecycle and completes the
/// delivery administratively while the operator portals are bypassed
/// (ledger L-07). Mutations persist-then-invalidate (PRES-03); the customer
/// keeps receiving trigger-generated status notifications.
final class AdminOrdersControllerProvider
    extends
        $AsyncNotifierProvider<AdminOrdersController, List<AdminOrderSummary>> {
  /// Admin order oversight + fulfillment (Section 3, spec §8 "manages
  /// Orders"): the admin drives the per-business lifecycle and completes the
  /// delivery administratively while the operator portals are bypassed
  /// (ledger L-07). Mutations persist-then-invalidate (PRES-03); the customer
  /// keeps receiving trigger-generated status notifications.
  AdminOrdersControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminOrdersControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminOrdersControllerHash();

  @$internal
  @override
  AdminOrdersController create() => AdminOrdersController();
}

String _$adminOrdersControllerHash() =>
    r'bdd95c98acab429dd570dfee3cb2efd37391f147';

/// Admin order oversight + fulfillment (Section 3, spec §8 "manages
/// Orders"): the admin drives the per-business lifecycle and completes the
/// delivery administratively while the operator portals are bypassed
/// (ledger L-07). Mutations persist-then-invalidate (PRES-03); the customer
/// keeps receiving trigger-generated status notifications.

abstract class _$AdminOrdersController
    extends $AsyncNotifier<List<AdminOrderSummary>> {
  FutureOr<List<AdminOrderSummary>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<AdminOrderSummary>>,
              List<AdminOrderSummary>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<AdminOrderSummary>>,
                List<AdminOrderSummary>
              >,
              AsyncValue<List<AdminOrderSummary>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
