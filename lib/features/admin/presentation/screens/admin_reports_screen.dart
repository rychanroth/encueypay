import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/money.dart';
import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/presentation/theme/app_typography.dart';
import '../../../../core/presentation/widgets/async_value_widget.dart';
import '../../../../core/presentation/widgets/monogram_image.dart';
import '../../domain/entities/admin.dart';
import '../controllers/admin_reports_controller.dart';

enum _ReportPreset { sevenD, fifteenD, thirtyD, mtd, custom }

/// Reports tab (DESIGN.md §5.2.4): preset date ranges (7D/15D/30D/MTD/
/// Custom), executive KPI summary, payment gateway distribution, category
/// and brand breakdowns, and inventory capital valuation.
class AdminReportsScreen extends ConsumerStatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  ConsumerState<AdminReportsScreen> createState() =>
      _AdminReportsScreenState();
}

class _AdminReportsScreenState extends ConsumerState<AdminReportsScreen> {
  _ReportPreset _preset = _ReportPreset.thirtyD;
  late ReportRange _range = _rangeFor(_ReportPreset.thirtyD);

  ReportRange _rangeFor(_ReportPreset preset) {
    final now = DateTime.now();
    switch (preset) {
      case _ReportPreset.sevenD:
        return ReportRange(from: now.subtract(const Duration(days: 6)), to: now);
      case _ReportPreset.fifteenD:
        return ReportRange(from: now.subtract(const Duration(days: 14)), to: now);
      case _ReportPreset.thirtyD:
        return ReportRange(from: now.subtract(const Duration(days: 29)), to: now);
      case _ReportPreset.mtd:
        return ReportRange(from: DateTime(now.year, now.month), to: now);
      case _ReportPreset.custom:
        return _range;
    }
  }

