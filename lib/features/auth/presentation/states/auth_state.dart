import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/app_user.dart';

part 'auth_state.freezed.dart';

enum AuthStatus { loading, authenticated, unauthenticated, failure }

/// Immutable auth state consumed by the router redirect (ROUTE-10) and the
/// shell (PRES-02: immutability, ==/hashCode and copyWith via freezed).
@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    required AuthStatus status,
    AppUser? user,
    String? message,
  }) = _AuthState;

  const AuthState._();

  static AuthState loading() => const AuthState(status: AuthStatus.loading);

  static AuthState authenticated(AppUser user) =>
      AuthState(status: AuthStatus.authenticated, user: user);

  static AuthState unauthenticated() =>
      const AuthState(status: AuthStatus.unauthenticated);

  static AuthState failure(String message) =>
      AuthState(status: AuthStatus.failure, message: message);

  bool get isAuthenticated => status == AuthStatus.authenticated;
}
