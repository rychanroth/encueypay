/// Payment methods supported by the MVP (spec §20; §6b: QR replaces manual
/// bank transfer in the UI — the wire value stays for legacy rows).
enum PaymentMethod {
  cod,
  bankTransfer,
  qr;

  String get wireName => switch (this) {
        PaymentMethod.cod => 'cod',
        PaymentMethod.bankTransfer => 'bank_transfer',
        PaymentMethod.qr => 'qr',
      };

  static PaymentMethod fromWire(String? name) => switch (name) {
        'bank_transfer' => PaymentMethod.bankTransfer,
        'qr' => PaymentMethod.qr,
        _ => PaymentMethod.cod,
      };
}
