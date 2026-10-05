// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_feed_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Home feed sections (banners, newest products). Plain
/// one-shot fetches — controllers MAY call the repository directly
/// (DOMAIN-03).

@ProviderFor(homeBanners)
final homeBannersProvider = HomeBannersProvider._();

/// Home feed sections (banners, newest products). Plain
/// one-shot fetches — controllers MAY call the repository directly
/// (DOMAIN-03).

final class HomeBannersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CatalogBanner>>,
          List<CatalogBanner>,
          FutureOr<List<CatalogBanner>>
        >
    with
        $FutureModifier<List<CatalogBanner>>,
        $FutureProvider<List<CatalogBanner>> {
  /// Home feed sections (banners, newest products). Plain
  /// one-shot fetches — controllers MAY call the repository directly
  /// (DOMAIN-03).
  HomeBannersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeBannersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeBannersHash();

  @$internal
  @override
  $FutureProviderElement<List<CatalogBanner>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CatalogBanner>> create(Ref ref) {
    return homeBanners(ref);
  }
}

String _$homeBannersHash() => r'e244df33d977d29af6caa3c8a1b6d62004cdb141';

@ProviderFor(homeProducts)
final homeProductsProvider = HomeProductsProvider._();

final class HomeProductsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Product>>,
          List<Product>,
          FutureOr<List<Product>>
        >
    with $FutureModifier<List<Product>>, $FutureProvider<List<Product>> {
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
