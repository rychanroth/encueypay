import '../../domain/entities/role_application.dart';

/// Role application contract (spec §3, §58 Role ops) (DATA-03).
abstract interface class IRoleApplicationRepository {
  /// The user's latest application, if any.
  Future<RoleApplication?> fetchMyApplication();

  /// Submit (or replace a pending application, §3).
  Future<void> submit({required String requestedRole});
}
