import 'package:flutter/material.dart';

import '../../../../core/domain/money.dart';
import '../../domain/entities/promotion.dart';

/// One coupon row shared by the live Coupons section and the read-only
/// archive screen. The archive passes no trailing control and asks for the
/// expired/deactivated label.
class CouponTile extends StatelessWidget {
  const CouponTile({
    super.key,
    required this.coupon,
    this.trailing,
    this.showArchiveState = false,
  });

  final ManagedCoupon coupon;
  final Widget? trailing;
  final bool showArchiveState;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now().toUtc();
    final expired = coupon.isExpiredAt(now);
    final dimmed = coupon.isArchivedAt(now);

    return Card(
      margin: const EdgeInsets.only(top: 8),
      child: ListTile(
        title: Text(
          coupon.code,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: dimmed ? theme.colorScheme.onSurfaceVariant : null,
          ),
        ),
        subtitle: Text(
          '${_discountLabel(coupon.discountType, coupon.discountValue)}'
          '${coupon.name.isEmpty ? '' : ' · ${coupon.name}'}'
          '${coupon.minOrderAmountMinor == 0 ? '' : ' · min ${Money(coupon.minOrderAmountMinor).format()}'}'
          '${coupon.startsAt == null ? '' : ' · from ${_day(coupon.startsAt!)}'}'
          '${coupon.endsAt == null ? '' : ' · until ${_day(coupon.endsAt!)}'}'
          '${showArchiveState ? (expired ? ' · expired' : ' · deactivated') : ''}',
        ),
        trailing: trailing,
      ),
    );
  }

  static String _discountLabel(PromoDiscountType type, int value) =>
      switch (type) {
        PromoDiscountType.percent => '$value% off',
        PromoDiscountType.fixed => '${Money(value).format()} off',
      };

  static String _day(DateTime value) =>
      value.toLocal().toString().substring(0, 10);
}
