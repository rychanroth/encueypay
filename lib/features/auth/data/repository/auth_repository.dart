import '../../../../core/domain/stream_result.dart';
import '../../domain/entities/app_user.dart';

/// Auth + session contract for the auth feature (DATA-03: interface lives
/// here, impl in `auth_repository_impl.dart`).
abstract interface class IAuthRepository {
  /// Emits the signed-in [AppUser] (fetched from the `users` table — the
  /// role that drives the per-role UI lives there, not in the auth
  /// session), or `null` when signed out. Failures surface as
  /// [StreamError] data events — the stream never terminates (DATA-06).
  Stream<StreamResult<AppUser?>> watchSession();

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

  /// Sends a Supabase password-reset email. The hosted reset page handles
  /// the new-password step.
  Future<void> sendPasswordResetEmail({required String email});

  /// Google OAuth — the primary sign-in method (DEPS-04).
  Future<void> signInWithGoogle();

  /// Completes the first-run customer onboarding: writes the (possibly
  /// corrected) name, the required phone and the `onboarded_at` flag in one
  /// update, then returns the refreshed [AppUser] for the router.
  Future<AppUser> completeCustomerOnboarding({
    required String fullName,
    required String phone,
  });

  Future<void> signOut();
}
