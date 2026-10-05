import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/money.dart';
import '../controllers/admin_reports_controller.dart';

/// Reporting & Analytics (Section 8C, assignment §8): a date-range report —
/// orders, completed/cancelled, total sales, AOV, best sellers, top
/// categories, low stock, purchase frequency. Deeper than the dashboard's
/// at-a-glance insight; nested under the Admin dashboard tab.
class AdminReportsScreen extends ConsumerWidget {
  const AdminReportsScreen({super.key});

  Future<void> _pickRange(BuildContext context, WidgetRef ref) async {
    final current =
        ref.read(adminReportsControllerProvider(defaultReportRange())).value;
    // The report's from/to ARE the active range.
    final initialRange = current == null
        ? defaultReportRange()
        : ReportRange(from: current.from, to: current.to);
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      initialDateRange:
          DateTimeRange(start: initialRange.from, end: initialRange.to),
    );
    if (picked != null) {
      await ref
          .read(adminReportsControllerProvider(defaultReportRange()).notifier)
          .setRange(ReportRange(from: picked.start, to: picked.end));
    }
  }

  static String _day(DateTime value) =>
      value.toLocal().toString().substring(0, 10);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = defaultReportRange();
    final reportAsync = ref.watch(adminReportsControllerProvider(range));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        actions: [
          TextButton.icon(
            onPressed: () => _pickRange(context, ref),
            icon: const Icon(Icons.date_range, size: 18),
            label: const Text('Range'),
          ),
        ],
      ),
      body: reportAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$error', textAlign: TextAlign.center),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: () => ref
                    .invalidate(adminReportsControllerProvider(range)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (report) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${_day(report.from)} – ${_day(report.to)}',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _pickRange(context, ref),
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Change'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // KPI summary.
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                      label: 'Orders', value: '${report.totalOrders}'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatCard(
                      label: 'Completed',
                      value: '${report.completedOrders}'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatCard(
                      label: 'Cancelled',
                      value: '${report.cancelledOrders}'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                      label: 'Total sales',
                      value: Money(report.totalSalesMinor).format()),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatCard(
                      label: 'Avg order value',
                      value: Money(report.averageOrderValueMinor).format()),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${report.lowStockProducts} low-stock (≤5) · '
              '${report.outOfStockProducts} out of stock (current)',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            _RankedSection(
              title: 'Best sellers',
              entries: [
                for (final item in report.bestSellers)
                  (item.name, '${item.units} sold'),
              ],
            ),
            _RankedSection(
              title: 'Top categories',
              entries: [
                for (final item in report.topCategories)
                  (item.name, '${item.units} sold'),
              ],
            ),
            _RankedSection(
              title: 'Customer purchase frequency',
              entries: [
                for (final item in report.purchaseFrequency)
                  (item.name, '${item.orders} order(s)'),
              ],
            ),
          ],
        ),
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
            Text(label,
                style: theme.textTheme.bodySmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _RankedSection extends StatelessWidget {
  const _RankedSection({required this.title, required this.entries});

  final String title;
  final List<(String, String)> entries;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (entries.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(title,
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        for (final (index, entry) in entries.indexed)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 12,
              backgroundColor: theme.colorScheme.secondaryContainer,
              child: Text('${index + 1}',
                  style: theme.textTheme.labelSmall),
            ),
            title: Text(entry.$1,
                maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Text(entry.$2),
          ),
      ],
    );
  }
}
