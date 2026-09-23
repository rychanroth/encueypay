import '../../domain/entities/role_application.dart';
import '../dtos/role_application_dto.dart';

extension RoleApplicationDtoX on RoleApplicationDto {
  RoleApplication toDomain() {
    return RoleApplication(
      id: id,
      requestedRole: requestedRole,
      status: RoleApplicationStatus.fromName(status),
      createdAt: createdAt,
      decisionReason: decisionReason,
    );
  }
}
