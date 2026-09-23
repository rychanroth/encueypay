import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/auth_repository_impl.dart';

part 'login_controller.g.dart';

/// Drives the login form. Mutations follow PRES-03: `AsyncValue.guard`,
/// no optimistic UI — on success the session stream updates and the router
/// redirect takes over (ROUTE-10).
@riverpod
class LoginController extends _$LoginController {
  @override
  Future<void> build() async {}

  Future<void> signInWithPassword({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).signInWithPassword(
            email: email,
            password: password,
          ),
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).signUp(
            email: email,
            password: password,
            fullName: fullName,
          ),
    );
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).signInWithGoogle(),
    );
  }
}
