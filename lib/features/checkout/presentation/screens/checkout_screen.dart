import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/content_width.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/money.dart';
import '../../../../core/presentation/motion.dart';
import '../../../../core/presentation/widgets/monogram_image.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/coupon_preview.dart';
import '../../domain/entities/payment_method.dart';
import '../controllers/checkout_controller.dart';
import '../controllers/order_totals_provider.dart';
import '../states/checkout_state.dart';

/// Single-page checkout: cart review, address, delivery/payment, coupon,
/// note and summary are visible together; the place-order action stays in a
/// bottom bar. Selection/placement state lives in [CheckoutController].
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key, this.selectedItemIds = const []});

  /// Cart lines ticked in the cart. Empty means the whole cart — the RPC's
  /// backward-compatible default.
  final List<String> selectedItemIds;

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _couponController = TextEditingController();
  final _noteController = TextEditingController();

  /// Family key scoping every checkout provider to the selected lines.
  String get _selectionKey =>
      CheckoutController.selectionKeyFor(widget.selectedItemIds);

  @override
  void dispose() {
    _couponController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _applyCoupon() async {
    final code = _couponController.text.trim();
    if (code.isEmpty) return;
    try {
      final preview = await ref
          .read(checkoutControllerProvider(_selectionKey).notifier)
          .applyCoupon(code);
      if (!mounted) return;
      final message = switch (preview) {
        null => 'Coupon already applied',
        CouponPreview(valid: true) => [
          'Coupon applied',
          if (preview.name.isNotEmpty) preview.name,
          if (preview.offerLabel.isNotEmpty) preview.offerLabel,
          '-${Money(preview.discountMinor).formatUsd()}',
        ].join(' · '),
        final CouponPreview coupon => _couponRequirement(coupon),
      };
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
      if (preview?.valid == true) _couponController.clear();
    } on Failure catch (failure) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(failure.message)));
    }
  }

  /// Human-readable requirement for a rejected coupon. The server supplies
  /// the structured fields; the client formats money and dates.
  static String _couponRequirement(CouponPreview coupon) {
    String day(DateTime value) => value.toLocal().toString().substring(0, 10);

    return switch (coupon.reason) {
      'not_found' => 'Coupon code not found.',
      'inactive' => 'This coupon is no longer active.',
      'not_started' =>
        coupon.startsAt == null
            ? 'This coupon is not active yet.'
            : 'This coupon starts on ${day(coupon.startsAt!)}.',
      'expired' =>
        coupon.endsAt == null
            ? 'This coupon has expired.'
            : 'This coupon expired on ${day(coupon.endsAt!)}.',
      'min_order_not_met' =>
        'Minimum spend is '
            '${Money(coupon.minOrderAmountMinor).formatUsd()} — '
            'your subtotal is ${Money(coupon.subtotalMinor).formatUsd()}.',
      'empty_cart' => 'Add items to your cart before applying a coupon.',
      'not_authenticated' => 'Sign in to use a coupon.',
      _ => coupon.message ?? 'Coupon not applicable.',
    };
  }

  Future<void> _placeOrder() async {
    final orderId = await ref
        .read(checkoutControllerProvider(_selectionKey).notifier)
        .placeOrder();
    if (!mounted) return;
    if (orderId != null) {
      context.pushNamed(AppRoutes.orderPlaced, pathParameters: {'id': orderId});
      return;
    }
    final error = ref
        .read(checkoutControllerProvider(_selectionKey))
        .value
        ?.placementError;
    if (error == null) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(error)));
  }

  Future<void> _addAddress() async {
    await context.pushNamed(AppRoutes.checkoutAddressEdit);
    if (!mounted) return;
    final error = await ref
        .read(checkoutControllerProvider(_selectionKey).notifier)
        .refreshAddresses();
    if (!mounted || error == null) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(userMessageFor(error))));
  }

  @override
  Widget build(BuildContext context) {
    final checkoutAsync = ref.watch(checkoutControllerProvider(_selectionKey));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ContentWidth(
        child: checkoutAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(userMessageFor(error), textAlign: TextAlign.center),
                const SizedBox(height: 8),
                FilledButton.tonal(
                  onPressed: () =>
                      ref.invalidate(checkoutControllerProvider(_selectionKey)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (state) => _buildCheckout(context, theme, state),
        ),
      ),
    );
  }

  Widget _buildCheckout(
    BuildContext context,
    ThemeData theme,
    CheckoutState state,
  ) {
    final summary = state.summary;
    final totalsAsync = ref.watch(orderTotalsPreviewProvider(_selectionKey));
    final totals = totalsAsync.value;
    final totalDiscount =
        totals?.totalDiscountMinor ?? state.discountPreviewMinor;
    final subtotalMinor = totals?.subtotalMinor ?? summary?.subtotalMinor ?? 0;
    final deliveryFeeMinor =
        totals?.deliveryFeeMinor ?? summary?.deliveryFeeMinor ?? 0;
    final totalMinor =
        totals?.totalMinor ??
        (summary?.totalMinor ?? 0) - state.discountPreviewMinor;

    // The preview re-evaluates every applied code against the current cart.
    // Overlay its verdict on the state previews so a code that stops (or
    // starts) qualifying after a cart edit shows the current reason.
    final effectiveCoupons = <String, CouponPreview>{
      for (final coupon in totals?.manual ?? const <CouponPreview>[])
        coupon.code: coupon,
      for (final coupon in totals?.rejected ?? const <CouponPreview>[])
        coupon.code: coupon,
    };
    final stateCodes = state.coupons.map((coupon) => coupon.code).toSet();
    final rejectedCoupons = (totals?.rejected ?? const <CouponPreview>[])
        .where((rejected) => !stateCodes.contains(rejected.code))
        .toList();

    return Column(
      children: [
        Expanded(
          child: AbsorbPointer(
            absorbing: state.isPlacing,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                _SectionCard(
                  title: 'Order items',
                  child: summary == null || summary.items.isEmpty
                      ? const Text('Your cart is empty.')
                      : Column(
                          children: [
                            for (final item in summary.items)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 44,
                                      height: 44,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: MonogramImage(
                                          imageUrl: item.imageUrl,
                                          name: item.productName,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.variantName == null
                                                ? '${item.productName} × ${item.quantity}'
                                                : '${item.productName} (${item.variantName}) × ${item.quantity}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          if (item.hasSale) ...[
                                            Text(
                                              '${Money(item.saleUnitPriceMinor).formatUsd()} each',
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                    color: theme
                                                        .colorScheme
                                                        .onSurfaceVariant,
                                                  ),
                                            ),
                                            Text(
                                              Money(
                                                item.unitPriceMinor,
                                              ).formatUsd(),
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                    color: theme
                                                        .colorScheme
                                                        .onSurfaceVariant,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                            ),
                                          ] else
                                            Text(
                                              '${Money(item.unitPriceMinor).formatUsd()} each',
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                    color: theme
                                                        .colorScheme
                                                        .onSurfaceVariant,
                                                  ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      Money(item.lineTotalMinor).formatUsd(),
                                      style: theme.textTheme.titleSmall,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                ),
                _SectionCard(
                  title: 'Delivery address',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.addresses.isEmpty)
                        const Text('No delivery address yet.')
                      else
                        RadioGroup<String>(
                          groupValue: state.selectedAddressId,
                          onChanged: (value) {
                            if (value != null) {
                              ref
                                  .read(
                                    checkoutControllerProvider(
                                      _selectionKey,
                                    ).notifier,
                                  )
                                  .selectAddress(value);
                            }
                          },
                          child: Column(
                            children: [
                              for (final address in state.addresses)
                                RadioListTile<String>(
                                  value: address.id,
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    '${address.label} · ${address.recipientName}',
                                  ),
                                  subtitle: Text(
                                    [address.line1, address.line2, address.city]
                                        .whereType<String>()
                                        .where((part) => part.isNotEmpty)
                                        .join(', '),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: _addAddress,
                          icon: const Icon(
                            Icons.add_location_alt_outlined,
                            size: 18,
                          ),
                          label: Text(
                            state.addresses.isEmpty
                                ? 'Add delivery address'
                                : 'Add another address',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _SectionCard(
                  title: 'Delivery & payment',
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.local_shipping_outlined),
                        title: const Text('Standard delivery'),
                        subtitle: Text(
                          'Fee: ${Money(deliveryFeeMinor).formatUsd()}',
                        ),
                      ),
                      RadioGroup<PaymentMethod>(
                        groupValue: state.method,
                        onChanged: (value) {
                          if (value != null) {
                            ref
                                .read(
                                  checkoutControllerProvider(
                                    _selectionKey,
                                  ).notifier,
                                )
                                .setMethod(value);
                          }
                        },
                        child: const Column(
                          children: [
                            RadioListTile<PaymentMethod>(
                              value: PaymentMethod.cod,
                              contentPadding: EdgeInsets.zero,
                              title: Text('Cash on Delivery'),
                              subtitle: Text('Pay when your order arrives'),
                            ),
                            RadioListTile<PaymentMethod>(
                              value: PaymentMethod.qr,
                              contentPadding: EdgeInsets.zero,
                              title: Text('QR payment (KHQR)'),
                              subtitle: Text(
                                'Scan with any KHQR-supported banking app',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _SectionCard(
                  title: 'Coupon',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _couponController,
                              decoration: const InputDecoration(
                                hintText: 'Coupon code',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                              textCapitalization: TextCapitalization.characters,
                              onSubmitted: (_) => _applyCoupon(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          FilledButton.tonal(
                            onPressed: _applyCoupon,
                            child: const Text('Apply'),
                          ),
                        ],
                      ),
                      for (final coupon in state.coupons)
                        _CouponStepTile(
                          coupon: effectiveCoupons[coupon.code] ?? coupon,
                          onRemove: () => ref
                              .read(
                                checkoutControllerProvider(
                                  _selectionKey,
                                ).notifier,
                              )
                              .removeCoupon(coupon.code),
                        ),
                      for (final coupon in rejectedCoupons)
                        _CouponStepTile(coupon: coupon),
                    ],
                  ),
                ),
                _SectionCard(
                  title: 'Order note',
                  child: TextField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      hintText: 'Delivery instructions (optional)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    onChanged: ref
                        .read(
                          checkoutControllerProvider(_selectionKey).notifier,
                        )
                        .setNote,
                  ),
                ),
                _SectionCard(
                  title: 'Summary',
                  child: summary == null
                      ? const Text('Your cart is empty.')
                      : Column(
                          children: [
                            if (totalsAsync.hasError)
                              _PreviewNotice(
                                message: userMessageFor(totalsAsync.error!),
                                onRetry: () => ref.invalidate(
                                  orderTotalsPreviewProvider(_selectionKey),
                                ),
                              )
                            else if (totalsAsync.isLoading && totals == null)
                              const _PreviewNotice(
                                message: 'Refreshing totals…',
                              ),
                            _SummaryRow(
                              'Subtotal',
                              Money(subtotalMinor).formatUsd(),
                            ),
                            if (totalDiscount > 0) ...[
                              if (totals != null && totals.manual.isNotEmpty)
                                for (final coupon in totals.manual)
                                  _SummaryRow(
                                    coupon.name.isEmpty
                                        ? 'Discount (${coupon.code})'
                                        : 'Discount · ${coupon.name} '
                                              '(${coupon.code})',
                                    '-${Money(coupon.discountMinor).formatUsd()}',
                                  )
                              else
                                _SummaryRow(
                                  'Discount (codes)',
                                  '-${Money(totalDiscount).formatUsd()}',
                                ),
                            ],
                            _SummaryRow(
                              'Delivery fee',
                              Money(deliveryFeeMinor).formatUsd(),
                            ),
                            const Divider(height: 24),
                            _SummaryRow(
                              'Total',
                              Money(totalMinor).formatUsd(),
                              bold: true,
                            ),
                            _SummaryRow(
                              '',
                              '≈ ${Money(totalMinor).formatKhr()}',
                            ),
                            if (state.method == PaymentMethod.qr)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  'You will scan the KHQR after placing the order.',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
        _PlaceOrderBar(
          totalMinor: totalMinor,
          needsAddress: state.selectedAddressId == null,
          emptyCart: summary == null || summary.items.isEmpty,
          placing: state.isPlacing,
          onPressed: _placeOrder,
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

class _PlaceOrderBar extends StatelessWidget {
  const _PlaceOrderBar({
    required this.totalMinor,
    required this.needsAddress,
    required this.emptyCart,
    required this.placing,
    required this.onPressed,
  });

  final int totalMinor;
  final bool needsAddress;
  final bool emptyCart;
  final bool placing;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final money = Money(totalMinor);
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Total', style: theme.textTheme.labelSmall),
                  AnimatedSwitcher(
                    duration: AppMotion.duration(context, AppMotion.press),
                    switchInCurve: AppMotion.enterCurve,
                    switchOutCurve: AppMotion.exitCurve,
                    child: Text(
                      money.formatUsd(),
                      key: ValueKey(totalMinor),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (needsAddress)
                    Text(
                      'Select a delivery address',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: needsAddress || emptyCart || placing
                  ? null
                  : onPressed,
              child: AnimatedSwitcher(
                duration: AppMotion.duration(context, AppMotion.press),
                switchInCurve: AppMotion.enterCurve,
                switchOutCurve: AppMotion.exitCurve,
                child: placing
                    ? const SizedBox(
                        key: ValueKey('placing'),
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Place order', key: ValueKey('idle')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CouponStepTile extends StatelessWidget {
  const _CouponStepTile({required this.coupon, this.onRemove});

  final CouponPreview coupon;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        coupon.valid ? Icons.check_circle : Icons.error_outline,
        color: coupon.valid
            ? theme.colorScheme.primary
            : theme.colorScheme.error,
      ),
      title: Text(
        coupon.name.isEmpty ? coupon.code : '${coupon.code} · ${coupon.name}',
      ),
      subtitle: coupon.valid
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (coupon.offerLabel.isNotEmpty)
                  Text('Offer: ${coupon.offerLabel}'),
                Text(
                  coupon.minOrderAmountMinor > 0
                      ? 'Minimum spend: '
                            '${Money(coupon.minOrderAmountMinor).formatUsd()}'
                      : 'No minimum spend',
                ),
                Text(
                  'Your discount: '
                  '-${Money(coupon.discountMinor).formatUsd()}'
                  ' · ≈ ${Money(coupon.discountMinor).formatKhr()}',
                ),
              ],
            )
          : Text(_CheckoutScreenState._couponRequirement(coupon)),
      trailing: onRemove == null
          ? null
          : IconButton(
              tooltip: 'Remove coupon',
              onPressed: onRemove,
              icon: const Icon(Icons.close, size: 18),
            ),
    );
  }
}

class _PreviewNotice extends StatelessWidget {
  const _PreviewNotice({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value, {this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = bold
        ? Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
        : Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(value, style: style),
        ],
      ),
    );
  }
}
