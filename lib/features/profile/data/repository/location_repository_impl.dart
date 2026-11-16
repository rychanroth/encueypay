import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show MissingPluginException, PlatformException;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/network/failure_mapping.dart';
import '../../domain/entities/administrative_unit.dart';
import '../../domain/entities/located_address.dart';
import '../datasources/cambodia_geo_data_source.dart';
import '../datasources/cambodia_location_matcher.dart';
import '../datasources/nominatim_reverse_geocoder.dart';
import 'location_repository.dart';

/// Exposes the interface type, never the impl (DATA-07).
final locationRepositoryProvider = Provider<ILocationRepository>((ref) {
  return LocationRepositoryImpl();
});

class LocationRepositoryImpl implements ILocationRepository {
  final Geocoding _geocoder = Geocoding();
  final CambodiaGeoDataSource _geo = CambodiaGeoDataSource();

  @override
  Future<({double latitude, double longitude})> currentPosition() async {
    try {
      // Web has no separate "location service", and its Permissions API
      // support varies by browser (Safari throws on the geolocation query).
      // getCurrentPosition itself raises the browser prompt, so on web go
      // straight to it and let the browser decide.
      if (!kIsWeb) {
        if (!await Geolocator.isLocationServiceEnabled()) {
          throw const NetworkFailure(_serviceOffMessage);
        }
        var permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          throw NetworkFailure(_permissionMessage);
        }
      } else {
        // A permission that is already denied forever (including every
        // non-secure origin — Chrome only grants geolocation on https:// or
        // localhost) can never be prompted again; surface that instead of
        // calling getCurrentPosition and waiting for a callback that never
        // comes. `prompt` maps to `denied`, so a first visit still reaches
        // the browser prompt below.
        try {
          final permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.deniedForever) {
            throw NetworkFailure(_permissionMessage);
          }
        } on NetworkFailure {
          rethrow;
        } catch (error, stackTrace) {
          // Permissions API is optional (Safari); getCurrentPosition is the
          // real gate there.
          logSuppressedError(error, stackTrace);
        }
      }
      // Single-shot best-effort fix. The web plugin's own timeout conversion
      // is unreliable, and a dismissed/locked permission prompt can leave the
      // future pending forever — cap it here so the form never hangs.
      final position = await Geolocator.getCurrentPosition()
          .timeout(const Duration(seconds: 30));
      return (latitude: position.latitude, longitude: position.longitude);
    } on NetworkFailure {
      // Anticipated device states above — don't reclassify (DATA-05).
      rethrow;
    } on LocationServiceDisabledException {
      throw const NetworkFailure(_serviceOffMessage);
    } on PermissionDeniedException {
      throw NetworkFailure(_permissionMessage);
    } on PositionUpdateException {
      // Browser geolocation unavailable — most often an insecure context
      // (plain http, non-localhost) or no usable fix.
      throw NetworkFailure(_unavailableMessage);
    } on TimeoutException {
      throw const NetworkFailure(_timeoutMessage);
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }

  @override
  Future<List<AdministrativeUnit>> provinces() async {
    try {
      return await _geo.provinces();
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }

  @override
  Future<List<AdministrativeUnit>> districts(String provinceCode) async {
    try {
      return await _geo.districts(provinceCode);
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }

  @override
  Future<List<AdministrativeUnit>> communes(
    String provinceCode,
    String districtCode,
  ) async {
    try {
      return await _geo.communes(provinceCode, districtCode);
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }

  @override
  Future<List<AdministrativeUnit>> villages(
    String provinceCode,
    String districtCode,
    String communeCode,
  ) async {
    try {
      return await _geo.villages(provinceCode, districtCode, communeCode);
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }

  @override
  Future<LocatedAddress?> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    // Best-effort official hierarchy first. Any failure here must not block
    // the platform geocoder fallback.
    try {
      final nominatim = await nominatimReverseGeocode(
        latitude: latitude,
        longitude: longitude,
      );
      if (nominatim != null) {
        final matched = await CambodiaLocationMatcher(_geo).match(nominatim);
        if (matched != null &&
            (matched.line1.isNotEmpty ||
                matched.city != null ||
                matched.matchedLevels > 0)) {
          return matched;
        }
      }
    } catch (error, stackTrace) {
      logSuppressedError(error, stackTrace);
    }

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
    } on MissingPluginException catch (error, stackTrace) {
      // Platforms without a geocoding plugin (web) have no placemark source;
      // the prefill is best-effort, so fall back to manual entry.
      logSuppressedError(error, stackTrace);
      return null;
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
  Future<void> openSettings() async {
    // Browsers own the site-permission UI; the plugin's app-settings call
    // throws UnsupportedError on web.
    if (kIsWeb) return;
    await Geolocator.openAppSettings();
  }

  @override
  Future<void> openLocationSettings() async {
    if (kIsWeb) return;
    await Geolocator.openLocationSettings();
  }
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
const _timeoutMessage =
    'Getting your location timed out. Check the browser permission prompt and '
    'try again — you can also tap the map to set your pin.';

String get _permissionMessage => kIsWeb
    ? 'Location is blocked for this site. Chrome only allows location on '
        'https:// or http://localhost — allow it for this site, then reload.'
    : 'Location permission is needed to use your current location.';

String get _unavailableMessage => kIsWeb
    ? "Chrome couldn't determine your location. Tap the map to set your pin "
        'manually, or allow location for this site and try again.'
    : "Couldn't get your location. Move somewhere with a clearer signal and "
        'try again.';
