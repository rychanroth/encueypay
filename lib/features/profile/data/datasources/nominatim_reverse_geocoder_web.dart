import 'dart:js_interop';

import '../../../../core/network/failure_mapping.dart';

/// Browser fetch of the public Nominatim endpoint. Nominatim sends
/// `access-control-allow-origin: *`, so a direct `fetch` is allowed; the
/// platform `geocoding` plugin has no web implementation, which is why the
/// address form needs this branch to prefill anything on web.
///
/// Mirrors the io implementation: one request per user tap, no user agent
/// header (browsers forbid setting it — the Referer identifies the app).
Future<Map<String, dynamic>?> nominatimReverseGeocode({
  required double latitude,
  required double longitude,
}) async {
  try {
    final uri = Uri.https('nominatim.openstreetmap.org', '/reverse', {
      'format': 'jsonv2',
      'lat': latitude.toString(),
      'lon': longitude.toString(),
      'zoom': '18',
      'addressdetails': '1',
      'accept-language': 'km,en',
    });
    final response = await _fetch(uri.toString()).toDart;
    if (!response.ok) return null;
    final decoded = (await response.json().toDart).dartify();
    if (decoded is! Map) return null;
    return decoded.map((key, value) => MapEntry(key.toString(), value));
  } catch (error, stackTrace) {
    // Optional prefill: a failed lookup is not an address-save failure.
    logSuppressedError(error, stackTrace);
    return null;
  }
}

/// Minimal typed view of the browser `Response`.
extension type _Response(JSObject _) implements JSObject {
  external bool get ok;

  external JSPromise<JSAny?> json();
}

@JS('fetch')
external JSPromise<_Response> _fetch(String url);
