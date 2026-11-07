// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_orders_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Admin order oversight + fulfillment (Section 3, spec §8 "manages
/// Orders"): the admin drives the single lifecycle one step at a time
/// (server-enforced) while the operator portals are bypassed. Mutations
/// persist-then-invalidate (PRES-03); order/payment changes from any source
/// refetch the feed, and the customer keeps receiving trigger-generated
/// status notifications.

@ProviderFor(AdminOrdersController)
final adminOrdersControllerProvider = AdminOrdersControllerProvider._();

/// Admin order oversight + fulfillment (Section 3, spec §8 "manages
/// Orders"): the admin drives the single lifecycle one step at a time
/// (server-enforced) while the operator portals are bypassed. Mutations
/// persist-then-invalidate (PRES-03); order/payment changes from any source
/// refetch the feed, and the customer keeps receiving trigger-generated
/// status notifications.
final class AdminOrdersControllerProvider
    extends
        $AsyncNotifierProvider<AdminOrdersController, List<AdminOrderSummary>> {
  /// Admin order oversight + fulfillment (Section 3, spec §8 "manages
  /// Orders"): the admin drives the single lifecycle one step at a time
  /// (server-enforced) while the operator portals are bypassed. Mutations
  /// persist-then-invalidate (PRES-03); order/payment changes from any source
  /// refetch the feed, and the customer keeps receiving trigger-generated
  /// status notifications.
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
    r'fe6b5e6d82a981487b51fcd509c9363aef757e8a';

/// Admin order oversight + fulfillment (Section 3, spec §8 "manages
/// Orders"): the admin drives the single lifecycle one step at a time
/// (server-enforced) while the operator portals are bypassed. Mutations
/// persist-then-invalidate (PRES-03); order/payment changes from any source
/// refetch the feed, and the customer keeps receiving trigger-generated
/// status notifications.

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
