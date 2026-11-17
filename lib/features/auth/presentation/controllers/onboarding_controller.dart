import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/auth_repository_impl.dart';
import 'auth_controller.dart';

part 'onboarding_controller.g.dart';

/// Drives the final onboarding step. The write is server-confirmed before the
/// session state is updated (PRES-03): the router only leaves `/onboarding`
/// once `onboarded_at` is actually set.
@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  Future<void> build() async {}

  Future<void> complete({
    required String fullName,
    required String phone,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = await ref
          .read(authRepositoryProvider)
          .completeCustomerOnboarding(fullName: fullName, phone: phone);
      ref.read(authControllerProvider.notifier).applyUser(user);
    });
  }
}
