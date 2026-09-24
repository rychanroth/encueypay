import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';

/// The signed-in user's profile as edited within the profile feature.
/// Immutable via freezed (DOMAIN-01). Email is not editable here (it lives
/// with the auth identity) and is intentionally not part of this model.
@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    @Default('') String fullName,
    String? phone,
    String? avatarUrl,
  }) = _UserProfile;
}
