import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/stream_result.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/entities/auth_session.dart';
import '../dtos/user_dto.dart';
import '../mappers/user_mapper.dart';
import 'auth_repository.dart';

/// Exposes the interface type, never the impl (DATA-07).
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(supabaseClientProvider));
});

/// Deep link the OAuth provider redirects back to (mobile). Must be
/// registered in the dashboard (Auth → URL Configuration → Redirect URLs)
/// and in the platform manifests (Android intent-filter / iOS URL scheme).
const _oauthRedirect = 'io.supabase.encueypay://login-callback/';

class AuthRepositoryImpl implements IAuthRepository {
  AuthRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Stream<StreamResult<AuthSession>> watchSession() {
    return _client.auth.onAuthStateChange.asyncMap((event) async {
      final session = event.session;
      if (session == null) return const AuthSession.unauthenticated();
      return _loadAuthenticatedSession(session);
    }).asStreamResult(_mapError);
  }

  Future<AuthSession> _loadAuthenticatedSession(Session session) async {
    final user = session.user;
    final email = user.email;

    final row = await _client.from('users').select().eq('id', user.id).maybeSingle();
    if (row == null) {
      // `users` row missing (e.g. account created before the backend
      // trigger existed). Fall back to a minimal profile so the session
      // stays usable instead of failing the whole app.
      final metadataName = user.userMetadata?['full_name'] as String?;
      return AuthSession.authenticated(
        AppUser(id: user.id, email: email, fullName: metadataName ?? ''),
      );
    }
    return AuthSession.authenticated(
      UserDto.fromJson(row).toDomain(email: email),
    );
  }

  @override
  Future<void> signInWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
    } catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      await _client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );
    } catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      await _client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: _oauthRedirect,
      );
    } catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (error) {
      throw _mapError(error);
    }
  }

  /// Fixed boundary mapping (DATA-05). Auth rejections are server responses,
  /// so they map to [ServerFailure] with the server's message.
  Failure _mapError(Object error) {
    if (error is PostgrestException) return ServerFailure(error.message);
    if (error is AuthException) return ServerFailure(error.message);
    return const NetworkFailure();
  }
}
