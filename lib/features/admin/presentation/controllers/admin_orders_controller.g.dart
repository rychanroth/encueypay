// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_orders_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Applied filter/sort state for the Orders tab. Kept separate from the list
/// controller so the screen (and the URL codec) own one source of truth and
/// changing a filter rebuilds exactly one fetch.

@ProviderFor(AdminOrdersQueryController)
final adminOrdersQueryControllerProvider =
    AdminOrdersQueryControllerProvider._();

/// Applied filter/sort state for the Orders tab. Kept separate from the list
/// controller so the screen (and the URL codec) own one source of truth and
/// changing a filter rebuilds exactly one fetch.
final class AdminOrdersQueryControllerProvider
    extends $NotifierProvider<AdminOrdersQueryController, AdminOrderQuery> {
  /// Applied filter/sort state for the Orders tab. Kept separate from the list
  /// controller so the screen (and the URL codec) own one source of truth and
  /// changing a filter rebuilds exactly one fetch.
  AdminOrdersQueryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminOrdersQueryControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminOrdersQueryControllerHash();

  @$internal
  @override
  AdminOrdersQueryController create() => AdminOrdersQueryController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminOrderQuery value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminOrderQuery>(value),
    );
  }
}

String _$adminOrdersQueryControllerHash() =>
    r'761ce645482ae71cc216b376e2c9a3e98c9abe75';

/// Applied filter/sort state for the Orders tab. Kept separate from the list
/// controller so the screen (and the URL codec) own one source of truth and
/// changing a filter rebuilds exactly one fetch.

abstract class _$AdminOrdersQueryController extends $Notifier<AdminOrderQuery> {
  AdminOrderQuery build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AdminOrderQuery, AdminOrderQuery>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AdminOrderQuery, AdminOrderQuery>,
              AdminOrderQuery,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Admin order oversight + fulfillment (Section 3, spec §8 "manages
/// Orders"): the admin drives the single lifecycle one step at a time
/// (server-enforced). Mutations persist-then-invalidate (PRES-03); order/
/// payment changes from any source refetch the feed, and the customer keeps
/// receiving trigger-generated status notifications.

@ProviderFor(AdminOrdersController)
final adminOrdersControllerProvider = AdminOrdersControllerProvider._();

/// Admin order oversight + fulfillment (Section 3, spec §8 "manages
/// Orders"): the admin drives the single lifecycle one step at a time
/// (server-enforced). Mutations persist-then-invalidate (PRES-03); order/
/// payment changes from any source refetch the feed, and the customer keeps
/// receiving trigger-generated status notifications.
final class AdminOrdersControllerProvider
    extends $AsyncNotifierProvider<AdminOrdersController, AdminOrdersState> {
  /// Admin order oversight + fulfillment (Section 3, spec §8 "manages
  /// Orders"): the admin drives the single lifecycle one step at a time
  /// (server-enforced). Mutations persist-then-invalidate (PRES-03); order/
  /// payment changes from any source refetch the feed, and the customer keeps
  /// receiving trigger-generated status notifications.
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
    r'6719d7776bcd9cc8c4eab2794c824e0e7f02f218';

/// Admin order oversight + fulfillment (Section 3, spec §8 "manages
/// Orders"): the admin drives the single lifecycle one step at a time
/// (server-enforced). Mutations persist-then-invalidate (PRES-03); order/
/// payment changes from any source refetch the feed, and the customer keeps
/// receiving trigger-generated status notifications.

abstract class _$AdminOrdersController
    extends $AsyncNotifier<AdminOrdersState> {
  FutureOr<AdminOrdersState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<AdminOrdersState>, AdminOrdersState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AdminOrdersState>, AdminOrdersState>,
              AsyncValue<AdminOrdersState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// One order, fetched by id. The detail screen uses this instead of the list
/// state so an active filter or a page boundary cannot make it disappear.

@ProviderFor(AdminOrderDetailController)
final adminOrderDetailControllerProvider = AdminOrderDetailControllerFamily._();

/// One order, fetched by id. The detail screen uses this instead of the list
/// state so an active filter or a page boundary cannot make it disappear.
final class AdminOrderDetailControllerProvider
    extends
        $AsyncNotifierProvider<AdminOrderDetailController, AdminOrderSummary> {
  /// One order, fetched by id. The detail screen uses this instead of the list
  /// state so an active filter or a page boundary cannot make it disappear.
  AdminOrderDetailControllerProvider._({
    required AdminOrderDetailControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'adminOrderDetailControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$adminOrderDetailControllerHash();

  @override
  String toString() {
    return r'adminOrderDetailControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AdminOrderDetailController create() => AdminOrderDetailController();

  @override
  bool operator ==(Object other) {
    return other is AdminOrderDetailControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$adminOrderDetailControllerHash() =>
    r'73a5c279b24ad390863ac57556551ba33ea4ca52';

/// One order, fetched by id. The detail screen uses this instead of the list
/// state so an active filter or a page boundary cannot make it disappear.

final class AdminOrderDetailControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          AdminOrderDetailController,
          AsyncValue<AdminOrderSummary>,
          AdminOrderSummary,
          FutureOr<AdminOrderSummary>,
          String
        > {
  AdminOrderDetailControllerFamily._()
    : super(
        retry: null,
        name: r'adminOrderDetailControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One order, fetched by id. The detail screen uses this instead of the list
  /// state so an active filter or a page boundary cannot make it disappear.

  AdminOrderDetailControllerProvider call(String orderId) =>
      AdminOrderDetailControllerProvider._(argument: orderId, from: this);

  @override
  String toString() => r'adminOrderDetailControllerProvider';
}

/// One order, fetched by id. The detail screen uses this instead of the list
/// state so an active filter or a page boundary cannot make it disappear.

abstract class _$AdminOrderDetailController
    extends $AsyncNotifier<AdminOrderSummary> {
  late final _$args = ref.$arg as String;
  String get orderId => _$args;

  FutureOr<AdminOrderSummary> build(String orderId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<AdminOrderSummary>, AdminOrderSummary>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AdminOrderSummary>, AdminOrderSummary>,
              AsyncValue<AdminOrderSummary>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
