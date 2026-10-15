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

/// Order confirmation (Section 6b). State semantics are explicit — they are
/// NOT equivalent:
///
///   * Order placed  → the `create_order_from_cart` RPC committed the order
///     and its `pending` payment row. That is all the initial screen shows;
///     it is NOT a paid state.
///   * QR pending    → the KHQR renders and the screen polls the Bakong
///     confirmation API every 5 s while Supabase Realtime watches the
///     `payments` row (webhook / poller / admin simulation all settle
///     server-side; the UI never flips states on its own).
///   * Verified      → the realtime stream (or a fresh snapshot) delivered
///     `transaction_verified` — the only state that claims payment success.
class OrderPlacedScreen extends ConsumerStatefulWidget {
  const OrderPlacedScreen({super.key, required this.orderId});

  final String orderId;

  @override
  ConsumerState<OrderPlacedScreen> createState() => _OrderPlacedScreenState();
}

class _OrderPlacedScreenState extends ConsumerState<OrderPlacedScreen> {
  Timer? _pollTimer;

  /// Registration is one-shot per screen instance: a `build()`-driven
  /// re-registration raced the realtime update (the client never saw its own
  /// `qr_payload` when Realtime was down) and re-fired the RPC on every
  /// rebuild — the server UPDATE re-triggered the stream and the loop fed
  /// itself (~2 s cadence). Registration is initiated once, from the
  /// lifecycle, never from build().
  bool _registrationAttempted = false;

  String? _qrAccountId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _registerQrOnce());
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _registerQrOnce() async {
    if (_registrationAttempted) return;
    _registrationAttempted = true;
    final accountId = await ref
        .read(checkoutRepositoryProvider)
        .fetchQrAccountId();
    if (!mounted) return;
    setState(() => _qrAccountId = accountId);
    await ref
        .read(orderPaymentControllerProvider(widget.orderId).notifier)
        .ensureQrRegistered(
          qrAccountId: accountId,
          merchantName: 'EncueYPay Prototype',
        );
  }

  void _startPolling() {
    _pollTimer ??= Timer.periodic(
      const Duration(seconds: 5),
      (_) {
        // Only meaningful for a pending QR payment; skipped for COD and
        // once verified (and the timer is cancelled on verification).
        final payment =
            ref.read(orderPaymentControllerProvider(widget.orderId)).value;
        if (payment == null || payment.method != 'qr' || payment.isVerified) {
          return;
        }
        ref
            .read(orderPaymentControllerProvider(widget.orderId).notifier)
            .pollBakong();
      },
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
            paymentAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Column(
                children: [
                  Text('$error', textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  FilledButton.tonal(
                    onPressed: () => ref.invalidate(
                        orderPaymentControllerProvider(widget.orderId)),
                    child: const Text('Retry'),
                  ),
                ],
              ),
              data: (payment) {
                // Verified is the ONLY paid state — celebrate here.
                if (payment.isVerified) {
                  _pollTimer?.cancel();
                  final money = Money(payment.amountMinor);
                  return Column(
                    children: [
                      const Icon(Icons.check_circle_outline,
                          size: 72, color: AppColors.accentEmerald),
                      const SizedBox(height: 16),
                      Text('Thank you!',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium),
                      const SizedBox(height: 8),
                      Text(
                        'Your order has been placed and your payment is '
                        'confirmed.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      Container(
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
                      ),
                    ],
                  );
                }
                if (payment.method != 'qr') {
                  // COD: order placed, nothing to pay now — awaiting the
                  // store's confirmation, not a payment.
                  return Column(
                    children: [
                      const Icon(Icons.check_circle_outline,
                          size: 72, color: AppColors.accentEmerald),
                      const SizedBox(height: 16),
                      Text('Thank you!',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium),
                      const SizedBox(height: 8),
                      Text(
                        'Your order has been placed. You will pay in cash '
                        'when it arrives.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  );
                }
                // Pending QR. Registration is one-shot; the account id (or
                // its absence) decides between the QR and the unconfigured
                // notice. Polling starts once the payload exists.
                _startPolling();
                final payload = payment.qrPayload;
                final money = Money(payment.amountMinor);
                return Column(
                  children: [
                    // NOT a success state: the order exists, the payment
                    // does not yet.
                    const Icon(Icons.hourglass_top_rounded,
                        size: 56, color: AppColors.primaryRoyal),
                    const SizedBox(height: 12),
                    Text('Order placed — payment pending',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text(
                      'Your order has been placed, but it is not paid yet. '
                      'Scan the KHQR below with any Bakong-connected '
                      'banking app to complete the '
                      '${money.formatUsd()} payment.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (_qrAccountId != null && _qrAccountId!.isEmpty)
                      // Admin has not configured a Bakong ID — the QR cannot
                      // exist; say so instead of spinning forever.
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer,
                          borderRadius: AppRadii.br16,
                        ),
                        child: Text(
                          'QR payment is not configured for this store. '
                          'Contact the store or choose Cash on Delivery at '
                          'checkout.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onErrorContainer,
                          ),
                        ),
                      )
                    else if (payload == null)
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      )
                    else ...[
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
