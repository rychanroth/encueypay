// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Cart state — server-authoritative contents (spec §8). Mutations persist
/// first, then `ref.invalidateSelf()` refetches ground truth (PRES-03) —
/// the client never applies optimistic quantity changes.

@ProviderFor(CartController)
final cartControllerProvider = CartControllerProvider._();

/// Cart state — server-authoritative contents (spec §8). Mutations persist
/// first, then `ref.invalidateSelf()` refetches ground truth (PRES-03) —
/// the client never applies optimistic quantity changes.
final class CartControllerProvider
    extends $AsyncNotifierProvider<CartController, List<CartItem>> {
  /// Cart state — server-authoritative contents (spec §8). Mutations persist
  /// first, then `ref.invalidateSelf()` refetches ground truth (PRES-03) —
  /// the client never applies optimistic quantity changes.
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

String _$cartControllerHash() => r'75c9f5dfca0d0497377a1498b5c8abf8a57f7d73';

/// Cart state — server-authoritative contents (spec §8). Mutations persist
/// first, then `ref.invalidateSelf()` refetches ground truth (PRES-03) —
/// the client never applies optimistic quantity changes.

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
