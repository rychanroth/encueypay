import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/money.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/admin.dart';
import '../controllers/admin_audit_controller.dart';
import '../controllers/admin_report_provider.dart';

/// Admin tab 1 — Dashboard: platform report, audit logs, platform settings.
class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auditCount = ref.watch(adminAuditControllerProvider.select(
      (async) => async.value?.length ?? 0,
    ));
    final reportAsync = ref.watch(adminReportControllerProvider);
    final kpisAsync = ref.watch(adminKpisControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Admin dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Platform report',
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          reportAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            error: (error, _) => Text('$error'),
            data: (report) => Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'GMV',
                        value: Money(report.gmvMinor).format(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatCard(
                        label: 'Orders',
                        value: '${report.orderCount}',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatCard(
                        label: 'Delivery fees',
                        value: Money(report.deliveryFeesMinor).format(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${report.activeBusinesses} active businesses · '
                  '${report.activeProducts} active products',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Assignment §8 dashboard KPIs (Section 4).
          Text('Dashboard KPIs',
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          kpisAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            error: (error, _) => Text('$error'),
            data: (kpis) => Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'Total products',
                        value: '${kpis.totalProducts}',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatCard(
                        label: 'Total orders',
                        value: '${kpis.totalOrders}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'Customers',
                        value: '${kpis.totalCustomers}',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatCard(
                        label: 'Total sales',
                        value: Money(kpis.totalSalesMinor).format(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${kpis.lowStockProducts} low-stock (≤5) · '
                  '${kpis.outOfStockProducts} out of stock',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                if (kpis.bestSellers.isNotEmpty) ...[
                  Text('Best sellers',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  for (final bestSeller in kpis.bestSellers)
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.local_fire_department,
                          color: Colors.deepOrange, size: 20),
                      title: Text(bestSeller.name,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: Text('${bestSeller.units} sold'),
                    ),
                ],
                if (kpis.salesTrend.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('Sales — last 14 days',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _TrendBars(trend: kpis.salesTrend),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Audit logs'),
              subtitle: Text('$auditCount entries'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.pushNamed(AppRoutes.adminAudit),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Platform settings'),
              subtitle: const Text('Fees, commissions, payment account'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.pushNamed(AppRoutes.adminSettings),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              value,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(label, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

/// Plain-Flutter bar chart of the 14-day sales trend (Section 4) — no
/// charting dependency (DEPS-03). Bar height is proportional to the day's
/// sales; a tooltip shows the amount on tap.
class _TrendBars extends StatelessWidget {
  const _TrendBars({required this.trend});

  final List<AdminTrendPoint> trend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxSales = trend.fold<int>(
      1,
      (max, point) => point.salesMinor > max ? point.salesMinor : max,
    );
    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final point in trend)
            Expanded(
              child: Tooltip(
                message:
                    '${point.day.month}/${point.day.day}: '
                    '${Money(point.salesMinor).format()}',
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: FractionallySizedBox(
                    heightFactor: point.salesMinor / maxSales,
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
