/// The receiver's KHQR account pieces, exactly as the official KHQR SDK's
/// `IndividualInfo` carries them (Section 6b): the Bakong account field
/// (sub-tag 00 — note some banks embed a GENERIC id, e.g. ACLEDA's
/// `khqr@aclb`), plus the optional disambiguators that make the generated
/// QR faithful to the receiver's own bank QR: the bank account number
/// (sub-tag 01) and acquiring bank (sub-tag 02). Empty strings mean the
/// piece is absent (classic `alias@bank`-only scheme).
class QrPaymentAccount {
  const QrPaymentAccount({
    required this.accountId,
    this.accountInformation = '',
    this.acquiringBank = '',
  });

  final String accountId;
  final String accountInformation;
  final String acquiringBank;

  bool get isConfigured => accountId.isNotEmpty;
}
