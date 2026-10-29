// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_totals_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Authoritative order totals for the checkout summary: the sale-applied
/// subtotal plus the manually entered codes. Rebuilt whenever the applied
/// coupons change; the placement RPC re-validates everything server-side
/// regardless.

@ProviderFor(orderTotalsPreview)
final orderTotalsPreviewProvider = OrderTotalsPreviewProvider._();

/// Authoritative order totals for the checkout summary: the sale-applied
/// subtotal plus the manually entered codes. Rebuilt whenever the applied
/// coupons change; the placement RPC re-validates everything server-side
/// regardless.

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
  /// subtotal plus the manually entered codes. Rebuilt whenever the applied
  /// coupons change; the placement RPC re-validates everything server-side
  /// regardless.
  OrderTotalsPreviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderTotalsPreviewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderTotalsPreviewHash();

  @$internal
  @override
  $FutureProviderElement<OrderTotalsPreview> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<OrderTotalsPreview> create(Ref ref) {
    return orderTotalsPreview(ref);
  }
}

String _$orderTotalsPreviewHash() =>
    r'ad84a6f47a4888310bdab0416f6c2668163af84c';
