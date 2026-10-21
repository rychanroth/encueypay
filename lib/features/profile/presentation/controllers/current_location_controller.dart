import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/location_repository_impl.dart';
import '../../domain/entities/located_address.dart';

part 'current_location_controller.g.dart';

/// One-shot locate for the address form (spec B.6): device position →
/// platform reverse geocode. A plain fetch, so the controller calls the
/// repository directly (DOMAIN-04) — no use case.
@riverpod
class CurrentLocationController extends _$CurrentLocationController {
  /// Idle until [locate] runs; null means nothing located yet.
  @override
  Future<LocatedAddress?> build() async => null;

  /// Resolves the position and reverse-geocodes it. Mirrors the outcome
  /// into state for the busy indicator; failures stay observable in state
  /// as [Failure] — the screen reads them and snackbars.
  Future<LocatedAddress?> locate() async {
    state = const AsyncLoading<LocatedAddress?>();
    final result = await AsyncValue.guard(() async {
      final repository = ref.read(locationRepositoryProvider);
      final coordinates = await repository.currentPosition();
      return repository.reverseGeocode(
        latitude: coordinates.latitude,
        longitude: coordinates.longitude,
      );
    });
    state = result;
    // Riverpod 3: `.value` is null on error/loading (the old valueOrNull).
    return result.value;
  }

  /// Settings hand-off for the permission-denied snackbar action; the
  /// repository owns the plugin call.
  Future<void> openSettings() {
    return ref.read(locationRepositoryProvider).openSettings();
  }
}
