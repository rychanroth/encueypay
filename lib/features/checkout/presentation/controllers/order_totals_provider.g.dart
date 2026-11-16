// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_totals_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Authoritative order totals for the checkout summary: the sale-applied
/// subtotal plus the manually entered codes, scoped to the cart lines ticked
/// on the cart page (the family key). Rebuilt whenever the applied coupons
/// change; the placement RPC re-validates everything server-side regardless.

@ProviderFor(orderTotalsPreview)
final orderTotalsPreviewProvider = OrderTotalsPreviewFamily._();

/// Authoritative order totals for the checkout summary: the sale-applied
/// subtotal plus the manually entered codes, scoped to the cart lines ticked
/// on the cart page (the family key). Rebuilt whenever the applied coupons
/// change; the placement RPC re-validates everything server-side regardless.

final class OrderTotalsPreviewProvider
    extends
        $FunctionalProvider<
          AsyncValue<OrderTotalsPreview>,
          OrderTotalsPreview,
          FutureOr<OrderTotalsPreview>
        >
    with
        $FutureModifier<OrderTotalsPreview>,
        $FutureProvider<OrderTotalsPreview> {
  /// Authoritative order totals for the checkout summary: the sale-applied
  /// subtotal plus the manually entered codes, scoped to the cart lines ticked
  /// on the cart page (the family key). Rebuilt whenever the applied coupons
  /// change; the placement RPC re-validates everything server-side regardless.
  OrderTotalsPreviewProvider._({
    required OrderTotalsPreviewFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'orderTotalsPreviewProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$orderTotalsPreviewHash();

  @override
  String toString() {
    return r'orderTotalsPreviewProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<OrderTotalsPreview> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<OrderTotalsPreview> create(Ref ref) {
    final argument = this.argument as String;
    return orderTotalsPreview(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderTotalsPreviewProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$orderTotalsPreviewHash() =>
    r'632e1507b3bde1458cc9d25e904c27c50fd2b4e9';

/// Authoritative order totals for the checkout summary: the sale-applied
/// subtotal plus the manually entered codes, scoped to the cart lines ticked
/// on the cart page (the family key). Rebuilt whenever the applied coupons
/// change; the placement RPC re-validates everything server-side regardless.

final class OrderTotalsPreviewFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<OrderTotalsPreview>, String> {
  OrderTotalsPreviewFamily._()
    : super(
        retry: null,
        name: r'orderTotalsPreviewProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Authoritative order totals for the checkout summary: the sale-applied
  /// subtotal plus the manually entered codes, scoped to the cart lines ticked
  /// on the cart page (the family key). Rebuilt whenever the applied coupons
  /// change; the placement RPC re-validates everything server-side regardless.

  OrderTotalsPreviewProvider call(String selectionKey) =>
      OrderTotalsPreviewProvider._(argument: selectionKey, from: this);

  @override
  String toString() => r'orderTotalsPreviewProvider';
}
