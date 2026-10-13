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

/// New arrivals (DESIGN.md §5.1.1): the qualification rule is a 14-day
/// recency window, active status, and positive stock — merchandising-
/// eligible products only (§2d keeps the Unavailable badge for catalog
/// surfaces). Deterministic: newest first with an id tiebreak (repo).

@ProviderFor(homeProducts)
final homeProductsProvider = HomeProductsProvider._();

/// New arrivals (DESIGN.md §5.1.1): the qualification rule is a 14-day
/// recency window, active status, and positive stock — merchandising-
/// eligible products only (§2d keeps the Unavailable badge for catalog
/// surfaces). Deterministic: newest first with an id tiebreak (repo).

final class HomeProductsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Product>>,
          List<Product>,
          FutureOr<List<Product>>
        >
    with $FutureModifier<List<Product>>, $FutureProvider<List<Product>> {
  /// New arrivals (DESIGN.md §5.1.1): the qualification rule is a 14-day
  /// recency window, active status, and positive stock — merchandising-
  /// eligible products only (§2d keeps the Unavailable badge for catalog
  /// surfaces). Deterministic: newest first with an id tiebreak (repo).
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

String _$homeProductsHash() => r'7806f098e92d4a41543a55e32586d1c52e312df3';
