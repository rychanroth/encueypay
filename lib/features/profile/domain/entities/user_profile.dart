/// The signed-in user's profile as edited within the profile feature.
/// Plain immutable entity (DOMAIN-01). Email is not editable here (it lives
/// with the auth identity) and is intentionally not part of this model.
class UserProfile {
  const UserProfile({
    required this.id,
    required this.fullName,
    this.phone,
    this.avatarUrl,
  });

  final String id;
  final String fullName;
  final String? phone;
  final String? avatarUrl;
}
