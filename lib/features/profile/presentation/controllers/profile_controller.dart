import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/picked_file.dart';
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

  /// Uploads a new avatar and refetches the profile. Returns the failure (or
  /// null on success) instead of replacing the loaded profile with an error
  /// surface — a bad upload must not wipe the screen (PRES-03, UX brief §4).
  Future<Object?> updateAvatar({required PickedFile image}) async {
    final result = await AsyncValue.guard(
      () => ref
          .read(profileRepositoryProvider)
          .updateMyAvatar(image: image),
    );
    if (result.hasError) return result.error;
    ref.invalidateSelf(); // re-run build() for the new URL (PRES-03)
    return null;
  }
}
