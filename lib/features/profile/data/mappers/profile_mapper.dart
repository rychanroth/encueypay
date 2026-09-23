import '../../domain/entities/user_profile.dart';
import '../dtos/profile_dto.dart';

extension ProfileDtoX on ProfileDto {
  /// Null defaults live here, never in the UI (DATA-02).
  UserProfile toDomain() {
    return UserProfile(
      id: id,
      fullName: fullName ?? '',
      phone: phone,
      avatarUrl: avatarUrl,
    );
  }
}
