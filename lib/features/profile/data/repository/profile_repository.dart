import '../../domain/entities/user_profile.dart';

/// Profile contract for the profile feature (DATA-03).
abstract interface class IProfileRepository {
  /// Fetches the signed-in user's profile. Throws [Failure] only (DATA-05).
  Future<UserProfile> fetchMyProfile();

  Future<void> updateMyProfile({
    required String fullName,
    required String phone,
  });
}
