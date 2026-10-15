/// KHQR (Cambodia's Bakong-standardized EMVCo QR) payload builder (§6b).
///
/// Mirrors the official `bakong-khqr` SDK EMV template (npm bakong-khqr
/// v1.0.20, src/controller/generateKHQR.js) — verified against the SDK's
/// own test vectors in `test/khqr_generator_test.dart`. The earlier
/// hand-rolled layout was invalid on four counts: it placed a 'KHQR' GUI
/// string in sub-tag 00 (sub-tag 00 IS the Bakong account ID — there is no
/// GUI sub-tag), put the account in sub-tag 01, put the bill number in
/// sub-tag 05 (spec: 01), and omitted tag 99 (creation/expiration
/// timestamps — REQUIRED for dynamic QRs). No SDK dependency (DEPS-03):
/// the template is small and pinned by tests.
///
/// The generated string's MD5 is the transaction key for the Bakong
/// `check_transaction_by_md5` confirmation API (computed server-side from
/// the registered payload). Scan with a real banking app before pointing
/// the flow at a production account.
library;

class KhqrGenerator {
  KhqrGenerator._();

  /// Builds a dynamic KHQR payload. [accountId] is the personal Bakong ID
  /// (`name@bank`, e.g. `user@aclb`); [amountMinor] is USD cents — the app's
  /// money model is USD, so the QR is always USD (`53` 840); [billNumber]
  /// ties the QR to the order; [validity] sets the tag-99 expiration
  /// (dynamic KHQRs require one).
  static String build({
    required String accountId,
    required String merchantName,
    required int amountMinor,
    String billNumber = '',
    String city = 'Phnom Penh',
    Duration validity = const Duration(hours: 24),
  }) {
    assert(accountId.isNotEmpty && accountId.contains('@'),
        'accountId must be a Bakong ID like user@bank');
    assert(amountMinor >= 0);
    assert(billNumber.length <= 25);

    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final expirationMs = nowMs + validity.inMilliseconds;

    final buffer = StringBuffer()
      ..write(_tag('00', '01')) // payload format indicator
      ..write(_tag('01', '12')) // dynamic QR (amount present)
      // Merchant account information — individual template (29). Sub-tag 00
      // carries the Bakong account ID directly; there is no GUI sub-tag.
      ..write(_tag('29', _tag('00', accountId)))
      ..write(_tag('52', '5999')) // MCC: retail
      ..write(_tag('53', '840')) // USD
      ..write(_tag('54', _formatUsdAmount(amountMinor)))
      ..write(_tag('58', 'KH'))
      ..write(_tag('59', _truncate(merchantName, 25)))
      ..write(_tag('60', _truncate(city, 15)));
    if (billNumber.isNotEmpty) {
      // Additional data — bill number is sub-tag 01 in the KHQR template.
      buffer.write(_tag('62', _tag('01', billNumber)));
    }
    // Timestamp — REQUIRED for dynamic KHQRs: creation (00) + expiration
    // (01), epoch milliseconds.
    buffer.write(
        _tag('99', _tag('00', '$nowMs') + _tag('01', '$expirationMs')));
    final withoutCrc = buffer.toString();
    final crc = _crc16('$withoutCrc${_tag('63', '')}');
    return '$withoutCrc${_tag('63', crc)}';
  }

  /// USD amount from minor units, mirroring the SDK: whole-dollar amounts
  /// print bare (`1`), fractional amounts print exactly two decimals
  /// (`10.50`).
  static String _formatUsdAmount(int amountMinor) {
    final whole = amountMinor ~/ 100;
    final cents = amountMinor % 100;
    if (cents == 0) return '$whole';
    return '$whole.${cents.toString().padLeft(2, '0')}';
  }

  static String _tag(String tag, String value) =>
      '$tag${value.length.toString().padLeft(2, '0')}$value';

  static String _truncate(String value, int max) =>
      value.length <= max ? value : value.substring(0, max);

  /// CRC-16/CCITT-FALSE (poly 0x1021, init 0xFFFF) — the KHQR checksum.
  static String _crc16(String input) {
    var crc = 0xFFFF;
    for (final byte in input.codeUnits) {
      crc ^= byte << 8;
      for (var i = 0; i < 8; i++) {
        crc = (crc & 0x8000) != 0 ? (crc << 1) ^ 0x1021 : crc << 1;
        crc &= 0xFFFF;
      }
    }
    return crc.toRadixString(16).padLeft(4, '0').toUpperCase();
  }
}
