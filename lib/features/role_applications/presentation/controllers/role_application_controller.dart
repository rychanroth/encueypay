import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/role_application_repository_impl.dart';
import '../../domain/entities/role_application.dart';

part 'role_application_controller.g.dart';

@riverpod
class RoleApplicationController extends _$RoleApplicationController {
  @override
  Future<RoleApplication?> build() async {
    return ref.watch(roleApplicationRepositoryProvider).fetchMyApplication();
  }

  Future<void> submit({required String requestedRole}) async {
    final current = state.value;
    state = await AsyncValue.guard(() async {
      await ref
          .read(roleApplicationRepositoryProvider)
          .submit(requestedRole: requestedRole);
      ref.invalidateSelf();
      return current;
    });
  }
}
