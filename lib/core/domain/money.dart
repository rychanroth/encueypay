import 'package:freezed_annotation/freezed_annotation.dart';

part 'money.freezed.dart';

/// NBC reference peg (DESIGN.md §1.4): 4,100 KHR per USD. Display-only —
/// the server remains authoritative for every amount.
const int kKhrPerUsd = 4100;

/// Thousands-separator grouping for display strings (`1234567` →
/// `1,234,567`; `10.50` → `10.50` — the fractional part is untouched).
String _group(String digits) {
  final negative = digits.startsWith('-');
  final body = negative ? digits.substring(1) : digits;
  final dot = body.indexOf('.');
  final intPart = dot == -1 ? body : body.substring(0, dot);
  final rest = dot == -1 ? '' : body.substring(dot);

  final buffer = StringBuffer();
  for (var i = 0; i < intPart.length; i++) {
    final remaining = intPart.length - i;
    buffer.write(intPart[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  final grouped = '$buffer$rest';
  return negative ? '-$grouped' : grouped;
}

/// Exact monetary value in minor units (spec §22: never rely on binary
/// floating point for financial calculations).
///
/// Amounts are stored and computed everywhere as `int` minor units;
/// [Money] exists only to parse user input and format display strings —
/// no `double` ever touches an amount.
@freezed
abstract class Money with _$Money {
  const factory Money(int minorUnits) = _Money;

  const Money._();

  static const Money zero = Money(0);

  /// Parses a decimal string like `"10"`, `"10.5"`, `"10.50"` into minor
  /// units without touching binary floating point.
  ///
  /// Throws [FormatException] for empty input, more than two decimal
  /// places, or non-numeric characters.
  static Money parse(String input) {
    final text = input.trim();
    if (text.isEmpty) {
      throw const FormatException('Empty amount');
    }

    final negative = text.startsWith('-');
    final body = negative ? text.substring(1) : text;
    final parts = body.split('.');
    if (parts.length > 2) {
      throw FormatException('Invalid amount: $input');
    }

    final whole = parts[0];
    final fraction = parts.length == 2 ? parts[1] : '';
    if (whole.isEmpty && fraction.isEmpty) {
      throw FormatException('Invalid amount: $input');
    }
    if (whole.isNotEmpty && int.tryParse(whole) == null) {
      throw FormatException('Invalid amount: $input');
    }
    if (fraction.isNotEmpty && int.tryParse(fraction) == null) {
      throw FormatException('Invalid amount: $input');
    }
    if (fraction.length > 2) {
      throw FormatException('At most 2 decimal places: $input');
    }

    final cents = (whole.isEmpty ? 0 : int.parse(whole)) * 100 +
        (fraction.isEmpty ? 0 : int.parse(fraction.padRight(2, '0')));
    return Money(negative ? -cents : cents);
  }

  /// `"10.50"` — optionally prefixed with [symbol].
  String format({String? symbol}) {
    final negative = minorUnits < 0;
    final cents = minorUnits.abs();
    final whole = cents ~/ 100;
    final fraction = (cents % 100).toString().padLeft(2, '0');
    final sign = negative ? '-' : '';
    final amount = '$sign$whole.$fraction';
    return symbol == null ? amount : '$symbol$amount';
  }

  /// `"$10.50"` — USD primary display (§1.4 dual-currency peg), with
  /// thousands separators and no floating point (pure integer math).
  String formatUsd() => '\$${_group(format())}';

  /// `"43,050 KHR"` — Cambodian Riel secondary display, pegged at the NBC
  /// reference rate of 4,100 KHR per USD (DESIGN.md §1.4/§2).
  ///
  /// Integer-exact: 4,100 KHR / 100 minor units = 41 KHR per cent, so the
  /// conversion is `minorUnits * 41` — no `double` ever touches an amount.
  String formatKhr() => '${_group((minorUnits.abs() * kKhrPerUsd ~/ 100).toString())} KHR';

  /// Approximate Riel amount in whole KHR (minor units × 41 — see
  /// [formatKhr]).
  int get khrApproximate => minorUnits * kKhrPerUsd ~/ 100;

  Money operator +(Money other) => Money(minorUnits + other.minorUnits);

  Money operator -(Money other) => Money(minorUnits - other.minorUnits);

  Money multipliedBy(int quantity) => Money(minorUnits * quantity);

  @override
  String toString() => 'Money(${format()})';
}
