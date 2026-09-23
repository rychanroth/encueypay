/// Payment methods supported by the MVP (spec §20).
enum PaymentMethod {
  cod,
  bankTransfer;

  String get wireName => switch (this) {
        PaymentMethod.cod => 'cod',
        PaymentMethod.bankTransfer => 'bank_transfer',
      };

  static PaymentMethod fromWire(String? name) => switch (name) {
        'bank_transfer' => PaymentMethod.bankTransfer,
        _ => PaymentMethod.cod,
      };
}
