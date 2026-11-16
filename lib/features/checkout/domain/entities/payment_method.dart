/// Payment methods a customer can choose at checkout (spec §20; §6b: QR
/// replaced manual bank transfer).
///
/// `bank_transfer` is a retired wire value with no write path left: it
/// survives only on legacy payment rows, where the orders feature's
/// `PaymentMethodKind` still parses and labels it.
enum PaymentMethod {
  cod,
  qr;

  String get wireName => name;
}
