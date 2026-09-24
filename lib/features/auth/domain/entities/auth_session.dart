import 'package:freezed_annotation/freezed_annotation.dart';

import 'app_user.dart';

part 'auth_session.freezed.dart';

/// Snapshot of the current authentication state surfaced by the auth
/// repository stream. The Supabase session object itself never leaves the
/// data layer.
@freezed
abstract class AuthSession with _$AuthSession {
  const factory AuthSession({
    required bool authenticated,
    AppUser? user,
  }) = _AuthSession;

  static AuthSession signedIn(AppUser user) =>
      AuthSession(authenticated: true, user: user);

  static AuthSession signedOut() => const AuthSession(authenticated: false);
}
