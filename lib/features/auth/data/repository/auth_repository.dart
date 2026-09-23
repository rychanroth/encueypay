import '../../../../core/domain/failures.dart';
import '../../../../core/domain/stream_result.dart';
import '../../domain/entities/auth_session.dart';

/// Auth + session contract for the auth feature (DATA-03: interface lives
/// here, impl in `auth_repository_impl.dart`).
abstract interface class IAuthRepository {
  /// Emits the current session snapshot on every auth state change
  /// (sign-in, sign-out, token refresh). Failures surface as [StreamError]
  /// data events — the stream never terminates (DATA-06).
  Stream<StreamResult<AuthSession>> watchSession();

  /// Signs in with email/password. Throws [Failure] subtypes only (DATA-05).
  Future<void> signInWithPassword({
    required String email,
    required String password,
  });

  /// Registers a new account — every new account is a Customer (spec §3).
  /// [fullName] goes into the auth metadata and is copied into `users` by
  /// the backend trigger.
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  });

  /// Google OAuth — the primary sign-in method (DEPS-04).
  Future<void> signInWithGoogle();

  Future<void> signOut();
}
