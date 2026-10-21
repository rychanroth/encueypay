import 'package:flutter_test/flutter_test.dart';

import 'package:encueypay/core/domain/bakong_account.dart';

void main() {
  group('sanitizeBakongAccountId', () {
    test('accepts a bare alias@bank ID', () {
      expect(sanitizeBakongAccountId('janedoe@aclb'), 'janedoe@aclb');
      expect(sanitizeBakongAccountId('  user@aba '), 'user@aba');
      expect(
          sanitizeBakongAccountId('098765432@wing'.toLowerCase()),
          '098765432@wing');
    });

    test('recovers the ID from a pasted full KHQR payload', () {
      const payload =
          '00020101021129400012janedoe@aclb011009998887770206MYBANK'
          '5204599953031165802KH5908Jane Doe6010Phnom Penh'
          '6213020907700000006304ABCD';
      expect(sanitizeBakongAccountId(payload), 'janedoe@aclb');
    });

    test('extracts all three pieces from a pasted bank-QR payload', () {
      // Synthetic structural twin of a real consumer KHQR: generic bank id
      // (tag 29 / sub-tag 00) + account number (01) + acquiring bank (02).
      const payload =
          '00020101021129400012janedoe@aclb011009998887770206MYBANK'
          '5204599953031165802KH5908Jane Doe6010Phnom Penh'
          '6213020907700000006304ABCD';
      final parts = extractBakongAccountParts(payload)!;
      expect(parts.accountId, 'janedoe@aclb');
      expect(parts.accountInformation, '0999888777');
      expect(parts.acquiringBank, 'MYBANK');
    });

    test('returns null for garbage', () {
      expect(sanitizeBakongAccountId(''), isNull);
      expect(sanitizeBakongAccountId('no-at-sign'), isNull);
      expect(sanitizeBakongAccountId('spaces in id@a'), isNull);
    });
  });
}
