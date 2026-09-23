import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/profile_repository_impl.dart';
import '../../domain/entities/user_profile.dart';

part 'profile_controller.g.dart';

/// Plain one-shot fetch + mutation — controllers MAY call the repository
/// directly for fetches (DOMAIN-03). Mutations follow PRES-03.
@riverpod
class ProfileController extends _$ProfileController {
  @override
  Future<UserProfile> build() async {
    return ref.watch(profileRepositoryProvider).fetchMyProfile();
  }

  Future<void> updateProfile({
    required String fullName,
    required String phone,
  }) async {
    final current = state.value ?? const UserProfile(id: '', fullName: '');
    state = await AsyncValue.guard(() async {
      await ref.read(profileRepositoryProvider).updateMyProfile(
            fullName: fullName,
            phone: phone,
          );
      ref.invalidateSelf(); // re-run build() for backend truth (PRES-03)
      return UserProfile(
        id: current.id,
        fullName: fullName,
        phone: phone,
        avatarUrl: current.avatarUrl,
      );
    });
  }
}
