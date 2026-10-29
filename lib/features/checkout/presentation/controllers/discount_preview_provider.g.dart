// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discount_preview_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Authoritative discount preview for the checkout summary: the manually
/// entered codes plus the single best eligible campaign coupon, which
/// applies automatically at placement (no code entry — user decision
/// 2026-10-28). Rebuilt whenever the applied coupons change; the placement
/// RPC re-validates everything server-side regardless.

@ProviderFor(discountPreview)
final discountPreviewProvider = DiscountPreviewProvider._();

/// Authoritative discount preview for the checkout summary: the manually
/// entered codes plus the single best eligible campaign coupon, which
/// applies automatically at placement (no code entry — user decision
/// 2026-10-28). Rebuilt whenever the applied coupons change; the placement
/// RPC re-validates everything server-side regardless.

final class DiscountPreviewProvider
    extends
        $FunctionalProvider<
          AsyncValue<DiscountPreview>,
          DiscountPreview,
          FutureOr<DiscountPreview>
        >
    with $FutureModifier<DiscountPreview>, $FutureProvider<DiscountPreview> {
  /// Authoritative discount preview for the checkout summary: the manually
  /// entered codes plus the single best eligible campaign coupon, which
  /// applies automatically at placement (no code entry — user decision
  /// 2026-10-28). Rebuilt whenever the applied coupons change; the placement
  /// RPC re-validates everything server-side regardless.
  DiscountPreviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'discountPreviewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$discountPreviewHash();

  @$internal
  @override
  $FutureProviderElement<DiscountPreview> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DiscountPreview> create(Ref ref) {
    return discountPreview(ref);
  }
}

String _$discountPreviewHash() => r'1edcca2bda709d51a9838b0543f6a55363f0a1e0';
