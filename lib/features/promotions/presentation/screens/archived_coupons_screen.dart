import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/async_value_widget.dart';
import '../../../../core/domain/failures.dart';

import '../controllers/admin_promotions_controller.dart';
import '../widgets/coupon_tile.dart';

/// Read-only home for expired and manually deactivated coupon codes.
///
/// Coupons are never auto-deleted: used codes keep their `order_coupons`
/// history, so the admin list splits them out instead of cluttering the
/// live Coupons section.
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
          final archived = coupons
              .where((coupon) => coupon.isArchivedAt(now))
              .toList();
          if (archived.isEmpty) {
            return const Center(child: Text('No archived coupons.'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Expired or deactivated codes are kept here for order history. '
                'This list is view-only.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              for (final coupon in archived)
                CouponTile(coupon: coupon, showArchiveState: true),
            ],
          );
        },
      ),
    );
  }
}
