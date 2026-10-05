// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Multi-step checkout (Section 6b — assignment §6 sequence): Cart review →
/// Address → Shipping method → Payment → Coupon → Order note → Summary.
/// Selection state is presentation state (no optimistic persistence);
/// placement stays an atomic use case (DOMAIN-02).

@ProviderFor(CheckoutController)
final checkoutControllerProvider = CheckoutControllerProvider._();

/// Multi-step checkout (Section 6b — assignment §6 sequence): Cart review →
/// Address → Shipping method → Payment → Coupon → Order note → Summary.
/// Selection state is presentation state (no optimistic persistence);
/// placement stays an atomic use case (DOMAIN-02).
final class CheckoutControllerProvider
    extends $AsyncNotifierProvider<CheckoutController, CheckoutState> {
  /// Multi-step checkout (Section 6b — assignment §6 sequence): Cart review →
  /// Address → Shipping method → Payment → Coupon → Order note → Summary.
  /// Selection state is presentation state (no optimistic persistence);
  /// placement stays an atomic use case (DOMAIN-02).
  CheckoutControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkoutControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkoutControllerHash();

  @$internal
  @override
  CheckoutController create() => CheckoutController();
}

String _$checkoutControllerHash() =>
    r'9094643dcadbd7745bfc0486d63a6698e6bd5d76';

/// Multi-step checkout (Section 6b — assignment §6 sequence): Cart review →
/// Address → Shipping method → Payment → Coupon → Order note → Summary.
/// Selection state is presentation state (no optimistic persistence);
/// placement stays an atomic use case (DOMAIN-02).

abstract class _$CheckoutController extends $AsyncNotifier<CheckoutState> {
  FutureOr<CheckoutState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<CheckoutState>, CheckoutState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CheckoutState>, CheckoutState>,
              AsyncValue<CheckoutState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
