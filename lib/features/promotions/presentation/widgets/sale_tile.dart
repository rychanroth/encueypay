import 'package:flutter/material.dart';

import '../../../../core/domain/money.dart';
import '../../domain/entities/promotion.dart';

/// One sale row shared by the live Sales section and the archive screen.
/// The archive asks for the expired/deactivated suffix and keeps the kill
/// switch so a deactivated sale can be brought back.
class SaleTile extends StatelessWidget {
  const SaleTile({
    super.key,
    required this.sale,
    this.trailing,
    this.showArchiveState = false,
  });

  final ManagedSale sale;
  final Widget? trailing;
  final bool showArchiveState;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now().toUtc();
    final expired = sale.isExpiredAt(now);
    final dimmed = sale.isArchivedAt(now);

    return Card(
      margin: const EdgeInsets.only(top: 8),
      child: ListTile(
        title: Text(
          sale.name,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: dimmed ? theme.colorScheme.onSurfaceVariant : null,
          ),
        ),
        subtitle: Text(
          '${_discountLabel(sale.discountType, sale.discountValue)}'
          ' · ${_scopeLabel(sale)}'
          '${sale.startsAt == null ? '' : ' · from ${_day(sale.startsAt!)}'}'
          '${sale.endsAt == null ? '' : ' · until ${_day(sale.endsAt!)}'}'
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

  static String _scopeLabel(ManagedSale sale) => switch (sale.scope) {
        SaleScope.platform => 'All products',
        SaleScope.brand => 'Brand: ${sale.brandName ?? '—'}',
        SaleScope.category => 'Category: ${sale.categoryName ?? '—'}',
      };

  static String _day(DateTime value) =>
      value.toLocal().toString().substring(0, 10);
}
