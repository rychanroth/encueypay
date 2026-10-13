import 'package:flutter_test/flutter_test.dart';

import 'package:encueypay/core/domain/money.dart';

void main() {
  group('Money (spec §22 — exact decimal handling, no binary floating point)', () {
    test('parses plain integers', () {
      expect(Money.parse('10').minorUnits, 1000);
    });

    test('parses two-decimal strings', () {
      expect(Money.parse('125.50').minorUnits, 12550);
    });

    test('pads single decimal digit', () {
      expect(Money.parse('999.9').minorUnits, 99990);
    });

    test('formats USD with symbol and thousands separators', () {
      expect(Money.parse('10.50').formatUsd(), r'$10.50');
      expect(Money.parse('1234567.89').formatUsd(), r'$1,234,567.89');
    });

    /// DESIGN.md §1.4/§2: dual currency at the NBC peg — integer-exact
    /// (41 KHR per cent), no floating point anywhere.
    test('formats KHR at the 4,100 KHR/USD peg', () {
      expect(Money.parse('10.00').formatKhr(), '41,000 KHR');
      expect(Money.parse('10.00').khrApproximate, 41000);
      expect(Money.parse('0.01').khrApproximate, 41);
      expect(Money.parse('91.93').khrApproximate, 376913);
    });

    test('formats back to a display string', () {
      expect(Money.parse('10.00').format(), '10.00');
      expect(Money.parse('125.5').format(symbol: r'$'), r'$125.50');
    });

    test('adds without floating-point error', () {
      // 0.1 + 0.2 != 0.3 in binary floating point — must be exact here.
      final sum = Money.parse('0.1') + Money.parse('0.2');
      expect(sum.format(), '0.30');
    });

    test('multiplies quantities exactly', () {
      expect(Money.parse('10.10').multipliedBy(3).format(), '30.30');
    });

    test('rejects more than two decimal places', () {
      expect(() => Money.parse('1.234'), throwsFormatException);
    });

    test('rejects garbage input', () {
      expect(() => Money.parse('abc'), throwsFormatException);
      expect(() => Money.parse(''), throwsFormatException);
      expect(() => Money.parse('1.2.3'), throwsFormatException);
    });
  });
}
