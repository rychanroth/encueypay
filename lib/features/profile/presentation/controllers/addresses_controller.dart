import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/address_repository_impl.dart';
import '../../domain/entities/address.dart';

part 'addresses_controller.g.dart';

/// Address book list + mutations. No optimistic UI: mutations persist via
/// the repository, then `ref.invalidateSelf()` refetches ground truth
/// (PRES-03).
@riverpod
class AddressesController extends _$AddressesController {
  @override
  Future<List<Address>> build() async {
    return ref.watch(addressRepositoryProvider).fetchMyAddresses();
  }

  Future<void> save(AddressDraft draft, {String? addressId}) async {
    final current = state.value ?? const <Address>[];
    state = await AsyncValue.guard(() async {
      final repository = ref.read(addressRepositoryProvider);
      if (addressId == null) {
        await repository.createAddress(draft);
      } else {
        await repository.updateAddress(addressId, draft);
      }
      ref.invalidateSelf();
      return current;
    });
  }

  Future<void> remove(String addressId) async {
    final current = state.value ?? const <Address>[];
    state = await AsyncValue.guard(() async {
      await ref.read(addressRepositoryProvider).deleteAddress(addressId);
      ref.invalidateSelf();
      return current;
    });
  }
}
