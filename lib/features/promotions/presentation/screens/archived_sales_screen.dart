import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/presentation/widgets/async_value_widget.dart';
import '../controllers/admin_promotions_controller.dart';
import '../widgets/sale_tile.dart';

/// Home for ended and manually deactivated sales — the same lifecycle split
/// the Coupons section uses (`!active || expired`).
///
/// Sales are never deleted: `banners.sale_id` points at them (`ON DELETE SET
/// NULL`) and the archive is where a switched-off sale is kept. Unlike the
/// coupon archive, the kill switch stays here: the live list now hides
/// inactive sales, so without it deactivating a sale would be irreversible
/// from the app.
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
                'Ended or deactivated sales are kept here. Switch one back on '
                'to make it price products again.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              for (final sale in archived)
                SaleTile(
                  sale: sale,
                  showArchiveState: true,
                  trailing: Semantics(
                    label: 'Activate sale ${sale.name}',
                    child: Switch(
                      value: sale.active,
                      onChanged: (active) => ref
                          .read(adminSalesControllerProvider.notifier)
                          .toggleSale(saleId: sale.id, active: active),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
