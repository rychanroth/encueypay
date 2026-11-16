import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/domain/failures.dart';

import '../../../../core/domain/money.dart';
import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/presentation/widgets/monogram_image.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/admin.dart';
import '../controllers/admin_audit_controller.dart';
import '../controllers/admin_report_provider.dart';

/// Admin tab 1 — Dashboard (Section 8B curation): a hero insight (total
/// sales with the 7-day momentum), an actionable alerts section (stock),
/// the 14-day trend, top sellers, and quick links. Raw counts live in the
/// Reporting area, not here.
class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key, this.profileAction});

  /// Signed-in avatar action, injected by the composition root so the
  /// admin feature never imports the profile feature (ARCH-04).
  final Widget? profileAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auditCount = ref.watch(adminAuditControllerProvider.select(
      (async) => async.value?.length ?? 0,
    ));
    final kpisAsync = ref.watch(adminKpisControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin dashboard'),
        actions: [?profileAction],
      ),
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
                  Text(userMessageFor(error), textAlign: TextAlign.center),
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
                // Hero: money first, momentum second (§8B). Tap-through to
                // the orders behind the KPI (non-cancelled, all time).
                _HeroCard(
                  kpis: kpis,
                  onTap: () => context.goNamed(
                    AppRoutes.adminOrders,
                    queryParameters: const {'ex': '1'},
                  ),
                ),
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
                  for (final (index, bestSeller)
                      in kpis.bestSellers.take(3).indexed)
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      // Deep-link into the product's detail page — the
                      // thumbnail doubles as the affordance.
                      onTap: bestSeller.productId == null
                          ? null
                          : () => context.pushNamed(
                                AppRoutes.productDetail,
                                pathParameters: {'id': bestSeller.productId!},
                              ),
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor:
                                theme.colorScheme.primaryContainer,
                            child: Text(
                              '${index + 1}',
                              style: theme.textTheme.labelSmall,
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 44,
                            height: 44,
                            child: ClipRRect(
                              borderRadius: AppRadii.br12,
                              child: MonogramImage(
                                imageUrl: bestSeller.imageUrl,
                                name: bestSeller.name,
                              ),
                            ),
                          ),
                        ],
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
              leading: const Icon(Icons.insights_outlined),
              title: const Text('Reports & analytics'),
              subtitle: const Text('Date-range sales report'),
              trailing: const Icon(Icons.chevron_right),
              // Reports is a dedicated tab under the DESIGN.md §5.2 shell.
              onTap: () => context.goNamed(AppRoutes.adminReports),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.category_outlined),
              title: const Text('Manage categories'),
              subtitle: const Text('Catalog taxonomy'),
              trailing: const Icon(Icons.chevron_right),
              // DESIGN.md §5.2: Categories/Brands/Promotions live under
              // Dashboard quick actions in the 4-tab shell.
              onTap: () => context.pushNamed(AppRoutes.adminCategories),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.sell_outlined),
              title: const Text('Manage brands'),
              subtitle: const Text('Brand names & logos'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.pushNamed(AppRoutes.adminBrands),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.campaign_outlined),
              title: const Text('Manage promotions'),
              subtitle: const Text('Banners, coupons & flash sales'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.pushNamed(AppRoutes.adminPromotions),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Account & settings'),
              subtitle: const Text('Profile, theme, sign out'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.pushNamed(AppRoutes.profile),
            ),
          ),
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

/// Realized sales (paid or delivered), order count, and the 7-day vs
/// prior-7-day momentum — computed from the trend the server already returns.
class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.kpis, this.onTap});

  final AdminKpis kpis;
  final VoidCallback? onTap;

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
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Realized sales',
                style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer),
              ),
              Text(
                Money(kpis.totalSalesMinor).formatUsd(),
                style: theme.textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    '${kpis.totalOrders} orders placed · '
                    '${kpis.totalCustomers} customers',
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
                          color: up
                              ? const Color(0xFF059669)
                              : theme.colorScheme.error),
                      const SizedBox(width: 4),
                      Text(momentum, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
            ],
          ),
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
      height: 140,
      child: Column(
        children: [
          Expanded(
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
                        // Zero-sales days render as a stub instead of
                        // collapsing to nothing — "no sales" is data too.
                        child: point.salesMinor == 0
                            ? Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.outlineVariant,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(2),
                                    ),
                                  ),
                                ),
                              )
                            : FractionallySizedBox(
                                heightFactor: point.salesMinor / maxSales,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    // Brand navy — primaryContainer blended
                                    // into the card surface behind it.
                                    color: AppColors.primaryRoyal,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(6),
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
          ),
          const SizedBox(height: 4),
          // Baseline — anchors the bars against the card surface.
          Container(height: 1, color: theme.colorScheme.outlineVariant),
          if (trend.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '${trend.first.day.month}/${trend.first.day.day}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Text(
                  'Max ${Money(maxSales).format()}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Text(
                  '${trend.last.day.month}/${trend.last.day.day}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
