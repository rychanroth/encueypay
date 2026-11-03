import '../../domain/entities/administrative_unit.dart';
import '../../domain/entities/located_address.dart';

/// Device-location contract for the profile feature (DATA-03): powers the
/// one-tap current-location prefill on the address form. Results are
/// suggestions only — the user edits and saves through [IAddressRepository].
abstract interface class ILocationRepository {
  /// Resolves the device's current position, requesting permission if
  /// needed. Throws [NetworkFailure] for anticipated device states
  /// (permission denied, services off).
  Future<({double latitude, double longitude})> currentPosition();

  /// Reverse-geocodes coordinates. Tries Nominatim + official hierarchy
  /// matching first, then falls back to the platform geocoder. Returns null
  /// when nothing resolvable is found.
  Future<LocatedAddress?> reverseGeocode({
    required double latitude,
    required double longitude,
  });

  /// Bundled official 2025 hierarchy; provinces first, then each level.
  Future<List<AdministrativeUnit>> provinces();
  Future<List<AdministrativeUnit>> districts(String provinceCode);
  Future<List<AdministrativeUnit>> communes(
    String provinceCode,
    String districtCode,
  );
  Future<List<AdministrativeUnit>> villages(
    String provinceCode,
    String districtCode,
    String communeCode,
  );

  /// Opens the platform settings page — recovery path for a denied
  /// permission.
  Future<void> openSettings();

  /// Opens the OS location-services settings (service disabled, not
  /// permission denied).
  Future<void> openLocationSettings();
}
