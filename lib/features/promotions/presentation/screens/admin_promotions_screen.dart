import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/failures.dart';
import '../../domain/entities/promotion.dart';
import '../controllers/admin_promotions_controller.dart';

/// Admin tab 4 — Promotions (spec §2.4/§27): banner moderation + platform
/// promotion creation. Admin cannot override order/delivery states (§35.4).
class AdminPromotionsScreen extends ConsumerWidget {
  const AdminPromotionsScreen({super.key});

  Future<void> _createPlatformPromotion(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final name = TextEditingController();
    final value = TextEditingController();
    final code = TextEditingController();
    var isPercent = false;
    final created = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('New platform promotion'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: code,
                decoration: const InputDecoration(labelText: 'Coupon code'),
                textCapitalization: TextCapitalization.characters,
              ),
              Row(
                children: [
                  const Text('Percent'),
                  Switch(
                    value: isPercent,
                    onChanged: (v) => setDialogState(() => isPercent = v),
                  ),
                  Expanded(
                    child: TextField(
                      controller: value,
                      decoration: InputDecoration(
                        labelText: isPercent ? 'Percent (1-100)' : 'Amount',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
    if (created != true) return;
    await ref.read(adminPromotionsControllerProvider.notifier).createPlatformPromotion(
          name: name.text.trim(),
          description: '',
          discountType:
              isPercent ? PromoDiscountType.percent : PromoDiscountType.fixed,
          discountValue: int.tryParse(value.text) ?? 0,
          code: code.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promotionsAsync = ref.watch(adminPromotionsControllerProvider);
    final theme = Theme.of(context);

    ref.listen(adminPromotionsControllerProvider, (previous, next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message)));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Promotions'),
        actions: [
          IconButton(
            tooltip: 'New platform promotion',
            icon: const Icon(Icons.add),
            onPressed: () => _createPlatformPromotion(context, ref),
          ),
        ],
      ),
      body: promotionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (promotions) {
          final banners =
              promotions.where((promotion) => promotion.isBanner).toList();
          final coupons =
              promotions.where((promotion) => !promotion.isBanner).toList();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Banners',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              if (banners.isEmpty)
                const Text('No banners submitted.')
              else
                for (final banner in banners)
                  Card(
                    child: ListTile(
                      leading: banner.bannerUrl != null
                          ? Image.network(banner.bannerUrl!,
                              width: 56, height: 40, fit: BoxFit.cover)
                          : const Icon(Icons.campaign_outlined),
                      title: Text(banner.name),
                      subtitle: Text(banner.bannerStatus.name),
                      trailing: PopupMenuButton<String>(
                        onSelected: (action) => ref
                            .read(adminPromotionsControllerProvider.notifier)
                            .moderate(
                              promotionId: banner.id,
                              action: action,
                            ),
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: 'approve', child: Text('Approve')),
                          PopupMenuItem(value: 'reject', child: Text('Reject')),
                          PopupMenuItem(value: 'disable', child: Text('Disable')),
                        ],
                      ),
                    ),
                  ),
              const SizedBox(height: 16),
              Text('Promotions & coupons',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              if (coupons.isEmpty)
                const Text('No promotions.')
              else
                for (final promotion in coupons)
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.confirmation_number_outlined),
                    title: Text(
                        '${promotion.name} (${promotion.scope.name})'),
                    subtitle: Text(
                      '${promotion.coupons.firstOrNull?.code ?? '—'} · '
                      '${promotion.discountType.name} ${promotion.discountValue}'
                      '${promotion.discountType == PromoDiscountType.percent ? '%' : ''}',
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}
