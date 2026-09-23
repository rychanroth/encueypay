import '../../domain/entities/app_user.dart';
import '../../domain/entities/user_role.dart';
import '../dtos/user_dto.dart';

extension UserDtoX on UserDto {
  /// Maps the wire row to [AppUser]. Null defaults live here — never in the
  /// UI (DATA-02). [email] comes from the auth identity, not the table.
  AppUser toDomain({String? email}) {
    return AppUser(
      id: id,
      email: email,
      fullName: fullName ?? '',
      avatarUrl: avatarUrl,
      phone: phone,
      activeRole: UserRole.fromName(activeRole),
      accountStatus: AccountStatus.fromName(accountStatus),
    );
  }
}
