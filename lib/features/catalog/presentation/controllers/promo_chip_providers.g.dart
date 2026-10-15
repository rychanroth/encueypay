// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promo_chip_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// One shared fetch of coupon-backed, chip-worthy promotions (Section 9) —
/// every ProductCard and the product detail price block consume this single
/// provider instead of querying per card.

@ProviderFor(activePromotions)
final activePromotionsProvider = ActivePromotionsProvider._();

/// One shared fetch of coupon-backed, chip-worthy promotions (Section 9) —
/// every ProductCard and the product detail price block consume this single
/// provider instead of querying per card.

final class ActivePromotionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ActivePromo>>,
          List<ActivePromo>,
          FutureOr<List<ActivePromo>>
        >
    with
        $FutureModifier<List<ActivePromo>>,
        $FutureProvider<List<ActivePromo>> {
  /// One shared fetch of coupon-backed, chip-worthy promotions (Section 9) —
  /// every ProductCard and the product detail price block consume this single
  /// provider instead of querying per card.
  ActivePromotionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activePromotionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activePromotionsHash();

  @$internal
  @override
  $FutureProviderElement<List<ActivePromo>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ActivePromo>> create(Ref ref) {
    return activePromotions(ref);
  }
}

String _$activePromotionsHash() => r'c755418f61c933fa4664216dc3339d7c6bec1a66';
