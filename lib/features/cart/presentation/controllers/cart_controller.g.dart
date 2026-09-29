// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Cart state — server-authoritative contents (spec §8). Mutations persist
/// first, then refetch ground truth (PRES-03) — the client never applies
/// optimistic quantity changes.
///
/// Mutations may run while nothing listens (e.g. add-to-cart from the product
/// detail sheet): the autoDispose element is then disposed during the RPC
/// await, so afterwards `ref` is unmounted — the persisted mutation still
/// stands and the next listener (opening the cart tab) refetches fresh.

@ProviderFor(CartController)
final cartControllerProvider = CartControllerProvider._();

/// Cart state — server-authoritative contents (spec §8). Mutations persist
/// first, then refetch ground truth (PRES-03) — the client never applies
/// optimistic quantity changes.
///
/// Mutations may run while nothing listens (e.g. add-to-cart from the product
/// detail sheet): the autoDispose element is then disposed during the RPC
/// await, so afterwards `ref` is unmounted — the persisted mutation still
/// stands and the next listener (opening the cart tab) refetches fresh.
final class CartControllerProvider
    extends $AsyncNotifierProvider<CartController, List<CartItem>> {
  /// Cart state — server-authoritative contents (spec §8). Mutations persist
  /// first, then refetch ground truth (PRES-03) — the client never applies
  /// optimistic quantity changes.
  ///
  /// Mutations may run while nothing listens (e.g. add-to-cart from the product
  /// detail sheet): the autoDispose element is then disposed during the RPC
  /// await, so afterwards `ref` is unmounted — the persisted mutation still
  /// stands and the next listener (opening the cart tab) refetches fresh.
  CartControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartControllerHash();

  @$internal
  @override
  CartController create() => CartController();
}

String _$cartControllerHash() => r'28d7b5c345915c7effe4c475cbf84cf5b98aaeec';

/// Cart state — server-authoritative contents (spec §8). Mutations persist
/// first, then refetch ground truth (PRES-03) — the client never applies
/// optimistic quantity changes.
///
/// Mutations may run while nothing listens (e.g. add-to-cart from the product
/// detail sheet): the autoDispose element is then disposed during the RPC
/// await, so afterwards `ref` is unmounted — the persisted mutation still
/// stands and the next listener (opening the cart tab) refetches fresh.

abstract class _$CartController extends $AsyncNotifier<List<CartItem>> {
  FutureOr<List<CartItem>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<CartItem>>, List<CartItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<CartItem>>, List<CartItem>>,
              AsyncValue<List<CartItem>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
