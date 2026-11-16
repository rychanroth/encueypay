import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/presentation/widgets/async_value_widget.dart';
import '../controllers/admin_promotions_controller.dart';
import '../widgets/sale_tile.dart';

/// Sales retired with the archive action. Disabled and ended sales are NOT
/// here — they stay in the admin list (Disabled / Ended); only an explicit
/// archive moves a sale out of it.
///
/// Sales are never deleted: `banners.sale_id` points at them (`ON DELETE SET
/// NULL`), so the archive is where a retired sale lives. Restore puts it back
/// in the list as Disabled (archiving switched it off).
class ArchivedSalesScreen extends ConsumerWidget {
  const ArchivedSalesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesAsync = ref.watch(adminSalesControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Archived sales')),
      body: salesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AsyncErrorView(
          message: userMessageFor(error),
          retry: () => ref.invalidate(adminSalesControllerProvider),
        ),
        data: (sales) {
          final now = DateTime.now().toUtc();
          final archived =
              sales.where((sale) => sale.isArchivedAt(now)).toList();
          if (archived.isEmpty) {
            return const Center(child: Text('No archived sales.'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Archived sales are kept for banner links and history. '
                'Restore puts one back in the list as disabled.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              for (final sale in archived)
                SaleTile(
                  sale: sale,
                  trailing: IconButton(
                    tooltip: 'Restore sale',
                    icon: const Icon(Icons.unarchive_outlined),
                    onPressed: () => ref
                        .read(adminSalesControllerProvider.notifier)
                        .archiveSale(saleId: sale.id, archived: false),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