  Future<void> _pickCustomRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      initialDateRange: DateTimeRange(start: _range.from, end: _range.to),
    );
    if (picked != null) {
      setState(() {
        _preset = _ReportPreset.custom;
        _range = ReportRange(from: picked.start, to: picked.end);
      });
    }
  }

  static String _day(DateTime value) =>
      value.toLocal().toString().substring(0, 10);

  @override
  Widget build(BuildContext context) {
    final reportAsync = ref.watch(adminReportsControllerProvider(_range));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: Column(
        children: [
          // Preset range chips (§5.2.4).
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              children: [
                for (final preset in _ReportPreset.values)
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: ChoiceChip(
                      label: Text(switch (preset) {
                        _ReportPreset.sevenD => '7D',
                        _ReportPreset.fifteenD => '15D',
                        _ReportPreset.thirtyD => '30D',
                        _ReportPreset.mtd => 'MTD',
                        _ReportPreset.custom => 'Custom',
                      }),
                      selected: _preset == preset,
                      onSelected: (_) {
                        if (preset == _ReportPreset.custom) {
                          _pickCustomRange();
                          return;
                        }
                        setState(() {
                          _preset = preset;
                          _range = _rangeFor(preset);
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: AsyncValueWidget(
              value: reportAsync,
              retry: () =>
                  ref.invalidate(adminReportsControllerProvider(_range)),
              data: (report) => ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  Text(
                    '${_day(report.from)} – ${_day(report.to)}',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  // KPI summary — responsive card grid rather than fixed
                  // 3/2-per-row rows that clip on phones and large text.
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.maxWidth >= 720
                          ? 4
                          : constraints.maxWidth >= 420
                              ? 2
                              : 1;
                      final gap = AppSpacing.sm;
                      final width =
                          (constraints.maxWidth - gap * (columns - 1)) /
                              columns;
                      final cards = <Widget>[
                        _StatCard(
                          label: 'Orders',
                          value: '${report.totalOrders}',
                        ),
                        _StatCard(
                          label: 'Completed',
                          value: '${report.completedOrders}',
                        ),
                        _StatCard(
                          label: 'Cancelled',
                          value: '${report.cancelledOrders}',
                        ),
                        _StatCard(
                          label: 'Realized orders',
                          value: '${report.realizedOrders}',
                        ),
                        _StatCard(
                          label: 'Gross realized revenue',
                          value: Money(report.totalSalesMinor).formatUsd(),
                        ),
                        _StatCard(
                          label: 'AOV',
                          value: Money(report.averageOrderValueMinor)
                              .formatUsd(),
                        ),
                        _StatCard(
                          label: 'Net settled balance',
                          value: Money(report.netSettledMinor).formatUsd(),
                        ),
                        _StatCard(
                          label: 'Inventory valuation',
                          value: Money(report.inventoryValuationMinor)
                              .formatUsd(),
                        ),
                      ];
                      return Wrap(
                        spacing: gap,
                        runSpacing: gap,
                        children: [
                          for (final card in cards)
                            SizedBox(width: width, child: card),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Gross realized revenue and AOV count paid or delivered '
                    'orders only.',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Payment gateway distribution (§5.2.4): KHQR vs COD split
                  // bar — zero-dependency (DEPS-03).
                  if (report.paymentSplit.qrCount > 0 ||
                      report.paymentSplit.codCount > 0)
                    _GatewaySplitCard(split: report.paymentSplit),
                  const _SectionGap(),
                  _RankedSection(
                    title: 'Best sellers',
                    entries: [
                      for (final item in report.bestSellers)
                        (
                          name: item.name,
                          metric: '${item.units} sold',
                          imageUrl: item.imageUrl,
                          fallbackIcon: Icons.inventory_2_outlined,
                        ),
                    ],
                  ),
                  _RankedSection(
                    title: 'Top categories',
                    entries: [
                      for (final item in report.topCategories)
                        (
                          name: item.name,
                          metric: '${item.units} sold',
                          imageUrl: item.imageUrl,
                          fallbackIcon: Icons.category_outlined,
                        ),
                    ],
                  ),
                  _RankedSection(
                    title: 'Brand revenue',
                    entries: [
                      for (final item in report.brandRevenue)
                        (
                          name: item.name,
                          metric: Money(item.revenueMinor).formatUsd(),
                          imageUrl: item.imageUrl,
                          fallbackIcon: Icons.sell_outlined,
                        ),
                    ],
                  ),
                  _RankedSection(
                    title: 'Customer purchase frequency',
                    entries: [
                      for (final item in report.purchaseFrequency)
                        (
                          name: item.name,
                          metric: '${item.orders} order(s)',
                          imageUrl: item.imageUrl,
                          fallbackIcon: Icons.person_outline,
                        ),
                    ],
                  ),
                  Text(
                    '${report.lowStockProducts} low-stock (≤5) · '
                    '${report.outOfStockProducts} out of stock (current)',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionGap extends StatelessWidget {
  const _SectionGap();

  @override
  Widget build(BuildContext context) => const SizedBox(height: AppSpacing.sm);
}

/// KHQR vs COD split bar with counts and amounts (§5.2.4).
class _GatewaySplitCard extends StatelessWidget {
  const _GatewaySplitCard({required this.split});

  final AdminPaymentSplit split;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = split.qrCount + split.codCount;
    final qrShare = total == 0 ? 0.0 : split.qrCount / total;
    final money = Money(split.qrAmountMinor + split.codAmountMinor);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Payment gateway distribution',
                style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: AppRadii.br8,
              child: SizedBox(
                height: 12,
                child: Row(
                  children: [
                    Expanded(
                      flex: (qrShare * 1000).round(),
                      child: ColoredBox(color: AppColors.khqrRed),
                    ),
                    Expanded(
                      flex: 1000 - (qrShare * 1000).round(),
                      child: ColoredBox(color: kCodAccent),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                _LegendDot(color: AppColors.khqrRed),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    'Bakong KHQR · ${split.qrCount} · '
                    '${Money(split.qrAmountMinor).formatUsd()}',
                    style: theme.textTheme.labelSmall,
                  ),
                ),
                _LegendDot(color: kCodAccent),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    'COD · ${split.codCount} · '
                    '${Money(split.codAmountMinor).formatUsd()}',
                    style: theme.textTheme.labelSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Realized volume: ${money.formatUsd()} · '
              'KHQR ${(qrShare * 100).toStringAsFixed(0)}%',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
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
        padding: const EdgeInsets.all(AppSpacing.sm + 4),
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                maxLines: 1,
                style: theme.textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _RankedSection extends StatelessWidget {
  const _RankedSection({required this.title, required this.entries});

  final String title;

  /// Image-aware ranking rows — the thumbnails make the rankings
  /// recognizable at a glance (user feedback 2026-10-28).
  final List<({String name, String metric, String? imageUrl, IconData? fallbackIcon})>
      entries;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (entries.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md),
        Text(title, style: theme.textTheme.titleMedium),
        for (final (index, entry) in entries.indexed)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: theme.colorScheme.secondaryContainer,
                  child:
                      Text('${index + 1}', style: theme.textTheme.labelSmall),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: ClipRRect(
                    borderRadius: AppRadii.br12,
                    child: MonogramImage(
                      imageUrl: entry.imageUrl,
                      name: entry.name,
                      icon: entry.fallbackIcon,
                    ),
                  ),
                ),
              ],
            ),
            title: Text(entry.name,
                maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Text(
              entry.metric,
              style: AppTypography.labelMedium.copyWith(
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
      ],
    );
  }
}
