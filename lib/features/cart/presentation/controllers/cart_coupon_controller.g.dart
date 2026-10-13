// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_coupon_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Cart voucher state (DESIGN.md §5.1.3): locally-held previews validated
/// against the server. Display-only — checkout re-validates authoritatively
/// at order placement (§53), so this state never leaves the cart surface.

@ProviderFor(CartCouponController)
final cartCouponControllerProvider = CartCouponControllerProvider._();

/// Cart voucher state (DESIGN.md §5.1.3): locally-held previews validated
/// against the server. Display-only — checkout re-validates authoritatively
/// at order placement (§53), so this state never leaves the cart surface.
final class CartCouponControllerProvider
    extends $NotifierProvider<CartCouponController, List<CartCoupon>> {
  /// Cart voucher state (DESIGN.md §5.1.3): locally-held previews validated
  /// against the server. Display-only — checkout re-validates authoritatively
  /// at order placement (§53), so this state never leaves the cart surface.
  CartCouponControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartCouponControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartCouponControllerHash();

  @$internal
  @override
  CartCouponController create() => CartCouponController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<CartCoupon> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<CartCoupon>>(value),
    );
  }
}

String _$cartCouponControllerHash() =>
    r'b63c6edfa35178065c9fd11e2d414f235ae7f094';

/// Cart voucher state (DESIGN.md §5.1.3): locally-held previews validated
/// against the server. Display-only — checkout re-validates authoritatively
/// at order placement (§53), so this state never leaves the cart surface.

abstract class _$CartCouponController extends $Notifier<List<CartCoupon>> {
  List<CartCoupon> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<CartCoupon>, List<CartCoupon>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<CartCoupon>, List<CartCoupon>>,
              List<CartCoupon>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
