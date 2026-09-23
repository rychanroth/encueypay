import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/stream_result.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../domain/entities/delivery.dart';
import '../dtos/delivery_dtos.dart';
import '../mappers/delivery_mapper.dart';
import 'delivery_repository.dart';

/// Exposes the interface type, never the impl (DATA-07).
final deliveryRepositoryProvider = Provider<IDeliveryRepository>((ref) {
  return DeliveryRepositoryImpl(ref.watch(supabaseClientProvider));
});

class DeliveryRepositoryImpl implements IDeliveryRepository {
  DeliveryRepositoryImpl(this._client);

  final SupabaseClient _client;

  static const _deliverySelect =
      'id, order_id, status, delivery_fee_minor, driver_earning_minor, '
      'created_at, '
      'orders(shipping_line1, shipping_city, users(full_name)), '
      'pickup_stops(id, sequence, status, '
      'business_orders(businesses(name)))';

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
  Future<List<AvailableDelivery>> fetchAvailableDeliveries() async {
    try {
      final rows = await _client
          .from('deliveries')
          .select(_deliverySelect)
          .eq('status', 'available')
          .order('created_at')
          .limit(50);
      return rows
          .map(DeliveryDto.fromJson)
          .map((dto) => dto.toAvailable())
          .toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<DriverDelivery?> fetchMyActiveDelivery() async {
    try {
      final rows = await _client
          .from('deliveries')
          .select(_deliverySelect)
          .eq('driver_id', _uid)
          .inFilter('status', ['assigned', 'pickup_in_progress', 'delivery_in_progress'])
          .order('created_at')
          .limit(1);
      if (rows.isEmpty) return null;
      return DeliveryDto.fromJson(rows.first).toDriverDelivery();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<List<DriverDelivery>> fetchMyHistory() async {
    try {
      final rows = await _client
          .from('deliveries')
          .select(_deliverySelect)
          .eq('driver_id', _uid)
          .eq('status', 'delivered')
          .order('created_at', ascending: false)
          .limit(50);
      return rows
          .map(DeliveryDto.fromJson)
          .map((dto) => dto.toDriverDelivery())
          .toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<void> acceptDelivery(String deliveryId) =>
      _rpc('accept_delivery', {'p_delivery_id': deliveryId});

  @override
  Future<void> rejectDelivery(String deliveryId) =>
      _rpc('reject_delivery', {'p_delivery_id': deliveryId});

  @override
  Future<void> completePickupStop(String stopId) =>
      _rpc('complete_pickup_stop', {'p_stop_id': stopId});

  @override
  Future<void> startDelivery(String deliveryId) =>
      _rpc('start_delivery', {'p_delivery_id': deliveryId});

  @override
  Future<void> markDelivered(String deliveryId) =>
      _rpc('mark_delivered', {'p_delivery_id': deliveryId});

  String get _uid {
    final user = _client.auth.currentUser;
    if (user == null) throw const ServerFailure('Not authenticated');
    return user.id;
  }

  @override
  Stream<StreamResult<bool>> watchAvailableChanges() {
    return _client
        .from('deliveries')
        .stream(primaryKey: ['id'])
        .eq('status', 'available')
        .map((_) => true)
        .asStreamResult(_mapError);
  }

  @override
  Stream<StreamResult<bool>> watchMyDeliveryChanges() {
    return _client
        .from('deliveries')
        .stream(primaryKey: ['id'])
        .eq('driver_id', _uid)
        .map((_) => true)
        .asStreamResult(_mapError);
  }

  Failure _mapError(Object error) {
    if (error is PostgrestException) return ServerFailure(error.message);
    return const NetworkFailure();
  }
}
