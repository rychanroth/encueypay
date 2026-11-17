import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/network/failure_mapping.dart';
import '../../../../core/domain/stream_result.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../domain/entities/app_user.dart';
import '../dtos/user_dto.dart';
import '../mappers/user_mapper.dart';
import 'auth_repository.dart';

/// Exposes the interface type, never the impl (DATA-07).
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(supabaseClientProvider));
});

/// Deep link the OAuth provider redirects back to on mobile/desktop. Must be
/// registered in the dashboard (Auth → URL Configuration → Redirect URLs)
/// and in the platform manifests (Android intent-filter / iOS URL scheme).
/// The SDK subscribes to the deep links itself — no app-side listener.
///
/// Web cannot use a custom scheme: the browser returns to the page the app
/// is served from (the SDK then exchanges the `?code=` in that URL), so
/// [_webOauthRedirect] reports that origin instead.
const _oauthRedirect = 'io.supabase.encueypay://login-callback/';

/// Where the browser returns after Google on web: the app's own URL with the
/// query and fragment stripped (hash routing keeps the route in a `#/...`
/// fragment, which must not leak into `redirectTo`). Rebuilt explicitly
/// because `Uri.replace` treats null arguments as "keep the current value".
/// The path is preserved so a sub-path deployment still returns correctly.
String get _webOauthRedirect {
  final base = Uri.base;
  // Root deployments return to the bare origin, matching the allow-list
  // entry (Supabase compares exact URLs). A sub-path deployment keeps its
  // path so the app, not the host root, receives the code.
  final path = base.path == '/' ? '' : base.path;
  return Uri(
    scheme: base.scheme,
    host: base.host,
    port: base.port,
    path: path,
  ).toString();
}

class AuthRepositoryImpl implements IAuthRepository {
  AuthRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Stream<StreamResult<AppUser?>> watchSession() {
    return _client.auth.onAuthStateChange.asyncMap((event) async {
      final session = event.session;
      if (session == null) return null;
      return _loadAppUser(session);
    }).asStreamResult(_mapError);
  }

  Future<AppUser?> _loadAppUser(Session session) async {
    final user = session.user;
    final email = user.email;

    final row = await _client.from('users').select().eq('id', user.id).maybeSingle();
    if (row == null) {
      // `users` row missing (e.g. account created before the backend
      // trigger existed). Fall back to a minimal profile so the session
      // stays usable instead of failing the whole app.
      final metadataName = user.userMetadata?['full_name'] as String?;
      return AppUser(id: user.id, email: email, fullName: metadataName ?? '');
    }
    return UserDto.fromJson(row).toDomain(email: email);
  }

  @override
  Future<void> signInWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
    } catch (error, stackTrace) {
      throw _mapError(error, stackTrace);
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
    } catch (error, stackTrace) {
      throw _mapError(error, stackTrace);
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (error, stackTrace) {
      throw _mapError(error, stackTrace);
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      final launched = await _client.auth
          .signInWithOAuth(
            OAuthProvider.google,
            redirectTo: kIsWeb ? _webOauthRedirect : _oauthRedirect,
          )
          .timeout(const Duration(seconds: 20));
      if (!launched) {
        // The SDK returns false when the platform could not open the
        // browser. Without this the button silently no-ops.
        throw const NetworkFailure(
          'Could not open Google sign-in. Check that a browser is available '
          'and try again.',
        );
      }
    } on Failure {
      rethrow;
    } on TimeoutException {
      throw const NetworkFailure(
        'Google sign-in took too long. Please try again.',
      );
    } catch (error, stackTrace) {
      throw _mapError(error, stackTrace);
    }
  }

  @override
  Future<AppUser> completeCustomerOnboarding({
    required String fullName,
    required String phone,
  }) async {
    try {
      final session = _client.auth.currentSession;
      if (session == null) throw const ServerFailure('Not authenticated');
      final updated = await _client
          .from('users')
          .update({
            'full_name': fullName,
            'phone': phone,
            'onboarded_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', session.user.id)
          .select('id');
      if (updated.isEmpty) throw const ServerFailure('Profile unavailable');
      final user = await _loadAppUser(session);
      if (user == null) throw const ServerFailure('Profile unavailable');
      return user;
    } catch (error, stackTrace) {
      throw _mapError(error, stackTrace);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (error, stackTrace) {
      throw _mapError(error, stackTrace);
    }
  }

  /// Fixed boundary mapping (DATA-05), centralized in the shared mapper —
  /// auth rejections are server responses and classify as ServerFailure.
  Failure _mapError(Object error, [StackTrace? stackTrace]) =>
      error is Failure ? error : mapRepositoryError(error, stackTrace);
}
