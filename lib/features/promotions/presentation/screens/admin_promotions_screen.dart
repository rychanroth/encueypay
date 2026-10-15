import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/money.dart';
import '../../domain/entities/promotion.dart';
import '../controllers/admin_promotions_controller.dart';

/// Admin Promotions tab (spec §2.4/§27; §5b redesign): the Coupons section
/// manages discount rules + their codes (one atomic creation flow), the
/// Banners section moderates the advertising surface. Banners carry no
/// discount; coupons carry the assignment §5 attribute set.
class AdminPromotionsScreen extends ConsumerWidget {
  const AdminPromotionsScreen({super.key});

  Future<void> _createCoupon(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final name = TextEditingController();
    final value = TextEditingController();
    final code = TextEditingController();
    final minOrder = TextEditingController();
    var isPercent = false;
    DateTime? startsAt;
    DateTime? endsAt;
    String? brandId;
    final brandsAsync = ref.read(promoBrandsProvider);
    final created = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('New coupon'),
          content: SingleChildScrollView(
            child: Column(
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
                TextField(
                  controller: minOrder,
                  decoration: const InputDecoration(
                    labelText: 'Minimum order amount (optional)',
                    prefixText: '\$ ',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true),
                ),
                const SizedBox(height: 8),
                // Scope picker (Section 2d/5b): platform-wide or brand-wide.
                brandsAsync.maybeWhen(
                  data: (brands) => DropdownButtonFormField<String>(
                    initialValue: brandId,
                    decoration: const InputDecoration(labelText: 'Scope'),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Platform-wide'),
                      ),
                      for (final brand in brands)
                        DropdownMenuItem(
                          value: brand.id,
                          child: Text('Brand: ${brand.name}'),
                        ),
                    ],
                    onChanged: (v) => setDialogState(() => brandId = v),
                  ),
                  orElse: () => const SizedBox.shrink(),
                ),
                const SizedBox(height: 8),
                // Date window (assignment §5) — derived at validation time.
                Row(
                  children: [
                    Expanded(
                      child: _DateField(
                        label: 'Starts',
                        value: startsAt,
                        onChanged: (v) => setDialogState(() => startsAt = v),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _DateField(
                        label: 'Ends',
                        value: endsAt,
                        onChanged: (v) => setDialogState(() => endsAt = v),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
    var minOrderMinor = 0;
    if (minOrder.text.trim().isNotEmpty) {
      minOrderMinor = Money.parse(minOrder.text.trim()).minorUnits;
    }
    await ref.read(adminPromotionsControllerProvider.notifier).createPlatformPromotion(
          name: name.text.trim(),
          description: '',
          discountType:
              isPercent ? PromoDiscountType.percent : PromoDiscountType.fixed,
          discountValue: int.tryParse(value.text) ?? 0,
          code: code.text.trim(),
          minOrderAmountMinor: minOrderMinor,
          startsAt: startsAt,
          endsAt: endsAt,
          brandId: brandId,
        );
  }

  Future<void> _createBanner(BuildContext context, WidgetRef ref) async {
    final file = await FilePicker.pickFile(type: FileType.image);
    if (file == null || file.path == null || !context.mounted) return;
    final name = TextEditingController();
    var targetKind = BannerTargetKind.none;
    String? targetId;
    final brandsAsync = ref.read(promoBrandsProvider);
    final categoriesAsync = ref.read(promoCategoriesProvider);
    final submitted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('New banner'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: name,
                  decoration: const InputDecoration(labelText: 'Banner name'),
                ),
                const SizedBox(height: 8),
                // Destination (Section 9): the tap-through target — Discovery
                // pre-filtered to a brand or a category; 'none' stays inert.
                DropdownButtonFormField<BannerTargetKind>(
                  initialValue: targetKind,
                  decoration:
                      const InputDecoration(labelText: 'Opens (tap target)'),
                  items: const [
                    DropdownMenuItem(
                      value: BannerTargetKind.none,
                      child: Text('Nothing (display only)'),
                    ),
                    DropdownMenuItem(
                      value: BannerTargetKind.brand,
                      child: Text('Discovery — Brand'),
                    ),
                    DropdownMenuItem(
                      value: BannerTargetKind.category,
                      child: Text('Discovery — Category'),
                    ),
                  ],
                  onChanged: (kind) => setDialogState(() {
                    targetKind = kind ?? BannerTargetKind.none;
                    targetId = null;
                  }),
                ),
                if (targetKind == BannerTargetKind.brand)
                  brandsAsync.maybeWhen(
                    data: (brands) =>
                        DropdownButtonFormField<String>(
                      initialValue: targetId,
                      decoration:
                          const InputDecoration(labelText: 'Brand'),
                      items: [
                        for (final brand in brands)
                          DropdownMenuItem(
                            value: brand.id,
                            child: Text(brand.name),
                          ),
                      ],
                      onChanged: (id) => setDialogState(() => targetId = id),
                    ),
                    orElse: () => const LinearProgressIndicator(),
                  ),
                if (targetKind == BannerTargetKind.category)
                  categoriesAsync.maybeWhen(
                    data: (categories) =>
                        DropdownButtonFormField<String>(
                      initialValue: targetId,
                      decoration:
                          const InputDecoration(labelText: 'Category'),
                      items: [
                        for (final category in categories)
                          DropdownMenuItem(
                            value: category.id,
                            child: Text(category.name),
                          ),
                      ],
                      onChanged: (id) => setDialogState(() => targetId = id),
                    ),
                    orElse: () => const LinearProgressIndicator(),
                  ),
              ],
            ),
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
    if (submitted != true) return;
    if (!context.mounted) return;
    if (targetKind != BannerTargetKind.none && targetId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pick the brand or category the banner opens'),
        ),
      );
      return;
    }
    // The Discovery context banner shows a name — snapshot it at creation
    // so the CTA survives later renames/archivals of the target.
    String? targetName;
    if (targetKind == BannerTargetKind.brand) {
      targetName = brandsAsync.value
          ?.where((brand) => brand.id == targetId)
          .firstOrNull
          ?.name;
    } else if (targetKind == BannerTargetKind.category) {
      targetName = categoriesAsync.value
          ?.where((category) => category.id == targetId)
          .firstOrNull
          ?.name;
    }
    await ref.read(adminPromotionsControllerProvider.notifier).createBanner(
          name: name.text.trim(),
          description: '',
          filePath: file.path!,
          fileName: file.name,
          targetKind: targetKind,
          targetId: targetId,
          targetName: targetName,
        );
  }

  /// Manual refresh: re-fetch coupons and banners (PRES-03 allows screens to
  /// invalidate providers). Awaited so the RefreshIndicator tracks the fetch.
  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(adminPromotionsControllerProvider);
    ref.invalidate(adminBannersControllerProvider);
    try {
      await Future.wait([
        ref.read(adminPromotionsControllerProvider.future),
        ref.read(adminBannersControllerProvider.future),
      ]);
    } on Exception catch (_) {
      // Failure states render through the controllers' error branches and
      // the ref.listen snackbars below — nothing to rethrow here.
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promotionsAsync = ref.watch(adminPromotionsControllerProvider);
    final bannersAsync = ref.watch(adminBannersControllerProvider);
    final theme = Theme.of(context);

    ref.listen(adminPromotionsControllerProvider, (previous, next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message)));
      }
    });
    ref.listen(adminBannersControllerProvider, (previous, next) {
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
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: () => _refresh(ref),
          ),
          IconButton(
            tooltip: 'New coupon',
            icon: const Icon(Icons.add),
            onPressed: () => _createCoupon(context, ref),
          ),
          IconButton(
            tooltip: 'New banner',
            icon: const Icon(Icons.campaign_outlined),
            onPressed: () => _createBanner(context, ref),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(ref),
        child: promotionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ListView(
          // Scrollable so the pull-to-refresh gesture works on errors too.
          children: [Center(child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('$error', textAlign: TextAlign.center),
          ))],
        ),
        data: (promotions) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Coupons',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              if (promotions.isEmpty)
                const Text('No coupons yet. Use + to create one.')
              else
                for (final promotion in promotions)
                  Card(
                    margin: const EdgeInsets.only(top: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  promotion.name,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: promotion.active
                                        ? null
                                        : theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                              AdminCouponScopeChip(promotion: promotion),
                            ],
                          ),
                          const SizedBox(height: 4),
                          for (final coupon in promotion.coupons)
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(
                                coupon.active
                                    ? Icons.confirmation_number_outlined
                                    : Icons.confirmation_number,
                                size: 20,
                              ),
                              title: Text(
                                '${coupon.code} · '
                                '${promotion.discountType.name} '
                                '${promotion.discountValue}'
                                '${promotion.discountType == PromoDiscountType.percent ? '%' : ''}',
                              ),
                              subtitle: Text(
                                '${Money(coupon.minOrderAmountMinor).format()} min'
                                '${coupon.startsAt == null ? '' : ' · from ${_day(coupon.startsAt!)}'}'
                                '${coupon.endsAt == null ? '' : ' · until ${_day(coupon.endsAt!)}'}',
                              ),
                              trailing: Switch(
                                value: coupon.active,
                                onChanged: (active) => ref
                                    .read(adminPromotionsControllerProvider
                                        .notifier)
                                    .toggleCoupon(
                                      couponId: coupon.id,
                                      active: active,
                                    ),
                              ),
                            ),
                          if (promotion.coupons.isEmpty)
                            const Text('No coupon code issued.'),
                        ],
                      ),
                    ),
                  ),
              const SizedBox(height: 16),
              Text('Banners',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              bannersAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(8),
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                error: (error, _) => Text('$error'),
                data: (banners) {
                  if (banners.isEmpty) {
                    return const Text('No banners submitted.');
                  }
                  return Column(
                    children: [
                      for (final banner in banners)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Image.network(banner.imageUrl,
                              width: 56, height: 40, fit: BoxFit.cover),
                          title: Text(banner.name),
                          subtitle: Text(
                            'Banner · ${banner.status.name}'
                            '${banner.targetKind == BannerTargetKind.none ? '' : ' · opens ${banner.targetKind.name}: ${banner.targetName ?? banner.targetId}'}',
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (action) => ref
                                .read(adminBannersControllerProvider.notifier)
                                .moderate(bannerId: banner.id, action: action),
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                  value: 'approve', child: Text('Approve')),
                              PopupMenuItem(
                                  value: 'reject', child: Text('Reject')),
                              PopupMenuItem(
                                  value: 'disable', child: Text('Disable')),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          );
        },
        ),
      ),
    );
  }

  static String _day(DateTime value) =>
      value.toLocal().toString().substring(0, 10);
}

/// Scope label for a promotion row (Section 5b).
class AdminCouponScopeChip extends StatelessWidget {
  const AdminCouponScopeChip({super.key, required this.promotion});

  final MyPromotion promotion;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = switch (promotion.scope) {
      PromotionScope.platform => 'Platform',
      PromotionScope.brand => 'Brand: ${promotion.brandName ?? '—'}',
      PromotionScope.business => 'Business (legacy)',
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  Future<void> _pick(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    // The whole field is the tap target. The previous version wrapped only a
    // childless SizedBox, which never wins hit tests — the picker could not
    // open at all.
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _pick(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: value == null ? label : '$label: ${_day(value!)}',
          isDense: true,
          suffixIcon: value == null
              ? IconButton(
                  tooltip: 'Pick date',
                  icon: const Icon(Icons.calendar_today, size: 18),
                  onPressed: () => _pick(context),
                )
              : IconButton(
                  tooltip: 'Clear date',
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: () => onChanged(null),
                ),
        ),
        child: const SizedBox(height: 8),
      ),
    );
  }

  static String _day(DateTime value) =>
      value.toLocal().toString().substring(0, 10);
}
