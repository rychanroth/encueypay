// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_feed_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Home feed sections (newest products + businesses). Plain one-shot
/// fetches — controllers MAY call the repository directly (DOMAIN-03).

@ProviderFor(homeProducts)
final homeProductsProvider = HomeProductsProvider._();

/// Home feed sections (newest products + businesses). Plain one-shot
/// fetches — controllers MAY call the repository directly (DOMAIN-03).

final class HomeProductsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Product>>,
          List<Product>,
          FutureOr<List<Product>>
        >
    with $FutureModifier<List<Product>>, $FutureProvider<List<Product>> {
  /// Home feed sections (newest products + businesses). Plain one-shot
  /// fetches — controllers MAY call the repository directly (DOMAIN-03).
  HomeProductsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeProductsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeProductsHash();

  @$internal
  @override
  $FutureProviderElement<List<Product>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Product>> create(Ref ref) {
    return homeProducts(ref);
  }
}

String _$homeProductsHash() => r'4e6dcdca3e26f6dc3c8cc89bb1cc8028b583e650';

@ProviderFor(homeBusinesses)
final homeBusinessesProvider = HomeBusinessesProvider._();

final class HomeBusinessesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Business>>,
          List<Business>,
          FutureOr<List<Business>>
        >
    with $FutureModifier<List<Business>>, $FutureProvider<List<Business>> {
  HomeBusinessesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeBusinessesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeBusinessesHash();

  @$internal
  @override
  $FutureProviderElement<List<Business>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Business>> create(Ref ref) {
    return homeBusinesses(ref);
  }
}

String _$homeBusinessesHash() => r'b38da7d84763ec382a01e1a822ac7f7a133fa053';
