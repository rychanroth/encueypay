import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/async_value_widget.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/money.dart';
import '../../../../core/domain/picked_file.dart';
import '../../../../core/network/failure_mapping.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/promotion.dart';
import '../controllers/admin_promotions_controller.dart';
import '../widgets/coupon_tile.dart';
import '../widgets/sale_tile.dart';

/// Admin Promotions tab (spec §2.4/§27): three independent sections —
/// Sales (group pricing: platform/brand/category), Coupons (standalone
/// codes that stack on sale prices at checkout) and Banners (cosmetic
/// advertising, optionally linked to a sale for its tap target). Banners
/// carry no discount; sales carry no code.
class AdminPromotionsScreen extends ConsumerWidget {
  const AdminPromotionsScreen({super.key});

  // ------------------------------------------------------------- helpers

  /// Manual refresh across all three sections (PRES-03 allows screens to
  /// invalidate providers). Awaited so the RefreshIndicator tracks it.
  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(adminSalesControllerProvider);
    ref.invalidate(adminCouponsControllerProvider);
    ref.invalidate(adminBannersControllerProvider);
    try {
      await Future.wait([
        ref.read(adminSalesControllerProvider.future),
        ref.read(adminCouponsControllerProvider.future),
        ref.read(adminBannersControllerProvider.future),
      ]);
    } on Exception catch (error, stackTrace) {
      // Failure states render through the controllers' error branches and
      // the ref.listen snackbars below — nothing to rethrow here.
      logSuppressedError(error, stackTrace);
    }
  }

  // --------------------------------------------------------------- sale

  /// Percent values are whole percentages; fixed values are user-entered
  /// dollars and must reach the RPC as minor units. Parsing them in one
  /// place keeps the two dialogs from drifting.
  static int? _parseDiscountValue(String text, {required bool isPercent}) {
    final input = text.trim();
    if (input.isEmpty) return null;
    if (isPercent) {
      final value = int.tryParse(input);
      return value != null && value > 0 && value <= 100 ? value : null;
    }
    try {
      final value = Money.parse(input).minorUnits;
      return value > 0 ? value : null;
    } on FormatException {
      return null;
    }
  }

  /// New sale: scope (platform/brand/category), percent-or-fixed value,
  /// window — and an optional banner image, which links an approved Home
  /// banner to the sale in the same call (the one-step campaign UX).
  Future<void> _createSale(BuildContext context, WidgetRef ref) async {
    final name = TextEditingController();
    final value = TextEditingController();
    var isPercent = true;
    var scope = SaleScope.platform;
    String? brandId;
    String? categoryId;
    PickedFile? bannerPick;
    DateTime? startsAt;
    DateTime? endsAt;
    // Await the scope options BEFORE opening the dialog — a ref.read inside
    // a dialog freezes an AsyncLoading snapshot (autoDispose providers with
    // no listener never update it). Same pattern as the coupon dialog.
    List<PromoBrandRef> brands;
    List<PromoCategoryRef> categories;
    try {
      brands = await ref.read(promoBrandsProvider.future);
      categories = await ref.read(promoCategoriesProvider.future);
    } on Failure catch (failure) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(failure.message)));
      return;
    }
    if (!context.mounted) return;
    final submitted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          return AlertDialog(
            title: const Text('New sale'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: name,
                    decoration:
                        const InputDecoration(labelText: 'Sale name'),
                  ),
                  const SizedBox(height: 8),
                  // Scope decides which products the sale prices apply to.
                  DropdownButtonFormField<SaleScope>(
                    initialValue: scope,
                    decoration: const InputDecoration(labelText: 'Scope'),
                    items: const [
                      DropdownMenuItem(
                        value: SaleScope.platform,
                        child: Text('Platform-wide (all products)'),
                      ),
                      DropdownMenuItem(
                        value: SaleScope.brand,
                        child: Text('Brand'),
                      ),
                      DropdownMenuItem(
                        value: SaleScope.category,
                        child: Text('Category'),
                      ),
                    ],
                    onChanged: (v) => setDialogState(() {
                      scope = v ?? SaleScope.platform;
                      brandId = null;
                      categoryId = null;
                    }),
                  ),
                  if (scope == SaleScope.brand)
                    DropdownButtonFormField<String>(
                      initialValue: brandId,
                      decoration: const InputDecoration(labelText: 'Brand'),
                      items: [
                        for (final brand in brands)
                          DropdownMenuItem(
                            value: brand.id,
                            child: Text(brand.name),
                          ),
                      ],
                      onChanged: (id) => setDialogState(() => brandId = id),
                    ),
                  if (scope == SaleScope.category)
                    DropdownButtonFormField<String>(
                      initialValue: categoryId,
                      decoration:
                          const InputDecoration(labelText: 'Category'),
                      items: [
                        for (final category in categories)
                          DropdownMenuItem(
                            value: category.id,
                            child: Text(category.name),
                          ),
                      ],
                      onChanged: (id) =>
                          setDialogState(() => categoryId = id),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Percent off'),
                      Switch(
                        value: isPercent,
                        onChanged: (v) => setDialogState(() => isPercent = v),
                      ),
                      Expanded(
                        child: TextField(
                          controller: value,
                          decoration: InputDecoration(
                            labelText: isPercent
                                ? 'Discount percent (1-100)'
                                : 'Discount amount per item (USD)',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
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
                  const SizedBox(height: 8),
                  // Optional banner: linked to the sale for its Home tap
                  // target, live immediately. The banner hides itself when
                  // the sale is off.
                  Row(
                    children: [
                      FilledButton.tonalIcon(
                        onPressed: () async {
                          final file = await FilePicker.pickFile(
                              type: FileType.image);
                          if (file == null) return;
                          final pick = PickedFile(
                            bytes: await file.readAsBytes(),
                            fileName: file.name,
                          );
                          setDialogState(() => bannerPick = pick);
                        },
                        icon: const Icon(Icons.image_outlined, size: 18),
                        label: Text(bannerPick == null
                            ? 'Attach banner image'
                            : bannerPick!.fileName),
                      ),
                      if (bannerPick != null)
                        IconButton(
                          tooltip: 'Remove banner image',
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () =>
                              setDialogState(() => bannerPick = null),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Prices tagged products directly — no code, no minimum '
                    'order. With an image, a live Home banner links to the '
                    'sale and hides itself when the sale ends.',
                    style: Theme.of(dialogContext)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                          color: Theme.of(dialogContext)
                              .colorScheme
                              .onSurfaceVariant,
                        ),
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
                onPressed: () {
                  final discount = _parseDiscountValue(
                    value.text,
                    isPercent: isPercent,
                  );
                  final groupMissing =
                      (scope == SaleScope.brand && brandId == null) ||
                          (scope == SaleScope.category && categoryId == null);
                  if (name.text.trim().isEmpty ||
                      discount == null ||
                      groupMissing) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Name, a positive discount and the scope group '
                            '(for brand/category) are required'),
                      ),
                    );
                    return;
                  }
                  Navigator.of(dialogContext).pop(true);
                },
                child: const Text('Create sale'),
              ),
            ],
          );
        },
      ),
    );
    if (submitted != true) return;
    if (!context.mounted) return;
    await ref.read(adminSalesControllerProvider.notifier).createSale(
          name: name.text.trim(),
          description: '',
          scope: scope,
          discountType:
              isPercent ? PromoDiscountType.percent : PromoDiscountType.fixed,
          discountValue:
              _parseDiscountValue(value.text, isPercent: isPercent)!,
          startsAt: startsAt,
          endsAt: endsAt,
          brandId: scope == SaleScope.brand ? brandId : null,
          categoryId: scope == SaleScope.category ? categoryId : null,
          image: bannerPick,
        );
  }

  // -------------------------------------------------------------- coupon

  /// New standalone coupon code: cart-wide, stacks on sale prices.
  Future<void> _createCoupon(BuildContext context, WidgetRef ref) async {
    final name = TextEditingController();
    final value = TextEditingController();
    final code = TextEditingController();
    final minOrder = TextEditingController();
    var isPercent = false;
    DateTime? startsAt;
    DateTime? endsAt;
    final submitted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          return AlertDialog(
            title: const Text('New coupon'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: name,
                    decoration: const InputDecoration(
                        labelText: 'Coupon name (optional)'),
                  ),
                  TextField(
                    controller: code,
                    decoration: const InputDecoration(
                      labelText: 'Coupon code',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Percent off'),
                      Switch(
                        value: isPercent,
                        onChanged: (v) => setDialogState(() => isPercent = v),
                      ),
                      Expanded(
                        child: TextField(
                          controller: value,
                          decoration: InputDecoration(
                            labelText: isPercent
                                ? 'Discount percent (1-100)'
                                : 'Discount amount (USD)',
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
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
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
                  const SizedBox(height: 4),
                  Text(
                    'Customers type this code at checkout; it stacks on top '
                    'of sale prices and applies to the whole cart.',
                    style: Theme.of(dialogContext)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                          color: Theme.of(dialogContext)
                              .colorScheme
                              .onSurfaceVariant,
                        ),
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
                onPressed: () {
                  final discount = _parseDiscountValue(
                    value.text,
                    isPercent: isPercent,
                  );
                  if (code.text.trim().isEmpty || discount == null) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'A code and a positive discount are required'),
                      ),
                    );
                    return;
                  }
                  Navigator.of(dialogContext).pop(true);
                },
                child: const Text('Create coupon'),
              ),
            ],
          );
        },
      ),
    );
    if (submitted != true) return;
    if (!context.mounted) return;
    await ref.read(adminCouponsControllerProvider.notifier).createCoupon(
          name: name.text.trim(),
          code: code.text.trim(),
          discountType:
              isPercent ? PromoDiscountType.percent : PromoDiscountType.fixed,
          discountValue:
              _parseDiscountValue(value.text, isPercent: isPercent)!,
          minOrderAmountMinor: minOrder.text.trim().isEmpty
              ? 0
              : Money.parse(minOrder.text.trim()).minorUnits,
          startsAt: startsAt,
          endsAt: endsAt,
        );
  }

  Future<void> _deleteCoupon(
    BuildContext context,
    WidgetRef ref,
    ManagedCoupon coupon,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete coupon?'),
        content: Text(
          'Delete ${coupon.code}? This cannot be undone. Codes already used '
          'on an order cannot be deleted — deactivate those instead so the '
          'order keeps its discount history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref
        .read(adminCouponsControllerProvider.notifier)
        .deleteCoupon(couponId: coupon.id);
  }

  // -------------------------------------------------------------- banner

  /// Display-only banner: inert imagery with no sale behind it.
  Future<void> _createDisplayBanner(BuildContext context, WidgetRef ref) async {
    final file = await FilePicker.pickFile(type: FileType.image);
    if (file == null || !context.mounted) return;
    final image = PickedFile(
      bytes: await file.readAsBytes(),
      fileName: file.name,
    );
    if (!context.mounted) return;
    final name = TextEditingController();
    final submitted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('New display banner'),
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
            child: const Text('Create'),
          ),
        ],
      ),
    );
    if (submitted != true) return;
    if (!context.mounted) return;
    await ref.read(adminBannersControllerProvider.notifier).createBanner(
          name: name.text.trim(),
          description: '',
          image: image,
        );
  }

  // --------------------------------------------------------------- build

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesAsync = ref.watch(adminSalesControllerProvider);
    final couponsAsync = ref.watch(adminCouponsControllerProvider);
    final bannersAsync = ref.watch(adminBannersControllerProvider);
    final theme = Theme.of(context);

    void showError(AsyncValue<Object?> next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(userMessageFor(error))));
      }
    }

    ref.listen(adminSalesControllerProvider, (_, next) => showError(next));
    ref.listen(adminCouponsControllerProvider, (_, next) => showError(next));
    ref.listen(adminBannersControllerProvider, (_, next) => showError(next));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales & coupons'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: () => _refresh(ref),
          ),
          IconButton(
            tooltip: 'New sale',
            icon: const Icon(Icons.campaign_outlined),
            onPressed: () => _createSale(context, ref),
          ),
          IconButton(
            tooltip: 'New coupon',
            icon: const Icon(Icons.add),
            onPressed: () => _createCoupon(context, ref),
          ),
          IconButton(
            tooltip: 'New display banner',
            icon: const Icon(Icons.image_outlined),
            onPressed: () => _createDisplayBanner(context, ref),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(ref),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sales',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: () =>
                      context.pushNamed(AppRoutes.adminArchivedSales),
                  icon: const Icon(Icons.inventory_2_outlined, size: 18),
                  label: const Text('Archived'),
                ),
              ],
            ),
            salesAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(8),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              error: (error, _) => AsyncErrorView(
                message: userMessageFor(error),
                retry: () => ref.invalidate(adminSalesControllerProvider),
              ),
              data: (sales) {
                final now = DateTime.now().toUtc();
                final live = sales
                    .where((sale) => !sale.isArchivedAt(now))
                    .toList();
                if (live.isEmpty) {
                  return const Text(
                      'No live or scheduled sales. Check Archived.');
                }
                return Column(
                  children: [
                    for (final sale in live)
                      SaleTile(
                        sale: sale,
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
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Coupons',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: () =>
                      context.pushNamed(AppRoutes.adminArchivedCoupons),
                  icon: const Icon(Icons.inventory_2_outlined, size: 18),
                  label: const Text('Archived'),
                ),
              ],
            ),
            couponsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(8),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              error: (error, _) => AsyncErrorView(
                message: userMessageFor(error),
                retry: () => ref.invalidate(adminCouponsControllerProvider),
              ),
              data: (coupons) {
                final now = DateTime.now().toUtc();
                final live = coupons
                    .where((coupon) => !coupon.isArchivedAt(now))
                    .toList();
                if (live.isEmpty) {
                  return const Text(
                      'No live or scheduled coupons. Check Archived.');
                }
                return Column(
                  children: [
                    for (final coupon in live)
                      CouponTile(
                        coupon: coupon,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Semantics(
                              label: 'Activate coupon ${coupon.code}',
                              child: Switch(
                                value: coupon.active,
                                onChanged: (active) => ref
                                    .read(
                                        adminCouponsControllerProvider.notifier)
                                    .toggleCoupon(
                                        couponId: coupon.id, active: active),
                              ),
                            ),
                            IconButton(
                              tooltip: 'Delete coupon',
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () =>
                                  _deleteCoupon(context, ref, coupon),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
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
              error: (error, _) => AsyncErrorView(
                message: userMessageFor(error),
                retry: () => ref.invalidate(adminBannersControllerProvider),
              ),
              data: (banners) {
                if (banners.isEmpty) {
                  return const Text('No banners submitted.');
                }
                return Column(
                  children: [
                    for (final banner in banners)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: banner.imageUrl.isEmpty
                            ? const SizedBox(
                                width: 56,
                                height: 40,
                                child: Icon(Icons.image_not_supported_outlined),
                              )
                            : Image.network(banner.imageUrl,
                                width: 56, height: 40, fit: BoxFit.cover),
                        title: Text(banner.name),
                        subtitle: Text('Banner · ${banner.status.name}'),
                        trailing: PopupMenuButton<String>(
                          tooltip: 'Banner actions for ${banner.name}',
                          onSelected: (action) async {
                            if (action == 'reject' || action == 'disable') {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (dialogContext) => AlertDialog(
                                  title: Text(
                                    action == 'reject'
                                        ? 'Reject banner?'
                                        : 'Disable banner?',
                                  ),
                                  content: Text(
                                    action == 'reject'
                                        ? 'The banner will not be shown.'
                                        : 'The banner will be hidden from customers.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(dialogContext)
                                              .pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    FilledButton(
                                      onPressed: () =>
                                          Navigator.of(dialogContext).pop(true),
                                      child: Text(
                                        action == 'reject' ? 'Reject' : 'Disable',
                                      ),
                                    ),
                                  ],
                                ),
                              );
                              if (confirmed != true) return;
                            }
                            await ref
                                .read(adminBannersControllerProvider.notifier)
                                .moderate(
                                  bannerId: banner.id,
                                  action: action,
                                );
                          },
                          itemBuilder: (context) => [
                            if (banner.status != BannerStatus.approved &&
                                banner.status != BannerStatus.disabled)
                              const PopupMenuItem(
                                value: 'approve',
                                child: Text('Approve'),
                              ),
                            if (banner.status == BannerStatus.pending)
                              const PopupMenuItem(
                                value: 'reject',
                                child: Text('Reject'),
                              ),
                            if (banner.status != BannerStatus.disabled)
                              const PopupMenuItem(
                                value: 'disable',
                                child: Text('Disable'),
                              ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
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
