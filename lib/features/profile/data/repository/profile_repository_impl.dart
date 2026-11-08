import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/picked_file.dart';
import '../../../../core/network/failure_mapping.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../domain/entities/user_profile.dart';
import '../dtos/profile_dto.dart';
import '../mappers/profile_mapper.dart';
import 'profile_repository.dart';

/// Exposes the interface type, never the impl (DATA-07).
final profileRepositoryProvider = Provider<IProfileRepository>((ref) {
  return ProfileRepositoryImpl(ref.watch(supabaseClientProvider));
});

class ProfileRepositoryImpl implements IProfileRepository {
  ProfileRepositoryImpl(this._client);

  final SupabaseClient _client;

  String get _uid {
    final user = _client.auth.currentUser;
    if (user == null) throw const ServerFailure('Not authenticated');
    return user.id;
  }

  @override
  Future<UserProfile> fetchMyProfile() async {
    try {
      final row = await _client
          .from('users')
          .select()
          .eq('id', _uid)
          .maybeSingle();
      if (row == null) {
        return const UserProfile(id: '', fullName: '');
      }
      return ProfileDto.fromJson(row).toDomain();
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }

  @override
  Future<void> updateMyProfile({
    required String fullName,
    required String phone,
  }) async {
    try {
      await _client.from('users').update({
        'full_name': fullName,
        'phone': phone,
      }).eq('id', _uid);
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }

  @override
  Future<void> updateMyAvatar({required PickedFile image}) async {
    try {
      final fileName = image.fileName;
      // {uid}/... matches the avatars bucket RLS: users write only their
      // own folder. The public URL is what the users row stores, matching
      // the OAuth-provided avatar convention.
      final path =
          '$_uid/${DateTime.now().millisecondsSinceEpoch}_$fileName';
      await _client.storage.from('avatars').uploadBinary(path, image.bytes);
      final url = _client.storage.from('avatars').getPublicUrl(path);
      await _client
          .from('users')
          .update({'avatar_url': url}).eq('id', _uid);
    } catch (error, stackTrace) { // DATA-05: classify, don't guess
      throw mapRepositoryError(error, stackTrace);
    }
  }
}
