import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/money.dart';
import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/presentation/theme/app_typography.dart';
import '../../../../core/presentation/widgets/khqr_card.dart';
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
            // Success celebration (§6.4): emerald check over the royal
            // headline.
            Icon(Icons.check_circle_outline,
                size: 72, color: AppColors.accentEmerald),
            const SizedBox(height: 16),
            Text('Thank you!',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium),
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
                  final money = Money(payment.amountMinor);
                  return Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.accentEmeraldLight,
                      borderRadius: AppRadii.br16,
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.verified_outlined,
                            size: 48, color: AppColors.accentEmerald),
                        const SizedBox(height: AppSpacing.sm),
                        Text('Payment received',
                            style: theme.textTheme.titleMedium),
                        Text(
                          '${money.formatUsd()} · ≈ ${money.formatKhr()}',
                          style: AppTypography.bodySmall.copyWith(
                            color: const Color(0xFF047857),
                          ),
                        ),
                      ],
                    ),
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
                final money = Money(payment.amountMinor);
                return Column(
                  children: [
                    Text('Complete your payment',
                        style: theme.textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Realtime listener follows the payment lifecycle — '
                      'webhook, poller and admin simulation all settle here.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (payload == null)
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      )
                    else
                      // Official NBC Bakong KHQR card (§6.4).
                      KhqrCard(
                        qrPayload: payload,
                        amountUsd: money.formatUsd(),
                        amountKhr: money.formatKhr(),
                      ),
                    const SizedBox(height: AppSpacing.md),
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
