/// Exact monetary value in minor units (spec §22: never rely on binary
/// floating point for financial calculations).
///
/// Amounts are stored and computed everywhere as `int` minor units;
/// [Money] exists only to parse user input and format display strings —
/// no `double` ever touches an amount.
class Money {
  const Money(this.minorUnits);

  static const Money zero = Money(0);

  final int minorUnits;

  /// Parses a decimal string like `"10"`, `"10.5"`, `"10.50"` into minor
  /// units without touching binary floating point.
  ///
  /// Throws [FormatException] for empty input, more than two decimal
  /// places, or non-numeric characters.
  factory Money.parse(String input) {
    final text = input.trim();
    if (text.isEmpty) {
      throw FormatException('Empty amount');
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

  Money operator +(Money other) => Money(minorUnits + other.minorUnits);

  Money operator -(Money other) => Money(minorUnits - other.minorUnits);

  Money multipliedBy(int quantity) => Money(minorUnits * quantity);

  @override
  bool operator ==(Object other) =>
      other is Money && other.minorUnits == minorUnits;

  @override
  int get hashCode => minorUnits.hashCode;

  @override
  String toString() => 'Money(${format()})';
}
