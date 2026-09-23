import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/admin_repository_impl.dart';
import '../../domain/entities/admin.dart';

part 'admin_settings_controller.g.dart';

@riverpod
class AdminSettingsController extends _$AdminSettingsController {
  @override
  Future<PlatformSettings> build() async {
    return ref.watch(adminRepositoryProvider).fetchPlatformSettings();
  }

  Future<void> save(PlatformSettings settings) async {
    final current = state.value;
    state = await AsyncValue.guard(() async {
      await ref.read(adminRepositoryProvider).updatePlatformSettings(settings);
      ref.invalidateSelf();
      return current ?? settings;
    });
  }
}
