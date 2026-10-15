import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/money.dart';
import '../../../../core/presentation/widgets/monogram_image.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/payment_method.dart';
import '../controllers/checkout_controller.dart';

/// Multi-step checkout (Section 6b — assignment §6 sequence): Cart review →
/// Shipping address → Shipping method → Payment method → Coupon → Order
/// note → Order summary. Placement goes through the atomic RPC; per-step
/// navigation is blocked while the current step is invalid.
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _couponController = TextEditingController();
  final _noteController = TextEditingController();

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
      final valid =
          await ref.read(checkoutControllerProvider.notifier).applyCoupon(code);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(valid ? 'Coupon applied' : 'Coupon not applicable'),
        ));
      if (valid) _couponController.clear();
    } on Failure catch (failure) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(failure.message)));
    }
  }

  Future<void> _placeOrder() async {
    final orderId =
        await ref.read(checkoutControllerProvider.notifier).placeOrder();
    if (!mounted) return;
    if (orderId != null) {
      context.pushNamed(AppRoutes.orderPlaced, pathParameters: {'id': orderId});
    } else {
      final error = ref.read(checkoutControllerProvider).error;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(error is Failure
              ? error.message
              : 'Could not place the order'),
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final checkoutAsync = ref.watch(checkoutControllerProvider);
    final theme = Theme.of(context);
    final controller = ref.read(checkoutControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: checkoutAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$error', textAlign: TextAlign.center),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: () => ref.invalidate(checkoutControllerProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (state) {
          final summary = state.summary;
          return Stepper(
            currentStep: state.currentStep,
            onStepTapped: controller.goToStep,
            onStepContinue: () {
              if (state.currentStep < 6) {
                controller.goToStep(state.currentStep + 1);
                return;
              }
              _placeOrder();
            },
            onStepCancel: () =>
                controller.goToStep(state.currentStep - 1),
            controlsBuilder: (context, details) {
              final isLast = state.currentStep == 6;
              final placing = checkoutAsync.isLoading;
              return Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  children: [
                    FilledButton(
                      onPressed: (ref
                                  .read(checkoutControllerProvider.notifier)
                                  .canContinue() &&
                              !placing)
                          ? details.onStepContinue
                          : null,
                      child: placing && isLast
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(isLast ? 'Place order' : 'Continue'),
                    ),
                    if (state.currentStep > 0) ...[
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: details.onStepCancel,
                        child: const Text('Back'),
                      ),
                    ],
                  ],
                ),
              );
            },
            steps: [
              // 1 — Cart review.
              Step(
                title: const Text('Cart review'),
                isActive: state.currentStep >= 0,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (summary == null || summary.items.isEmpty)
                      const Text('Your cart is empty.')
                    else ...[
                      for (final item in summary.items)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.variantName == null
                                          ? '${item.productName} × ${item.quantity}'
                                          : '${item.productName} (${item.variantName}) × ${item.quantity}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    // Variant-aware unit price under the
                                    // title (falls back to base server-side).
                                    Text(
                                      '${Money(item.unitPriceMinor).formatUsd()} each',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: theme
                                            .colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(Money(item.lineTotalMinor).format()),
                            ],
                          ),
                        ),
                      const Divider(height: 24),
                      _SummaryRow(
                          'Subtotal', Money(summary.subtotalMinor).format()),
                    ],
                  ],
                ),
              ),
              // 2 — Shipping address.
              Step(
                title: const Text('Shipping address'),
                isActive: state.currentStep >= 1,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.addresses.isEmpty)
                      const Text(
                        'No addresses yet — add one in Profile → Addresses.',
                      )
                    else
                      RadioGroup<String>(
                        groupValue: state.selectedAddressId,
                        onChanged: (value) => ref
                            .read(checkoutControllerProvider.notifier)
                            .selectAddress(value!),
                        child: Column(
                          children: [
                            for (final address in state.addresses)
                              RadioListTile<String>(
                                value: address.id,
                                title: Text(
                                    '${address.label} · ${address.recipientName}'),
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
                    TextButton.icon(
                      onPressed: () =>
                          context.goNamed(AppRoutes.addresses), // cross-branch
                      icon: const Icon(Icons.location_on_outlined, size: 18),
                      label:
                          const Text('Manage addresses (Profile tab)'),
                    ),
                  ],
                ),
              ),
              // 3 — Shipping method (single fixed method; fee from settings).
              Step(
                title: const Text('Shipping method'),
                isActive: state.currentStep >= 2,
                content: Card(
                  child: ListTile(
                    leading: const Icon(Icons.local_shipping_outlined),
                    title: const Text('Standard delivery'),
                    subtitle: Text(
                      'Fee: ${Money(summary?.deliveryFeeMinor ?? 0).format()}',
                    ),
                  ),
                ),
              ),
              // 4 — Payment method (Section 6b: QR replaces bank transfer).
              Step(
                title: const Text('Payment method'),
                isActive: state.currentStep >= 3,
                content: RadioGroup<PaymentMethod>(
                  groupValue: state.method,
                  onChanged: (value) => ref
                      .read(checkoutControllerProvider.notifier)
                      .setMethod(value!),
                  child: Column(
                    children: [
                      Card(
                        child: RadioListTile<PaymentMethod>(
                          value: PaymentMethod.cod,
                          title: const Text('Cash on Delivery'),
                          subtitle:
                              const Text('Pay when your order arrives'),
                        ),
                      ),
                      Card(
                        child: RadioListTile<PaymentMethod>(
                          value: PaymentMethod.qr,
                          title: const Text('QR payment (KHQR)'),
                          subtitle: const Text(
                            'Scan with any Bakong-connected banking app',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 5 — Coupon.
              Step(
                title: const Text('Coupon'),
                isActive: state.currentStep >= 4,
                content: Column(
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
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          coupon.valid
                              ? Icons.check_circle
                              : Icons.error_outline,
                          color: coupon.valid
                              ? theme.colorScheme.primary
                              : theme.colorScheme.error,
                        ),
                        title: Row(
                          children: [
                            Text(coupon.code),
                            const SizedBox(width: 8),
                            // Scope recognition chip (DESIGN.md §6.3 step 5).
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'Scope',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onPrimaryContainer,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: coupon.valid
                            ? Text(
                                '-${Money(coupon.discountMinor).formatUsd()} · ≈ ${Money(coupon.discountMinor).formatKhr()}')
                            : Text(coupon.message ?? 'Not applicable'),
                      ),
                  ],
                ),
              ),
              // 6 — Order note.
              Step(
                title: const Text('Order note'),
                isActive: state.currentStep >= 5,
                content: TextField(
                  controller: _noteController,
                  decoration: const InputDecoration(
                    hintText: 'Delivery instructions (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  onChanged: controller.setNote,
                ),
              ),
              // 7 — Order summary.
              Step(
                title: const Text('Summary'),
                isActive: state.currentStep >= 6,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (summary != null) ...[
                      _SummaryRow('Subtotal',
                          Money(summary.subtotalMinor).formatUsd()),
                      if (state.discountPreviewMinor > 0)
                        _SummaryRow(
                          'Discount (preview)',
                          '-${Money(state.discountPreviewMinor).formatUsd()}',
                        ),
                      _SummaryRow(
                        'Delivery fee',
                        Money(summary.deliveryFeeMinor).formatUsd(),
                      ),
                      const Divider(height: 24),
                      _SummaryRow(
                        'Total',
                        Money(state.totalPreviewMinor).formatUsd(),
                        bold: true,
                      ),
                      _SummaryRow(
                        '',
                        '≈ ${Money(state.totalPreviewMinor).formatKhr()}',
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
                  ],
                ),
              ),
            ],
          );
        },
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
        ? Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold)
        : Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: style), Text(value, style: style)],
      ),
    );
  }
}
