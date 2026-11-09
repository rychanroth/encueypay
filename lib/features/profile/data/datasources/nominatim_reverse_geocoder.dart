import 'nominatim_reverse_geocoder_stub.dart'
    if (dart.library.io) 'nominatim_reverse_geocoder_io.dart'
    if (dart.library.js_interop) 'nominatim_reverse_geocoder_web.dart'
    as impl;

/// Best-effort reverse geocoding through the public Nominatim endpoint.
/// Mobile/desktop use a socket client, web uses the browser's `fetch`
/// (`geocoding` has no web plugin). Returns null on any failure; callers
/// fall back to the platform geocoder and manual selection.
Future<Map<String, dynamic>?> nominatimReverseGeocode({
  required double latitude,
  required double longitude,
}) {
  return impl.nominatimReverseGeocode(latitude: latitude, longitude: longitude);
}
