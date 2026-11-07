import 'package:flutter_test/flutter_test.dart';

import 'package:encueypay/features/admin/data/dtos/admin_dtos.dart';

/// Pins the admin orders DTO to the REAL PostgREST wire shape (captured
/// from the local stack). `payments.order_id` is UNIQUE (baseline), so
/// PostgREST embeds the payment as an OBJECT — a list-typed field here
/// threw a TypeError inside fromJson, which the repository surfaced as a
/// bare NetworkFailure on the Admin Orders screen.
void main() {
  test('AdminOrderRowDto parses the real one-to-one payments embed', () {
    const json = {
      'id': '56c42419-cf67-421b-ae26-b9f908e787b9',
      'status': 'pending',
      'cancellation_reason': '',
      'subtotal_minor': 5999,
      'discount_minor': 0,
      'delivery_fee_minor': 200,
      'total_minor': 6199,
      'created_at': '2026-10-19T12:30:45.123456+00:00',
      'users': {'full_name': 'RothGemini'},
      'payments': {'method': 'qr', 'status': 'pending'},
      'order_items': [
        {
          'quantity': 1,
          'product_name': 'Nordwind Trail Backpack 30L',
          'variant_name': 'Sand',
          'unit_price_minor': 5999,
          'discount_minor': 500,
          'line_total_minor': 5999,
          'products': {
            'product_images': [
              {
                'id': 'image-1',
                'storage_path': 'seed/backpack.jpg',
                'sort_order': 0,
              },
            ],
          },
        },
      ],
    };

    final dto = AdminOrderRowDto.fromJson(json);
    expect(dto.payments, isNotNull);
    expect(dto.payments!.method, 'qr');
    expect(dto.payments!.status, 'pending');
    expect(dto.users?.fullName, 'RothGemini');
    expect(dto.items.first.productName, 'Nordwind Trail Backpack 30L');
    expect(dto.items.first.unitPriceMinor, 5999);
    expect(dto.items.first.discountMinor, 500);
    expect(
      dto.items.first.products?.productImages.first.storagePath,
      'seed/backpack.jpg',
    );
  });
}
