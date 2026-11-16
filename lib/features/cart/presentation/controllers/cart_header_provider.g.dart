// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_header_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(cartHeader)
final cartHeaderProvider = CartHeaderProvider._();

final class CartHeaderProvider
    extends
        $FunctionalProvider<
          AsyncValue<CartHeader>,
          CartHeader,
          FutureOr<CartHeader>
        >
    with $FutureModifier<CartHeader>, $FutureProvider<CartHeader> {
  CartHeaderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartHeaderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartHeaderHash();

  @$internal
  @override
  $FutureProviderElement<CartHeader> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<CartHeader> create(Ref ref) {
    return cartHeader(ref);
  }
}

String _$cartHeaderHash() => r'5f3766281485f16507c030c8cba554037bc8d49b';
