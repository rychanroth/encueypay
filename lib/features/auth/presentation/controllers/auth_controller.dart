import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/stream_result.dart';
import '../../data/repository/auth_repository_impl.dart';
import '../../domain/entities/app_user.dart';

part 'auth_controller.g.dart';

/// Session stream controller — the single provider the router redirect
/// (ROUTE-10) and the shell listen to.
///
/// State is exactly what the docs-style pattern needs: `AsyncValue<AppUser?>`
/// — loading while the first event arrives, `data: null` = signed out,
/// `data: user` = signed in (with the role from the `users` table), error on
/// failure. No custom auth state class. Mutations never set optimistic state
/// (PRES-03); the SDK handles session persistence, token refreshes and deep
/// links internally.
@riverpod
class AuthController extends _$AuthController {
  @override
  Stream<AppUser?> build() {
    final repository = ref.watch(authRepositoryProvider);
    return repository.watchSession().map((result) {
      return switch (result) {
        StreamData(:final data) => data,
        StreamError(:final failure) => throw failure,
      };
    });
  }

  /// The session stream emits the unauthenticated event on its own; no
  /// optimistic state change here (PRES-03).
  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
  }
}
