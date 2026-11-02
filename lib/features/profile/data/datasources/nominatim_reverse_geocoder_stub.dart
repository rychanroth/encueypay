/// Web fallback: no direct Nominatim call (the app uses the platform
/// geocoder fallback there).
Future<Map<String, dynamic>?> nominatimReverseGeocode({
  required double latitude,
  required double longitude,
}) async {
  return null;
}
