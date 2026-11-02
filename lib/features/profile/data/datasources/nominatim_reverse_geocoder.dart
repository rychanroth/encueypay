import 'nominatim_reverse_geocoder_stub.dart'
    if (dart.library.io) 'nominatim_reverse_geocoder_io.dart'
    as impl;

/// Best-effort reverse geocoding through the public Nominatim endpoint.
/// Returns null on web or on any failure; callers fall back to the platform
/// geocoder and manual selection.
Future<Map<String, dynamic>?> nominatimReverseGeocode({
  required double latitude,
  required double longitude,
}) {
  return impl.nominatimReverseGeocode(latitude: latitude, longitude: longitude);
}
