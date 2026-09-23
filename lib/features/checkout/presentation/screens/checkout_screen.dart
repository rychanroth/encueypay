import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/money.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/payment_method.dart';
import '../controllers/checkout_controller.dart';

/// Checkout (spec §23): address selection (snapshot at placement), payment
/// method, coupon preview, place order via the atomic RPC.
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
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
          final canPlace = state.selectedAddressId != null &&
              (summary?.items.isNotEmpty ?? false);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Deliver to',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (state.addresses.isEmpty)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('No addresses yet'),
                    subtitle: const Text(
                      'Add an address in Profile → Addresses, then return here.',
                    ),
                  ),
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
                        Card(
                          child: RadioListTile<String>(
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
                        ),
                    ],
                  ),
                ),
              TextButton.icon(
                onPressed: () =>
                    context.goNamed(AppRoutes.addresses), // cross-branch: go
                icon: const Icon(Icons.location_on_outlined, size: 18),
                label: const Text('Manage addresses (Profile tab)'),
              ),
              const SizedBox(height: 16),
              Text('Payment',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              RadioGroup<PaymentMethod>(
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
                        subtitle: const Text('Pay when your order arrives'),
                      ),
                    ),
                    Card(
                      child: RadioListTile<PaymentMethod>(
                        value: PaymentMethod.bankTransfer,
                        title: const Text('Manual Bank Transfer'),
                        subtitle:
                            const Text('Upload transfer proof after ordering'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text('Coupons',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
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
                  leading: Icon(
                    coupon.valid ? Icons.check_circle : Icons.error_outline,
                    color: coupon.valid
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error,
                  ),
                  title: Text(coupon.code),
                  subtitle: coupon.valid
                      ? Text('-${Money(coupon.discountMinor).format()}')
                      : Text(coupon.message ?? 'Not applicable'),
                ),
              const SizedBox(height: 16),
              Text('Summary',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (summary != null) ...[
                for (final item in summary.items)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.variantName == null
                                ? '${item.productName} × ${item.quantity}'
                                : '${item.productName} (${item.variantName}) × ${item.quantity}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(Money(item.lineTotalMinor).format()),
                      ],
                    ),
                  ),
                const Divider(height: 24),
                _SummaryRow('Subtotal', Money(summary.subtotalMinor).format()),
                if (state.discountPreviewMinor > 0)
                  _SummaryRow(
                    'Discount (preview)',
                    '-${Money(state.discountPreviewMinor).format()}',
                  ),
                _SummaryRow(
                  'Delivery fee',
                  Money(summary.deliveryFeeMinor).format(),
                ),
                const Divider(height: 24),
                _SummaryRow(
                  'Total',
                  Money(state.totalPreviewMinor).format(),
                  bold: true,
                ),
              ],
              const SizedBox(height: 24),
              FilledButton(
                onPressed: canPlace && !checkoutAsync.isLoading
                    ? _placeOrder
                    : null,
                child: checkoutAsync.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Place order'),
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
