import 'dart:convert';
import 'dart:io';

import '../../../../core/network/failure_mapping.dart';

/// Public Nominatim call for mobile/desktop. Prototype policy: one request
/// per user tap, a clear User-Agent, and no autocomplete traffic.
Future<Map<String, dynamic>?> nominatimReverseGeocode({
  required double latitude,
  required double longitude,
}) async {
  final client = HttpClient();
  try {
    final uri = Uri.https('nominatim.openstreetmap.org', '/reverse', {
      'format': 'jsonv2',
      'lat': latitude.toString(),
      'lon': longitude.toString(),
      'zoom': '18',
      'addressdetails': '1',
      'accept-language': 'km,en',
    });
    final request = await client
        .getUrl(uri)
        .timeout(const Duration(seconds: 8));
    request.headers.set(
      HttpHeaders.userAgentHeader,
      'encueypay-address-prototype/1.0',
    );
    request.headers.set(HttpHeaders.acceptLanguageHeader, 'km,en');
    final response = await request.close().timeout(const Duration(seconds: 8));
    final body = await utf8.decoder.bind(response).join();
    if (response.statusCode != HttpStatus.ok) return null;
    final decoded = jsonDecode(body);
    return decoded is Map<String, dynamic> ? decoded : null;
  } catch (error, stackTrace) {
    // Optional prefill: a failed lookup is not an address-save failure.
    logSuppressedError(error, stackTrace);
    return null;
  } finally {
    client.close(force: true);
  }
}
