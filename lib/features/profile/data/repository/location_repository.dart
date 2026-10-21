import '../../domain/entities/located_address.dart';

/// Device-location contract for the profile feature (DATA-03): powers the
/// one-tap current-location prefill on the address form. Results are
/// suggestions only — the user edits and saves through [IAddressRepository].
abstract interface class ILocationRepository {
  /// Resolves the device's current position, requesting permission if
  /// needed. Throws [NetworkFailure] for anticipated device states
  /// (permission denied, services off).
  Future<({double latitude, double longitude})> currentPosition();

  /// Reverse-geocodes coordinates with the platform geocoder. Returns null
  /// when nothing resolvable is found (quality varies by platform/region).
  Future<LocatedAddress?> reverseGeocode({
    required double latitude,
    required double longitude,
  });

  /// Opens the platform settings page — recovery path for a denied
  /// permission.
  Future<void> openSettings();
}
