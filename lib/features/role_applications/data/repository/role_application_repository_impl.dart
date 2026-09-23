import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../domain/entities/role_application.dart';
import '../dtos/role_application_dto.dart';
import '../mappers/role_application_mapper.dart';
import 'role_application_repository.dart';

/// Exposes the interface type, never the impl (DATA-07).
final roleApplicationRepositoryProvider = Provider<IRoleApplicationRepository>(
    (ref) {
  return RoleApplicationRepositoryImpl(ref.watch(supabaseClientProvider));
});

class RoleApplicationRepositoryImpl implements IRoleApplicationRepository {
  RoleApplicationRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<RoleApplication?> fetchMyApplication() async {
    try {
      final row = await _client
          .from('role_applications')
          .select()
          .eq('user_id', _uid)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();
      if (row == null) return null;
      return RoleApplicationDto.fromJson(row).toDomain();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> submit({required String requestedRole}) async {
    try {
      await _client.rpc('submit_role_application',
          params: {'p_requested_role': requestedRole});
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  String get _uid {
    final user = _client.auth.currentUser;
    if (user == null) throw const ServerFailure('Not authenticated');
    return user.id;
  }
}
