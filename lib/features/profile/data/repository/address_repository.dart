import '../../domain/entities/address.dart';

/// Address book contract for the profile feature (DATA-03).
abstract interface class IAddressRepository {
  Future<List<Address>> fetchMyAddresses();

  /// Section 6b: atomically makes [addressId] the user's single default.
  Future<void> setDefaultAddress(String addressId);

  Future<void> createAddress(AddressDraft draft);

  Future<void> updateAddress(String addressId, AddressDraft draft);

  Future<void> deleteAddress(String addressId);
}
