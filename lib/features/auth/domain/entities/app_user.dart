import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_role.dart';

part 'app_user.freezed.dart';

/// Application-level user (spec §34) — conceptually distinct from the
/// Supabase auth identity. Immutable via freezed (DOMAIN-01): no Flutter,
/// json, or Supabase imports.
@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String id,
    String? email,
    required String fullName,
    String? avatarUrl,
    String? phone,
    @Default(UserRole.customer) UserRole activeRole,
    @Default(AccountStatus.active) AccountStatus accountStatus,
  }) = _AppUser;
}
