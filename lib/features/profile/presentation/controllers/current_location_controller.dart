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

  /// Resolves the position and reverse-geocodes it. Returns the located
  /// coordinates + address (address null when the geocoder finds nothing)
  /// so the verification map can render even without a resolvable address;
  /// null on failure — failures stay observable in state as [Failure] (the
  /// screen reads them and snackbars).
  Future<({double latitude, double longitude, LocatedAddress? address})?>
  locate() async {
    state = const AsyncLoading<LocatedAddress?>();
    ({double latitude, double longitude, LocatedAddress? address})? located;
    state = await AsyncValue.guard(() async {
      final repository = ref.read(locationRepositoryProvider);
      final coordinates = await repository.currentPosition();
      final address = await repository.reverseGeocode(
        latitude: coordinates.latitude,
        longitude: coordinates.longitude,
      );
      located = (
        latitude: coordinates.latitude,
        longitude: coordinates.longitude,
        address: address,
      );
      return address;
    });
    return located;
  }

  /// Settings hand-off for the permission-denied snackbar action; the
  /// repository owns the plugin call.
  Future<void> openSettings() {
    return ref.read(locationRepositoryProvider).openSettings();
  }
}
