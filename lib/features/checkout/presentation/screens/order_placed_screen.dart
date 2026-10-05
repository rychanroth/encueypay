import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/domain/money.dart';
import '../../../../core/router/app_routes.dart';
import '../../data/repository/checkout_repository_impl.dart';
import '../controllers/order_payment_controller.dart';

/// Order confirmation (Section 6b): success for COD; for QR payments the
/// screen shows the generated KHQR and follows the payment lifecycle in
/// realtime (webhook / Bakong poller / admin simulation all flip the
/// payment row server-side).
class OrderPlacedScreen extends ConsumerStatefulWidget {
  const OrderPlacedScreen({super.key, required this.orderId});

  final String orderId;

  @override
  ConsumerState<OrderPlacedScreen> createState() => _OrderPlacedScreenState();
}

class _OrderPlacedScreenState extends ConsumerState<OrderPlacedScreen> {
  Timer? _pollTimer;

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _pollTimer ??= Timer.periodic(
      const Duration(seconds: 5),
      (_) => ref
          .read(orderPaymentControllerProvider(widget.orderId).notifier)
          .pollBakong(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paymentAsync =
        ref.watch(orderPaymentControllerProvider(widget.orderId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Order placed')),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Icon(Icons.check_circle_outline,
                size: 72, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'Thank you!',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Your order has been placed and is awaiting confirmation.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            paymentAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Text('$error', textAlign: TextAlign.center),
              data: (payment) {
                if (payment.method != 'qr') {
                  // COD: nothing to pay now.
                  return const SizedBox.shrink();
                }
                if (payment.isVerified) {
                  return Column(
                    children: [
                      Icon(Icons.verified_outlined,
                          size: 48, color: theme.colorScheme.primary),
                      const SizedBox(height: 8),
                      Text(
                        'Payment received · ${Money(payment.amountMinor).format()}',
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  );
                }
                // Pending QR: register on first build (account id comes from
                // the admin-managed platform settings), render, poll.
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  final accountId = await ref
                      .read(checkoutRepositoryProvider)
                      .fetchQrAccountId();
                  if (!mounted) return;
                  await ref
                      .read(orderPaymentControllerProvider(widget.orderId)
                          .notifier)
                      .ensureQrRegistered(
                        qrAccountId: accountId,
                        merchantName: 'EncueYPay Prototype',
                      );
                });
                final payload = payment.qrPayload;
                _startPolling();
                return Column(
                  children: [
                    Text(
                      'Complete your payment',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Scan with any Bakong-connected banking app · '
                      '${Money(payment.amountMinor).format()}',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    if (payload == null)
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: QrImageView(
                          data: payload,
                          size: 220,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 14,
                          width: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Waiting for payment confirmation…',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.goNamed(AppRoutes.home),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
