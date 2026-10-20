import 'package:flutter_test/flutter_test.dart';

import 'package:encueypay/core/domain/bakong_account.dart';

void main() {
  group('sanitizeBakongAccountId', () {
    test('accepts a bare alias@bank ID', () {
      expect(sanitizeBakongAccountId('khqr@aclb'), 'khqr@aclb');
      expect(sanitizeBakongAccountId('  user@aba '), 'user@aba');
      expect(sanitizeBakongAccountId('077518564@wing'.toLowerCase()),
          '077518564@wing');
    });

    test('recovers the ID from a pasted full KHQR payload', () {
      // The real payload the admin obtained by scanning their own bank-app
      // QR with a generic scanner — the whole EMV string, not just the ID.
      const payload =
          '00020101021129380009khqr@aclb0111855239118970206ACLEDA391300042CCY'
          '01014520459995802KH53031165911RY CHANROTH6010Phnom Penh'
          '621302090775185646304C6B4';
      expect(sanitizeBakongAccountId(payload), 'khqr@aclb');
    });

    test('extracts all three pieces from a pasted ACLEDA payload', () {
      const payload =
          '00020101021129380009khqr@aclb0111855239118970206ACLEDA391300042CCY'
          '01014520459995802KH53031165911RY CHANROTH6010Phnom Penh'
          '621302090775185646304C6B4';
      final parts = extractBakongAccountParts(payload)!;
      expect(parts.accountId, 'khqr@aclb');
      expect(parts.accountInformation, '85523911897');
      expect(parts.acquiringBank, 'ACLEDA');
    });

    test('returns null for garbage', () {
      expect(sanitizeBakongAccountId(''), isNull);
      expect(sanitizeBakongAccountId('no-at-sign'), isNull);
      expect(sanitizeBakongAccountId('spaces in id@a'), isNull);
    });
  });
}
