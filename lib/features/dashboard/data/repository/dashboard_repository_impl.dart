import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../domain/entities/dashboard.dart';
import 'dashboard_repository.dart';

/// Exposes the interface type, never the impl (DATA-07).
final dashboardRepositoryProvider = Provider<IDashboardRepository>((ref) {
  return DashboardRepositoryImpl(ref.watch(supabaseClientProvider));
});

class DashboardRepositoryImpl implements IDashboardRepository {
  DashboardRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<DashboardSummary> fetchSummary() async {
    try {
      final result = await _client.rpc('get_customer_dashboard');
      final map = Map<String, dynamic>.from(result as Map);
      return DashboardSummary(
        activeOrders: (map['active_orders'] as int?) ?? 0,
        completedOrders: (map['completed_orders'] as int?) ?? 0,
        cancelledOrders: (map['cancelled_orders'] as int?) ?? 0,
        totalOrders: (map['total_orders'] as int?) ?? 0,
        wishlistCount: (map['wishlist_count'] as int?) ?? 0,
        cartItemCount: (map['cart_items'] as int?) ?? 0,
        cartSubtotalMinor: (map['cart_subtotal_minor'] as int?) ?? 0,
        totalSpendingMinor: (map['total_spending_minor'] as int?) ?? 0,
        recentOrders: ((map['recent_orders'] as List? ?? const [])
                .whereType<Map<String, dynamic>>())
            .map(DashboardOrderDto.fromJson)
            .map((dto) => DashboardOrder(
                  id: dto.id,
                  totalMinor: dto.totalMinor,
                  createdAt: dto.createdAt,
                  state: dto.state ?? 'active',
                ))
            .toList(),
      );
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }
}

/// Hand-parsed shape of the recent-orders rows inside the dashboard jsonb
/// payload (DATA-01): the aggregation is not a table row, so no generated
/// DTO — keys are read explicitly at the boundary.
class DashboardOrderDto {
  const DashboardOrderDto({
    required this.id,
    required this.totalMinor,
    required this.createdAt,
    this.state,
  });

  factory DashboardOrderDto.fromJson(Map<String, dynamic> json) {
    return DashboardOrderDto(
      id: json['id'] as String,
      totalMinor: (json['total_minor'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      state: json['state'] as String?,
    );
  }

  final String id;
  final int totalMinor;
  final DateTime createdAt;
  final String? state;
}
