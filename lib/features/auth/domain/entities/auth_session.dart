import 'app_user.dart';

/// Snapshot of the current authentication state surfaced by the auth
/// repository stream. The Supabase session object itself never leaves the
/// data layer.
class AuthSession {
  const AuthSession.authenticated(this.user) : authenticated = true;

  const AuthSession.unauthenticated()
      : authenticated = false,
        user = null;

  final bool authenticated;
  final AppUser? user;
}
