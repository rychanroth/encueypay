import 'package:flutter/material.dart';

import '../../../../core/domain/money.dart';
import '../../domain/entities/promotion.dart';

/// One sale row shared by the live Sales section and the archive screen.
///
/// Always states the sale's lifecycle word (Live / Scheduled / Disabled /
/// Ended / Archived) so a switched-off sale never looks live, and dims it
/// when it is not currently pricing anything.
class SaleTile extends StatelessWidget {
  const SaleTile({
    super.key,
    required this.sale,
    this.trailing,
  });

  final ManagedSale sale;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now().toUtc();
    final status = sale.statusLabel(now);
    final dimmed = !sale.isLiveAt(now);

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
          ' · $status',
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
