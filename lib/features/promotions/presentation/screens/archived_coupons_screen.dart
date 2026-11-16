import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/presentation/widgets/async_value_widget.dart';
import '../controllers/admin_promotions_controller.dart';
import '../widgets/coupon_tile.dart';

/// Codes retired with the archive action. Disabled and expired codes are NOT
/// here — they stay in the admin list (Disabled / Expired); only an explicit
/// archive moves a code out of it.
///
/// Coupons are never auto-deleted: used codes keep their `order_coupons`
/// history. Restore puts one back in the list as Disabled.
class ArchivedCouponsScreen extends ConsumerWidget {
  const ArchivedCouponsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final couponsAsync = ref.watch(adminCouponsControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Archived coupons')),
      body: couponsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AsyncErrorView(
          message: userMessageFor(error),
          retry: () => ref.invalidate(adminCouponsControllerProvider),
        ),
        data: (coupons) {
          final now = DateTime.now().toUtc();
          final archived =
              coupons.where((coupon) => coupon.isArchivedAt(now)).toList();
          if (archived.isEmpty) {
            return const Center(child: Text('No archived coupons.'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Archived codes are kept for order history. Restore puts one '
                'back in the list as disabled.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              for (final coupon in archived)
                CouponTile(
                  coupon: coupon,
                  trailing: IconButton(
                    tooltip: 'Restore coupon',
                    icon: const Icon(Icons.unarchive_outlined),
                    onPressed: () => ref
                        .read(adminCouponsControllerProvider.notifier)
                        .archiveCoupon(couponId: coupon.id, archived: false),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
