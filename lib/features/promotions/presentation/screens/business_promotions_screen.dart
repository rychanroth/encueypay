import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/failures.dart';
import '../../domain/entities/promotion.dart';
import '../controllers/business_promotions_controller.dart';

/// Business promotions management (spec §2.2/§27): ordinary coupons (no
/// approval) + banner submission for admin approval.
class BusinessPromotionsScreen extends ConsumerWidget {
  const BusinessPromotionsScreen({super.key});

  Future<void> _newCoupon(BuildContext context, WidgetRef ref) async {
    final name = TextEditingController();
    final value = TextEditingController();
    final code = TextEditingController();
    var isPercent = false;
    final created = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('New coupon'),
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
    final discountValue = int.tryParse(value.text) ?? 0;
    await ref.read(businessPromotionsControllerProvider.notifier).createCoupon(
          name: name.text.trim(),
          description: '',
          discountType:
              isPercent ? PromoDiscountType.percent : PromoDiscountType.fixed,
          discountValue: discountValue,
          code: code.text.trim(),
        );
  }

  Future<void> _submitBanner(BuildContext context, WidgetRef ref) async {
    final name = TextEditingController();
    final file = await FilePicker.pickFile(type: FileType.image);
    if (file == null || !context.mounted) return;
    final submitted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Submit banner for approval'),
        content: TextField(
          controller: name,
          decoration: const InputDecoration(labelText: 'Banner name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
    if (submitted != true || file.path == null) return;
    await ref.read(businessPromotionsControllerProvider.notifier).submitBanner(
          name: name.text.trim(),
          description: '',
          filePath: file.path!,
          fileName: file.name,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promotionsAsync = ref.watch(businessPromotionsControllerProvider);
    final theme = Theme.of(context);

    ref.listen(businessPromotionsControllerProvider, (previous, next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Promotions')),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () async {
          final choice = await showModalBottomSheet<String>(
            context: context,
            builder: (sheetContext) => SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.confirmation_number_outlined),
                    title: const Text('New coupon'),
                    onTap: () => Navigator.of(sheetContext).pop('coupon'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.campaign_outlined),
                    title: const Text('Submit banner'),
                    onTap: () => Navigator.of(sheetContext).pop('banner'),
                  ),
                ],
              ),
            ),
          );
          if (!context.mounted) return;
          if (choice == 'coupon') {
            await _newCoupon(context, ref);
          }
          if (choice == 'banner' && context.mounted) {
            await _submitBanner(context, ref);
          }
        },
        child: const Icon(Icons.add),
      ),
      body: promotionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (promotions) {
          if (promotions.isEmpty) {
            return const Center(child: Text('No promotions yet.'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (final promotion in promotions)
                Card(
                  child: ListTile(
                    leading: Icon(
                      promotion.isBanner
                          ? Icons.campaign_outlined
                          : Icons.confirmation_number_outlined,
                    ),
                    title: Text(promotion.name),
                    subtitle: promotion.isBanner
                        ? Text('Banner · ${promotion.bannerStatus.name}')
                        : Text(
                            'Coupon ${promotion.coupons.firstOrNull?.code ?? '—'} · '
                            '${promotion.discountType.name} '
                            '${promotion.discountValue}'
                            '${promotion.discountType == PromoDiscountType.percent ? '%' : ''}',
                          ),
                    trailing: promotion.isBanner
                        ? null
                        : Switch(
                            value: promotion.coupons.firstOrNull?.active ?? false,
                            onChanged: (active) {
                              final coupon = promotion.coupons.firstOrNull;
                              if (coupon == null) return;
                              ref
                                  .read(businessPromotionsControllerProvider
                                      .notifier)
                                  .toggleCoupon(
                                    couponId: coupon.id,
                                    active: active,
                                  );
                            },
                          ),
                  ),
                ),
              Text(
                'Business coupons apply at checkout without approval. '
                'Banners appear on the home screen once approved.',
                style: theme.textTheme.bodySmall,
              ),
            ],
          );
        },
      ),
    );
  }
}
