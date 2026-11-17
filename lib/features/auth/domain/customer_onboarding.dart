import 'entities/app_user.dart';
import 'entities/user_role.dart';

/// Whether the router must hold this user on the customer onboarding flow.
///
/// Only `customer` is onboarded — admins and the legacy business/driver roles
/// go straight to their surface. Null (signed out) never onboards.
bool needsCustomerOnboarding(AppUser? user) {
  return user != null &&
      user.activeRole == UserRole.customer &&
      user.onboardedAt == null;
}

final RegExp _phoneAllowed = RegExp(r'^[\d\s\-().]+$');

/// Normalizes a customer-entered phone number, or returns null when invalid.
///
/// Accepts 8–15 digits with optional spaces, dashes, dots and parentheses;
/// a leading `+` is preserved. Everything else is rejected so a typo is
/// caught before it reaches the profile.
String? normalizeCustomerPhone(String input) {
  final trimmed = input.trim();
  if (trimmed.isEmpty) return null;

  final hasPlus = trimmed.startsWith('+');
  final body = hasPlus ? trimmed.substring(1) : trimmed;
  if (!_phoneAllowed.hasMatch(body)) return null;

  final digits = body.replaceAll(RegExp(r'\D'), '');
  if (digits.length < 8 || digits.length > 15) return null;
  return hasPlus ? '+$digits' : digits;
}
