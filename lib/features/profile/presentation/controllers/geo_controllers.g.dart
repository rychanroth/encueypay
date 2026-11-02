// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Bundled official hierarchy lookups for the address picker (plain fetches,
/// so the controller layer calls the repository directly — DOMAIN-03).

@ProviderFor(geoProvinces)
final geoProvincesProvider = GeoProvincesProvider._();

/// Bundled official hierarchy lookups for the address picker (plain fetches,
/// so the controller layer calls the repository directly — DOMAIN-03).

final class GeoProvincesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AdministrativeUnit>>,
          List<AdministrativeUnit>,
          FutureOr<List<AdministrativeUnit>>
        >
    with
        $FutureModifier<List<AdministrativeUnit>>,
        $FutureProvider<List<AdministrativeUnit>> {
  /// Bundled official hierarchy lookups for the address picker (plain fetches,
  /// so the controller layer calls the repository directly — DOMAIN-03).
  GeoProvincesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'geoProvincesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$geoProvincesHash();

  @$internal
  @override
  $FutureProviderElement<List<AdministrativeUnit>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AdministrativeUnit>> create(Ref ref) {
    return geoProvinces(ref);
  }
}

String _$geoProvincesHash() => r'7ee2821ba3f56a6f57ae3f313eb35f14d64aa883';

@ProviderFor(geoDistricts)
final geoDistrictsProvider = GeoDistrictsFamily._();

final class GeoDistrictsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AdministrativeUnit>>,
          List<AdministrativeUnit>,
          FutureOr<List<AdministrativeUnit>>
        >
    with
        $FutureModifier<List<AdministrativeUnit>>,
        $FutureProvider<List<AdministrativeUnit>> {
  GeoDistrictsProvider._({
    required GeoDistrictsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'geoDistrictsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$geoDistrictsHash();

  @override
  String toString() {
    return r'geoDistrictsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<AdministrativeUnit>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AdministrativeUnit>> create(Ref ref) {
    final argument = this.argument as String;
    return geoDistricts(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GeoDistrictsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$geoDistrictsHash() => r'08e92d5a0d2f9c791cab0c6ebfbcad460223b2df';

final class GeoDistrictsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<AdministrativeUnit>>, String> {
  GeoDistrictsFamily._()
    : super(
        retry: null,
        name: r'geoDistrictsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GeoDistrictsProvider call(String provinceCode) =>
      GeoDistrictsProvider._(argument: provinceCode, from: this);

  @override
  String toString() => r'geoDistrictsProvider';
}

@ProviderFor(geoCommunes)
final geoCommunesProvider = GeoCommunesFamily._();

final class GeoCommunesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AdministrativeUnit>>,
          List<AdministrativeUnit>,
          FutureOr<List<AdministrativeUnit>>
        >
    with
        $FutureModifier<List<AdministrativeUnit>>,
        $FutureProvider<List<AdministrativeUnit>> {
  GeoCommunesProvider._({
    required GeoCommunesFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'geoCommunesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$geoCommunesHash();

  @override
  String toString() {
    return r'geoCommunesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<AdministrativeUnit>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AdministrativeUnit>> create(Ref ref) {
    final argument = this.argument as (String, String);
    return geoCommunes(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is GeoCommunesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$geoCommunesHash() => r'c031a2c572f95619b45a3996150acfc5b8968049';

final class GeoCommunesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<AdministrativeUnit>>,
          (String, String)
        > {
  GeoCommunesFamily._()
    : super(
        retry: null,
        name: r'geoCommunesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GeoCommunesProvider call(String provinceCode, String districtCode) =>
      GeoCommunesProvider._(argument: (provinceCode, districtCode), from: this);

  @override
  String toString() => r'geoCommunesProvider';
}

@ProviderFor(geoVillages)
final geoVillagesProvider = GeoVillagesFamily._();

final class GeoVillagesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AdministrativeUnit>>,
          List<AdministrativeUnit>,
          FutureOr<List<AdministrativeUnit>>
        >
    with
        $FutureModifier<List<AdministrativeUnit>>,
        $FutureProvider<List<AdministrativeUnit>> {
  GeoVillagesProvider._({
    required GeoVillagesFamily super.from,
    required (String, String, String) super.argument,
  }) : super(
         retry: null,
         name: r'geoVillagesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$geoVillagesHash();

  @override
  String toString() {
    return r'geoVillagesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<AdministrativeUnit>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AdministrativeUnit>> create(Ref ref) {
    final argument = this.argument as (String, String, String);
    return geoVillages(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is GeoVillagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$geoVillagesHash() => r'8b0b54dcba8fc813a6ab88f97d78bebc3e24ebf0';

final class GeoVillagesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<AdministrativeUnit>>,
          (String, String, String)
        > {
  GeoVillagesFamily._()
    : super(
        retry: null,
        name: r'geoVillagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GeoVillagesProvider call(
    String provinceCode,
    String districtCode,
    String communeCode,
  ) => GeoVillagesProvider._(
    argument: (provinceCode, districtCode, communeCode),
    from: this,
  );

  @override
  String toString() => r'geoVillagesProvider';
}
