// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_fee_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Platform-wide delivery fee (minor units) for the storefront trust block.
/// Plain one-shot fetch — presentation may call the repository directly
/// (DOMAIN-03).

@ProviderFor(deliveryFeeMinor)
final deliveryFeeMinorProvider = DeliveryFeeMinorProvider._();

/// Platform-wide delivery fee (minor units) for the storefront trust block.
/// Plain one-shot fetch — presentation may call the repository directly
/// (DOMAIN-03).

final class DeliveryFeeMinorProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// Platform-wide delivery fee (minor units) for the storefront trust block.
  /// Plain one-shot fetch — presentation may call the repository directly
  /// (DOMAIN-03).
  DeliveryFeeMinorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deliveryFeeMinorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deliveryFeeMinorHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return deliveryFeeMinor(ref);
  }
}

String _$deliveryFeeMinorHash() => r'c259822f0b6eba44bf50164b4622507366292e60';
