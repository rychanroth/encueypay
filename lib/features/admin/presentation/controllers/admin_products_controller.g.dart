// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_products_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Applied filter/sort state for the Products tab (PRES-02). Kept separate
/// from the list controller so the screen (and the URL codec) own one source
/// of truth and changing a filter rebuilds exactly one fetch.

@ProviderFor(AdminProductsQueryController)
final adminProductsQueryControllerProvider =
    AdminProductsQueryControllerProvider._();

/// Applied filter/sort state for the Products tab (PRES-02). Kept separate
/// from the list controller so the screen (and the URL codec) own one source
/// of truth and changing a filter rebuilds exactly one fetch.
final class AdminProductsQueryControllerProvider
    extends $NotifierProvider<AdminProductsQueryController, AdminProductQuery> {
  /// Applied filter/sort state for the Products tab (PRES-02). Kept separate
  /// from the list controller so the screen (and the URL codec) own one source
  /// of truth and changing a filter rebuilds exactly one fetch.
  AdminProductsQueryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminProductsQueryControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminProductsQueryControllerHash();

  @$internal
  @override
  AdminProductsQueryController create() => AdminProductsQueryController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminProductQuery value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminProductQuery>(value),
    );
  }
}

String _$adminProductsQueryControllerHash() =>
    r'18647f885f4232548279a8f140b88a882fee6fa3';

/// Applied filter/sort state for the Products tab (PRES-02). Kept separate
/// from the list controller so the screen (and the URL codec) own one source
/// of truth and changing a filter rebuilds exactly one fetch.

abstract class _$AdminProductsQueryController
    extends $Notifier<AdminProductQuery> {
  AdminProductQuery build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AdminProductQuery, AdminProductQuery>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AdminProductQuery, AdminProductQuery>,
              AdminProductQuery,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Admin product catalog (Section 2b, spec §8 "manages Products"):
/// server-side filtered/sorted/paginated search over every status, with the
/// draft mutations backing the product form.

@ProviderFor(AdminProductsController)
final adminProductsControllerProvider = AdminProductsControllerProvider._();

/// Admin product catalog (Section 2b, spec §8 "manages Products"):
/// server-side filtered/sorted/paginated search over every status, with the
/// draft mutations backing the product form.
final class AdminProductsControllerProvider
    extends
        $AsyncNotifierProvider<AdminProductsController, AdminProductsState> {
  /// Admin product catalog (Section 2b, spec §8 "manages Products"):
  /// server-side filtered/sorted/paginated search over every status, with the
  /// draft mutations backing the product form.
  AdminProductsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminProductsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminProductsControllerHash();

  @$internal
  @override
  AdminProductsController create() => AdminProductsController();
}

String _$adminProductsControllerHash() =>
    r'08f196dbfa04fb62aa1e18037ed7d780de9572b3';

/// Admin product catalog (Section 2b, spec §8 "manages Products"):
/// server-side filtered/sorted/paginated search over every status, with the
/// draft mutations backing the product form.

abstract class _$AdminProductsController
    extends $AsyncNotifier<AdminProductsState> {
  FutureOr<AdminProductsState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<AdminProductsState>, AdminProductsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AdminProductsState>, AdminProductsState>,
              AsyncValue<AdminProductsState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
