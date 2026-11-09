/// Fallback for platforms with neither `dart:io` nor `dart:js_interop`
/// (not expected in this app — io covers mobile/desktop, js_interop web).
Future<Map<String, dynamic>?> nominatimReverseGeocode({
  required double latitude,
  required double longitude,
}) async {
  return null;
}
