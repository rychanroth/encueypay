import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../domain/entities/address.dart';
import '../dtos/address_dto.dart';
import '../mappers/address_mapper.dart';
import 'address_repository.dart';

/// Exposes the interface type, never the impl (DATA-07).
final addressRepositoryProvider = Provider<IAddressRepository>((ref) {
  return AddressRepositoryImpl(ref.watch(supabaseClientProvider));
});

class AddressRepositoryImpl implements IAddressRepository {
  AddressRepositoryImpl(this._client);

  final SupabaseClient _client;

  String get _uid {
    final user = _client.auth.currentUser;
    if (user == null) throw const ServerFailure('Not authenticated');
    return user.id;
  }

  @override
  Future<List<Address>> fetchMyAddresses() async {
    try {
      final rows = await _client
          .from('addresses')
          .select()
          .eq('user_id', _uid)
          // Default first (Section 6b), then chronological — the checkout
          // preselects the first row.
          .order('is_default', ascending: false)
          .order('created_at');
      return rows.map(AddressDto.fromJson).map((dto) => dto.toDomain()).toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> setDefaultAddress(String addressId) async {
    try {
      await _client.rpc('set_default_address', params: {
        'p_address_id': addressId,
      });
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> createAddress(AddressDraft draft) async {
    try {
      await _client.from('addresses').insert({
        'user_id': _uid,
        'label': draft.label,
        'recipient_name': draft.recipientName,
        'phone': draft.phone,
        'line1': draft.line1,
        'line2': draft.line2,
        'city': draft.city,
      });
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> updateAddress(String addressId, AddressDraft draft) async {
    try {
      await _client.from('addresses').update({
        'label': draft.label,
        'recipient_name': draft.recipientName,
        'phone': draft.phone,
        'line1': draft.line1,
        'line2': draft.line2,
        'city': draft.city,
      }).eq('id', addressId);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> deleteAddress(String addressId) async {
    try {
      await _client.from('addresses').delete().eq('id', addressId);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }
}
