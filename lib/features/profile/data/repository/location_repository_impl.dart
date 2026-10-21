import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/network/failure_mapping.dart';
import '../../domain/entities/located_address.dart';
import 'location_repository.dart';

/// Exposes the interface type, never the impl (DATA-07).
final locationRepositoryProvider = Provider<ILocationRepository>((ref) {
  return LocationRepositoryImpl();
});

class LocationRepositoryImpl implements ILocationRepository {
  final Geocoding _geocoder = Geocoding();

  @override
  Future<({double latitude, double longitude})> currentPosition() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw const NetworkFailure(_serviceOffMessage);
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw const NetworkFailure(_permissionMessage);
      }
      // Single-shot, best-effort fix — the result feeds an editable form,
      // not a map.
      final position = await Geolocator.getCurrentPosition();
      return (latitude: position.latitude, longitude: position.longitude);
    } on Failure {
      // Anticipated device states above — don't reclassify (DATA-05).
      rethrow;
    } on LocationServiceDisabledException {
      throw const NetworkFailure(_serviceOffMessage);
    } on PermissionDeniedException {
      throw const NetworkFailure(_permissionMessage);
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }

  @override
  Future<LocatedAddress?> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final placemarks =
          await _geocoder.placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isEmpty) return null;
      final placemark = placemarks.first;
      final line1 = _firstNonEmpty([
        _streetLine(placemark),
        // `name` often carries the full first line; drop it when it merely
        // repeats the city (Android quirk).
        placemark.name == placemark.locality ? null : placemark.name,
      ]);
      final city = _firstNonEmpty([
        placemark.locality,
        placemark.subAdministrativeArea,
        placemark.administrativeArea,
      ]);
      if (line1 == null && city == null) return null;
      return LocatedAddress(line1: line1 ?? '', city: city);
    } on PlatformException catch (error, stackTrace) {
      // Coarse fixes and rural coordinates often have no resolvable
      // address — deliberate best-effort swallow for an optional prefill.
      logSuppressedError(error, stackTrace);
      return null;
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }

  @override
  Future<void> openSettings() => Geolocator.openAppSettings();
}

/// "271 Preah Norodom Blvd", whichever of the number/street pair survives.
String? _streetLine(Placemark placemark) {
  final number = placemark.subThoroughfare?.trim();
  final street = placemark.thoroughfare?.trim();
  if (number != null &&
      number.isNotEmpty &&
      street != null &&
      street.isNotEmpty) {
    return '$number $street';
  }
  if (street != null && street.isNotEmpty) return street;
  return number;
}

String? _firstNonEmpty(List<String?> values) {
  for (final value in values) {
    final trimmed = value?.trim();
    if (trimmed != null && trimmed.isNotEmpty) return trimmed;
  }
  return null;
}

const _serviceOffMessage =
    'Location services are disabled. Turn them on to use your current location.';
const _permissionMessage =
    'Location permission is needed to use your current location.';
