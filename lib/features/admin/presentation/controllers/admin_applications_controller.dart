import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/admin_repository_impl.dart';
import '../../domain/entities/admin.dart';

part 'admin_applications_controller.g.dart';

@riverpod
class AdminApplicationsController extends _$AdminApplicationsController {
  @override
  Future<List<AdminApplication>> build() async {
    return ref.watch(adminRepositoryProvider).fetchPendingApplications();
  }

  Future<void> review({
    required String applicationId,
    required bool approve,
    String? reason,
  }) async {
    final current = state.value ?? const <AdminApplication>[];
    state = await AsyncValue.guard(() async {
      await ref.read(adminRepositoryProvider).reviewApplication(
            applicationId: applicationId,
            approve: approve,
            reason: reason,
          );
      ref.invalidateSelf();
      return current;
    });
  }
}
