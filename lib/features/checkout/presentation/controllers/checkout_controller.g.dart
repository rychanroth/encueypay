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
final checkoutControllerProvider = CheckoutControllerFamily._();

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
  CheckoutControllerProvider._({
    required CheckoutControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'checkoutControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$checkoutControllerHash();

  @override
  String toString() {
    return r'checkoutControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CheckoutController create() => CheckoutController();

  @override
  bool operator ==(Object other) {
    return other is CheckoutControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$checkoutControllerHash() =>
    r'cb6ba880e66cd9ac81a9ff219e646f5d542fc915';

/// Single-page checkout: the page renders cart review, address, payment,
/// coupon, note and summary together. Selection state is presentation state
/// (no optimistic persistence); placement stays an atomic use case
/// (DOMAIN-02).

final class CheckoutControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          CheckoutController,
          AsyncValue<CheckoutState>,
          CheckoutState,
          FutureOr<CheckoutState>,
          String
        > {
  CheckoutControllerFamily._()
    : super(
        retry: null,
        name: r'checkoutControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Single-page checkout: the page renders cart review, address, payment,
  /// coupon, note and summary together. Selection state is presentation state
  /// (no optimistic persistence); placement stays an atomic use case
  /// (DOMAIN-02).

  CheckoutControllerProvider call(String selectionKey) =>
      CheckoutControllerProvider._(argument: selectionKey, from: this);

  @override
  String toString() => r'checkoutControllerProvider';
}

/// Single-page checkout: the page renders cart review, address, payment,
/// coupon, note and summary together. Selection state is presentation state
/// (no optimistic persistence); placement stays an atomic use case
/// (DOMAIN-02).

abstract class _$CheckoutController extends $AsyncNotifier<CheckoutState> {
  late final _$args = ref.$arg as String;
  String get selectionKey => _$args;

  FutureOr<CheckoutState> build(String selectionKey);
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
    return element.handleCreate(ref, () => build(_$args));
  }
}
