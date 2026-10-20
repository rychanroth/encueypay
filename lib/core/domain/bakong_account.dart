/// Bakong account-ID handling shared by admin settings and checkout (§6b).
/// Lives in core/domain: both features consume it; core imports nothing
/// feature-specific (ARCH-03…05).
library;

/// A Bakong ID is `alias@bank` (e.g. `khqr@aclb`), ≤ 32 chars per side.
final RegExp _plainPattern = RegExp(
  r'^[a-z0-9._%-]{1,32}@[a-z0-9._-]{1,32}$',
  caseSensitive: false,
);

/// The account-information template inside a KHQR payload — tag 29
/// (individual) or 30 (merchant), whose sub-tag 00 carries the
/// `alias@bank` ID with its 2-digit TLV length. Anchoring here recovers
/// the ID when the whole KHQR payload string was pasted by mistake.
final RegExp _embeddedPattern = RegExp(
  r'(?:29|30)\d{2}00\d{2}([a-z0-9._-]{1,32}@[a-z]{2,12})',
  caseSensitive: false,
);

/// Returns the bare Bakong ID from [raw], or null when no valid ID can be
/// recovered. Accepts the ID as-is, or a full KHQR payload string (the
/// common mistake: pasting what a generic QR scanner shows — the whole
/// EMV string — instead of just the `alias@bank` it encodes).
String? sanitizeBakongAccountId(String raw) {
  final value = raw.trim();
  if (_plainPattern.hasMatch(value)) return value;
  for (final match in _embeddedPattern.allMatches(value)) {
    final candidate = match.group(1)!;
    if (_plainPattern.hasMatch(candidate)) return candidate;
  }
  return null;
}
