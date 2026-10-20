/// Bakong account handling shared by admin settings and checkout (§6b).
/// Lives in core/domain: both features consume it; core imports nothing
/// feature-specific (ARCH-03…05).
///
/// Ground truth: the official KHQR SDK's `IndividualInfo` — an individual
/// QR carries `bakongAccountID` (sub-tag 00 of the tag-29/30 template),
/// plus OPTIONAL `accountInformation` (sub-tag 01, the bank account
/// number) and `acquiringBank` (sub-tag 02). Some banks (ACLEDA among
/// them) embed a GENERIC id (e.g. `khqr@aclb`) in every consumer QR and
/// route via the account number — so a faithful QR reproduces all three
/// pieces, exactly as the receiver's own bank app encodes them.
library;

/// A Bakong ID is `alias@bank` (e.g. `khqr@aclb`), ≤ 32 chars per side.
final RegExp _plainPattern = RegExp(
  r'^[a-z0-9._%-]{1,32}@[a-z0-9._-]{1,32}$',
  caseSensitive: false,
);

/// The three pieces a receiver's bank QR encodes, ready for the KHQR
/// builder. [accountInformation]/[acquiringBank] are '' when the source
/// carries none (classic `alias@bank`-only scheme).
typedef BakongAccountParts = ({
  String accountId,
  String accountInformation,
  String acquiringBank,
});

BakongAccountParts? _fromParts(
  String accountId,
  String accountInformation,
  String acquiringBank,
) {
  if (!_plainPattern.hasMatch(accountId)) return null;
  return (
    accountId: accountId,
    accountInformation: accountInformation,
    acquiringBank: acquiringBank,
  );
}

/// Walks the EMVCo TLV structure of a KHQR payload and returns the
/// account-information template (tag 29 individual / 30 merchant) as
/// sub-tag → value.
Map<String, String>? _accountTemplateOf(String payload) {
  var i = 0;
  while (i + 4 <= payload.length) {
    final tag = payload.substring(i, i + 2);
    final length = int.tryParse(payload.substring(i + 2, i + 4));
    if (length == null || i + 4 + length > payload.length) return null;
    final content = payload.substring(i + 4, i + 4 + length);
    if (tag == '29' || tag == '30') {
      // Sub-walk the template.
      final subs = <String, String>{};
      var j = 0;
      while (j + 4 <= content.length) {
        final subTag = content.substring(j, j + 2);
        final subLength = int.tryParse(content.substring(j + 2, j + 4));
        if (subLength == null || j + 4 + subLength > content.length) break;
        subs[subTag] = content.substring(j + 4, j + 4 + subLength);
        j += 4 + subLength;
      }
      return subs;
    }
    i += 4 + length;
  }
  return null;
}

/// Extracts the account pieces from [raw]: either a bare `alias@bank` ID,
/// or a full KHQR payload string (the natural thing to paste — it is what
/// a generic QR scanner shows for the receiver's own bank QR). Returns
/// null when no valid Bakong ID can be recovered.
BakongAccountParts? extractBakongAccountParts(String raw) {
  final value = raw.trim();
  if (_plainPattern.hasMatch(value)) {
    return _fromParts(value, '', '');
  }
  final template = _accountTemplateOf(value);
  if (template == null) return null;
  final id = template['00'];
  if (id == null) return null;
  return _fromParts(
    id,
    template['01'] ?? '',
    template['02'] ?? '',
  );
}

/// Bare-ID convenience wrapper (legacy call sites).
String? sanitizeBakongAccountId(String raw) =>
    extractBakongAccountParts(raw)?.accountId;
