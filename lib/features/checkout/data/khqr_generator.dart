/// Minimal KHQR (Cambodia's Bakong-standardized EMVCo QR) payload builder
/// (Section 6b). Pure string construction per the public EMVCo/KHQR tag
/// layout — no SDK dependency (DEPS-03). The generated string is scannable
/// by KHQR-compliant banking apps; its MD5 is the transaction key for the
/// Bakong `check_transaction_by_md5` confirmation API.
///
/// NOTE (prototype): the tag layout mirrors the khqr-sdk convention
/// (GUI `KHQR`, individual/merchant account, dynamic POI). Verify a
/// generated code with a real banking app before pointing it at a
/// production account.
library;

class KhqrGenerator {
  KhqrGenerator._();

  /// Builds a dynamic KHQR payload. [accountId] is the Bakong account
  /// identifier (e.g. `user@aclb`); [amountMinor] is formatted in the
  /// currency's major units; [billNumber] ties the QR to the order.
  static String build({
    required String accountId,
    required String merchantName,
    required int amountMinor,
    String billNumber = '',
    bool khr = false,
  }) {
    final amount = (amountMinor / 100).toStringAsFixed(2);
    final buffer = StringBuffer()
      ..write(_tag('00', '01'))
      ..write(_tag('01', '12')) // dynamic QR
      ..write(_tag('29', _tag('00', 'KHQR') + _tag('01', accountId)))
      ..write(_tag('52', '5999')) // MCC: retail
      ..write(_tag('53', khr ? '116' : '840'))
      ..write(_tag('54', amount))
      ..write(_tag('58', 'KH'))
      ..write(_tag('59', _truncate(merchantName, 25)))
      ..write(_tag('60', _truncate('Phnom Penh', 15)))
      ..write(_tag('62', billNumber.isEmpty ? '' : _tag('05', billNumber)));
    final withoutCrc = buffer.toString();
    final crc = _crc16('$withoutCrc${_tag('63', '')}');
    return '$withoutCrc${_tag('63', crc)}';
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
