// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_filter_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Search/filter/sort state for the cart list (PRES-02). Presentation-only —
/// the repository and RPCs never see it.

@ProviderFor(CartFilterController)
final cartFilterControllerProvider = CartFilterControllerProvider._();

/// Search/filter/sort state for the cart list (PRES-02). Presentation-only —
/// the repository and RPCs never see it.
final class CartFilterControllerProvider
    extends $NotifierProvider<CartFilterController, CartFilterState> {
  /// Search/filter/sort state for the cart list (PRES-02). Presentation-only —
  /// the repository and RPCs never see it.
  CartFilterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartFilterControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartFilterControllerHash();

  @$internal
  @override
  CartFilterController create() => CartFilterController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CartFilterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CartFilterState>(value),
    );
  }
}

String _$cartFilterControllerHash() =>
    r'134422aa6d04a2a68f92cb192c971868c5a21c7d';

/// Search/filter/sort state for the cart list (PRES-02). Presentation-only —
/// the repository and RPCs never see it.

abstract class _$CartFilterController extends $Notifier<CartFilterState> {
  CartFilterState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CartFilterState, CartFilterState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CartFilterState, CartFilterState>,
              CartFilterState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
