import 'package:flutter_test/flutter_test.dart';

import 'package:encueypay/features/notifications/data/dtos/notification_dto.dart';
import 'package:encueypay/features/notifications/data/mappers/notification_mapper.dart';

void main() {
  test('order notification keeps its type and order link', () {
    final dto = NotificationDto.fromJson({
      'id': 'n1',
      'title': 'Order shipped',
      'content': 'Your order has shipped.',
      'read': false,
      'created_at': '2026-11-03T10:00:00Z',
      'type': 'order',
      'order_id': 'o1',
    });

    final item = dto.toDomain();
    expect(item.type, 'order');
    expect(item.orderId, 'o1');
  });

  test('legacy notification falls back to system with no order link', () {
    final dto = NotificationDto.fromJson({
      'id': 'n2',
      'title': 'System notice',
      'content': '',
      'read': true,
      'created_at': '2026-11-03T10:00:00Z',
    });

    final item = dto.toDomain();
    expect(item.type, 'system');
    expect(item.orderId, isNull);
  });
}
