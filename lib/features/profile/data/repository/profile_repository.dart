import '../../domain/entities/user_profile.dart';
import '../../../../core/domain/picked_file.dart';

/// Profile contract for the profile feature (DATA-03).
abstract interface class IProfileRepository {
  /// Fetches the signed-in user's profile. Throws [Failure] only (DATA-05).
  Future<UserProfile> fetchMyProfile();

  Future<void> updateMyProfile({
    required String fullName,
    required String phone,
  });

  /// Uploads [image] to the public `avatars` bucket under the caller's
  /// `{uid}/` folder and stores the resolved public URL on the user row.
  Future<void> updateMyAvatar({required PickedFile image});
}
