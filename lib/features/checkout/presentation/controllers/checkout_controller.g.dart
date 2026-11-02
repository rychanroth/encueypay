// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Single-page checkout: the page renders cart review, address, payment,
/// coupon, note and summary together. Selection state is presentation state
/// (no optimistic persistence); placement stays an atomic use case
/// (DOMAIN-02).

@ProviderFor(CheckoutController)
final checkoutControllerProvider = CheckoutControllerProvider._();

/// Single-page checkout: the page renders cart review, address, payment,
/// coupon, note and summary together. Selection state is presentation state
/// (no optimistic persistence); placement stays an atomic use case
/// (DOMAIN-02).
final class CheckoutControllerProvider
    extends $AsyncNotifierProvider<CheckoutController, CheckoutState> {
  /// Single-page checkout: the page renders cart review, address, payment,
  /// coupon, note and summary together. Selection state is presentation state
  /// (no optimistic persistence); placement stays an atomic use case
  /// (DOMAIN-02).
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
    r'83c0c5f4e8c09670ea2f14d0384e025a5e37112c';

/// Single-page checkout: the page renders cart review, address, payment,
/// coupon, note and summary together. Selection state is presentation state
/// (no optimistic persistence); placement stays an atomic use case
/// (DOMAIN-02).

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
