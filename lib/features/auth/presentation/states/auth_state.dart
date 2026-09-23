import '../../domain/entities/app_user.dart';

enum AuthStatus { loading, authenticated, unauthenticated, failure }

/// Immutable auth state consumed by the router redirect (ROUTE-10) and the
/// shell (PRES-02: const constructor, ==/hashCode, copyWith).
class AuthState {
  const AuthState._({
    required this.status,
    this.user,
    this.message,
  });

  const AuthState.loading()
      : status = AuthStatus.loading,
        user = null,
        message = null;

  const AuthState.authenticated(this.user)
      : status = AuthStatus.authenticated,
        message = null;

  const AuthState.unauthenticated()
      : status = AuthStatus.unauthenticated,
        user = null,
        message = null;

  const AuthState.failure(this.message)
      : status = AuthStatus.failure,
        user = null;

  final AuthStatus status;
  final AppUser? user;
  final String? message;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  AuthState copyWith({AppUser? user, String? message}) {
    return AuthState._(
      status: status,
      user: user ?? this.user,
      message: message ?? this.message,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthState &&
          other.status == status &&
          other.user == user &&
          other.message == message;

  @override
  int get hashCode => Object.hash(status, user, message);
}
