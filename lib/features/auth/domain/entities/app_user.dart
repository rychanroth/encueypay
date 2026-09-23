import 'user_role.dart';

/// Application-level user (spec §34) — conceptually distinct from the
/// Supabase auth identity. Plain immutable entity (DOMAIN-01): no Flutter,
/// json, or Supabase imports.
class AppUser {
  const AppUser({
    required this.id,
    this.email,
    required this.fullName,
    this.avatarUrl,
    this.phone,
    this.activeRole = UserRole.customer,
    this.accountStatus = AccountStatus.active,
  });

  final String id;
  final String? email;
  final String fullName;
  final String? avatarUrl;
  final String? phone;
  final UserRole activeRole;
  final AccountStatus accountStatus;
}
