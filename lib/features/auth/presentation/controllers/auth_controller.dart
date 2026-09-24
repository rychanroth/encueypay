import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/stream_result.dart';
import '../../data/repository/auth_repository_impl.dart';
import '../states/auth_state.dart';

part 'auth_controller.g.dart';

/// Session stream controller — the single provider the router redirect
/// (ROUTE-10) and the shell listen to. State is ground truth from the
/// backend; mutations never set optimistic state (PRES-03).
@riverpod
class AuthController extends _$AuthController {
  @override
  Stream<AuthState> build() {
    final repository = ref.watch(authRepositoryProvider);
    return repository.watchSession().map((result) {
      return switch (result) {
        StreamData(:final data) => data.authenticated
            ? AuthState.authenticated(data.user!)
            : AuthState.unauthenticated(),
        StreamError(:final failure) => AuthState.failure(failure.message),
      };
    });
  }

  /// The session stream emits the unauthenticated event on its own; no
  /// optimistic state change here (PRES-03).
  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
  }
}
