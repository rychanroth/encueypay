import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../domain/entities/admin.dart';
import '../dtos/admin_dtos.dart';
import 'admin_repository.dart';

/// Exposes the interface type, never the impl (DATA-07).
final adminRepositoryProvider = Provider<IAdminRepository>((ref) {
  return AdminRepositoryImpl(ref.watch(supabaseClientProvider));
});

class AdminRepositoryImpl implements IAdminRepository {
  AdminRepositoryImpl(this._client);

  final SupabaseClient _client;

  Future<void> _rpc(String function, Map<String, dynamic> params) async {
    try {
      await _client.rpc(function, params: params);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<List<AdminApplication>> fetchPendingApplications() async {
    try {
      final rows = await _client
          .from('role_applications')
          .select('id, requested_role, status, created_at, users(full_name)')
          .eq('status', 'pending')
          .order('created_at');
      return rows
          .map(AdminApplicationDto.fromJson)
          .map((dto) => AdminApplication(
                id: dto.id,
                applicantName: dto.users?.fullName ?? 'Applicant',
                requestedRole: dto.requestedRole,
                status: dto.status ?? 'pending',
                createdAt: dto.createdAt,
              ))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> reviewApplication({
    required String applicationId,
    required bool approve,
    String? reason,
  }) {
    return _rpc('review_role_application', {
      'p_application_id': applicationId,
      'p_approve': approve,
      'p_reason': reason,
    });
  }

  @override
  Future<List<AdminCategory>> fetchCategories() async {
    try {
      final rows = await _client
          .from('categories')
          .select('id, name')
          .order('name');
      return rows
          .map(AdminCategoryDto.fromJson)
          .map((dto) => AdminCategory(id: dto.id, name: dto.name))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> createCategory({required String name, String? parentId}) {
    return _rpc('create_category', {
      'p_name': name,
      'p_parent_id': parentId,
    });
  }

  @override
  Future<void> renameCategory({
    required String categoryId,
    required String name,
  }) {
    return _rpc('rename_category', {
      'p_category_id': categoryId,
      'p_name': name,
    });
  }

  @override
  Future<void> deleteCategory({required String categoryId}) {
    return _rpc('delete_category', {'p_category_id': categoryId});
  }

  @override
  Future<List<AuditEntry>> fetchAuditLogs() async {
    try {
      final rows = await _client
          .from('audit_logs')
          .select()
          .order('created_at', ascending: false)
          .limit(100);
      return rows
          .map(AuditLogDto.fromJson)
          .map((dto) => AuditEntry(
                id: dto.id,
                actor: dto.actor,
                action: dto.action,
                targetType: dto.targetType,
                targetId: dto.targetId,
                createdAt: dto.createdAt,
              ))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<PlatformAnalyticsReport> fetchPlatformReport() async {
    try {
      final result = await _client.rpc('get_platform_report');
      final map = Map<String, dynamic>.from(result as Map);
      return PlatformAnalyticsReport(
        orderCount: (map['order_count'] as int?) ?? 0,
        gmvMinor: (map['gmv_minor'] as int?) ?? 0,
        deliveryFeesMinor: (map['delivery_fees_minor'] as int?) ?? 0,
        activeBusinesses: (map['active_businesses'] as int?) ?? 0,
        activeProducts: (map['active_products'] as int?) ?? 0,
        pendingApplications: (map['pending_applications'] as int?) ?? 0,
      );
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<PlatformSettings> fetchPlatformSettings() async {
    try {
      final row = await _client
          .from('platform_settings')
          .select()
          .eq('id', 1)
          .maybeSingle();
      if (row == null) {
        return const PlatformSettings(
          deliveryFeeMinor: 0,
          platformCommissionPercent: 0,
          driverCommissionPercent: 0,
          paymentAccount: '',
        );
      }
      final dto = PlatformSettingsAdminDto.fromJson(row);
      return PlatformSettings(
        deliveryFeeMinor: dto.deliveryFeeMinor,
        platformCommissionPercent: dto.platformCommissionPercent,
        driverCommissionPercent: dto.driverCommissionPercent,
        paymentAccount: dto.paymentAccount,
      );
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> updatePlatformSettings(PlatformSettings settings) async {
    try {
      await _client.from('platform_settings').update({
        'delivery_fee_minor': settings.deliveryFeeMinor,
        'platform_commission_percent': settings.platformCommissionPercent,
        'driver_commission_percent': settings.driverCommissionPercent,
        'payment_account': settings.paymentAccount,
      }).eq('id', 1);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }
}
