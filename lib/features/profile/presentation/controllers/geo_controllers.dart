import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/location_repository_impl.dart';
import '../../domain/entities/administrative_unit.dart';

part 'geo_controllers.g.dart';

/// Bundled official hierarchy lookups for the address picker (plain fetches,
/// so the controller layer calls the repository directly — DOMAIN-03).
@riverpod
Future<List<AdministrativeUnit>> geoProvinces(Ref ref) {
  return ref.watch(locationRepositoryProvider).provinces();
}

@riverpod
Future<List<AdministrativeUnit>> geoDistricts(Ref ref, String provinceCode) {
  return ref.watch(locationRepositoryProvider).districts(provinceCode);
}

@riverpod
Future<List<AdministrativeUnit>> geoCommunes(
  Ref ref,
  String provinceCode,
  String districtCode,
) {
  return ref
      .watch(locationRepositoryProvider)
      .communes(provinceCode, districtCode);
}

@riverpod
Future<List<AdministrativeUnit>> geoVillages(
  Ref ref,
  String provinceCode,
  String districtCode,
  String communeCode,
) {
  return ref
      .watch(locationRepositoryProvider)
      .villages(provinceCode, districtCode, communeCode);
}
