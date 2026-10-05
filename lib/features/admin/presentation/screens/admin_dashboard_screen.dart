import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/money.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/admin.dart';
import '../controllers/admin_audit_controller.dart';
import '../controllers/admin_report_provider.dart';

/// Admin tab 1 — Dashboard (Section 8B curation): a hero insight (total
/// sales with the 7-day momentum), an actionable alerts section (stock),
/// the 14-day trend, top sellers, and quick links. Raw counts live in the
/// Reporting area, not here.
class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auditCount = ref.watch(adminAuditControllerProvider.select(
      (async) => async.value?.length ?? 0,
    ));
    final kpisAsync = ref.watch(adminKpisControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Admin dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          kpisAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$error', textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  FilledButton.tonal(
                    onPressed: () => ref.invalidate(adminKpisControllerProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            data: (kpis) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero: money first, momentum second (§8B).
                _HeroCard(kpis: kpis),
                const SizedBox(height: 16),
                // Actionable alerts — the things an admin should act on.
                if (kpis.lowStockProducts > 0 || kpis.outOfStockProducts > 0)
                  _AlertsCard(kpis: kpis),
                if (kpis.salesTrend.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text('Sales — last 14 days',
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _TrendBars(trend: kpis.salesTrend),
                ],
                if (kpis.bestSellers.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text('Top sellers',
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  for (final bestSeller in kpis.bestSellers.take(3))
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        radius: 12,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Text(
                          '${kpis.bestSellers.indexOf(bestSeller) + 1}',
                          style: theme.textTheme.labelSmall,
                        ),
                      ),
                      title: Text(bestSeller.name,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: Text('${bestSeller.units} sold'),
                    ),
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
              subtitle: const Text('Fees, payment account, QR account'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.pushNamed(AppRoutes.adminSettings),
            ),
          ),
        ],
      ),
    );
  }
}

/// Total sales, order count, and the 7-day vs prior-7-day momentum —
/// computed from the trend the server already returns.
class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.kpis});

  final AdminKpis kpis;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trend = kpis.salesTrend;
    String? momentum;
    bool up = true;
    if (trend.length >= 14) {
      final last7 = trend.sublist(7).fold<int>(0, (s, p) => s + p.salesMinor);
      final prior7 = trend.sublist(0, 7).fold<int>(0, (s, p) => s + p.salesMinor);
      if (prior7 > 0) {
        final change = ((last7 - prior7) / prior7 * 100).round();
        momentum = '${change >= 0 ? '+' : ''}$change% vs prior 7 days';
        up = change >= 0;
      }
    }
    return Card(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total sales',
                style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer)),
            Text(
              Money(kpis.totalSalesMinor).format(),
              style: theme.textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '${kpis.totalOrders} orders · ${kpis.totalCustomers} customers',
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer),
                ),
              ],
            ),
            if (momentum != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(up ? Icons.trending_up : Icons.trending_down,
                        size: 16,
                        color: up ? Colors.green : theme.colorScheme.error),
                    const SizedBox(width: 4),
                    Text(momentum, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Stock alerts — the actionable part of the dashboard (§8B): jump
/// straight into the Products tab.
class _AlertsCard extends StatelessWidget {
  const _AlertsCard({required this.kpis});

  final AdminKpis kpis;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.errorContainer,
      child: ListTile(
        leading: Icon(Icons.warning_amber_outlined,
            color: theme.colorScheme.onErrorContainer),
        title: Text(
          '${kpis.lowStockProducts} low-stock (≤5) · '
          '${kpis.outOfStockProducts} out of stock',
          style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onErrorContainer),
        ),
        subtitle: Text('Tap to manage in Products',
            style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onErrorContainer)),
        trailing: Icon(Icons.chevron_right,
            color: theme.colorScheme.onErrorContainer),
        onTap: () => context.pushNamed(AppRoutes.adminProducts),
      ),
    );
  }
}

/// Plain-Flutter bar chart of the 14-day sales trend — no charting
/// dependency (DEPS-03). Bar height is proportional to the day's sales; a
/// tooltip shows the amount on tap.
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
