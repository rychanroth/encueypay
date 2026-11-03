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

  /// Saves without replacing the form with an AsyncError. Returns the
  /// failure for the screen's snackbar; keeps the current settings visible.
  Future<Object?> save(PlatformSettings settings) async {
    final current = state.value;
    final result = await AsyncValue.guard(() async {
      await ref.read(adminRepositoryProvider).updatePlatformSettings(settings);
      ref.invalidateSelf();
    });
    if (result.hasError) {
      if (current != null) state = AsyncData(current);
      return result.error;
    }
    return null;
  }
}
