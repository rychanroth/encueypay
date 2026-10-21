import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/money.dart';
import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/presentation/theme/app_typography.dart';
import '../../../../core/presentation/widgets/khqr_card.dart';
import '../../../../core/router/app_routes.dart';
import '../controllers/order_payment_controller.dart';

/// Order confirmation (Section 6b). State semantics are explicit — they are
/// NOT equivalent:
///
///   * Order placed  → the `create_order_from_cart` RPC committed the order
///     and its `pending` payment row. That is all the initial screen shows;
///     it is NOT a paid state.
///   * QR pending    → the PayWay KHQR renders (created server-side via the
///     payway-create Edge Function) while Supabase Realtime watches the
///     `payments` row; PayWay's webhook settles the transaction
///     server-side (admin simulation covers demos) — the UI never flips
///     states on its own.
///   * Verified      → the realtime stream (or a fresh snapshot) delivered
///     `transaction_verified` — the only state that claims payment success.
class OrderPlacedScreen extends ConsumerStatefulWidget {
  const OrderPlacedScreen({super.key, required this.orderId});

  final String orderId;

  @override
  ConsumerState<OrderPlacedScreen> createState() => _OrderPlacedScreenState();
}

class _OrderPlacedScreenState extends ConsumerState<OrderPlacedScreen> {
  /// QR creation is one-shot per screen instance: a `build()`-driven
  /// creation raced the realtime update (the client never saw its own
  /// `qr_payload` when Realtime was down) and re-fired on every rebuild —
  /// the server UPDATE re-triggered the stream and the loop fed itself
  /// (~2 s cadence). Creation is initiated once, from the lifecycle,
  /// never from build().
  bool _creationAttempted = false;

  /// Set when payway-create reports a failure (secrets missing, PayWay
  /// rejection, …) — surfaced instead of spinning forever.
  String? _creationError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _createQrOnce());
  }

  Future<void> _createQrOnce() async {
    if (_creationAttempted) return;
    _creationAttempted = true;
    try {
      await ref
          .read(orderPaymentControllerProvider(widget.orderId).notifier)
          .ensureQrRegistered();
    } on Failure catch (error) {
      if (mounted) setState(() => _creationError = error.message);
    }
  }

  void _retryCreation() {
    setState(() {
      _creationAttempted = false;
      _creationError = null;
    });
    _createQrOnce();
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
                // Pending QR. Creation is one-shot; a failure is surfaced
                // instead of spinning forever.
                final payload = payment.qrPayload;
                final money = Money(payment.amountMinor);
                final creationError = _creationError;
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
                      'Scan the KHQR below with any KHQR-supported '
                      'banking app to complete the '
                      '${money.formatUsd()} payment.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (creationError != null)
                      // QR creation failed (not configured, PayWay
                      // rejection, …) — say so instead of spinning forever.
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer,
                          borderRadius: AppRadii.br16,
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Could not start the QR payment.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onErrorContainer,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              creationError,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onErrorContainer,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            FilledButton.tonal(
                              onPressed: _retryCreation,
                              child: const Text('Retry'),
                            ),
                          ],
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
