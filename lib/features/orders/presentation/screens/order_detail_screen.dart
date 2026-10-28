import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/money.dart';
import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/presentation/widgets/monogram_image.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/order.dart';
import '../controllers/order_detail_controller.dart';
import '../widgets/order_item_card.dart';
import '../widgets/order_tracking_card.dart';

/// Customer order detail (spec §12/§13/§20/§21): order parts, payment proof
/// upload, delivery progress view, cancel and review entry points.
/// Customer-only by design; admins use the admin orders screens.
class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  Future<void> _pickAndUploadProof(BuildContext context, WidgetRef ref) async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: const ['jpg', 'jpeg', 'png', 'webp', 'pdf'],
    );
    if (file == null || file.path == null) return;
    await ref.read(orderDetailControllerProvider(orderId).notifier).uploadProof(
          filePath: file.path!,
          fileName: file.name,
        );
  }

  Future<void> _confirmCancel(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel order?'),
        content: const Text(
          'The order will be cancelled and its reserved stock released.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep order'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Cancel order'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(orderDetailControllerProvider(orderId).notifier).cancelOrder();
    final hasError = ref.read(orderDetailControllerProvider(orderId)).hasError;
    if (!hasError && context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailControllerProvider(orderId));
    final theme = Theme.of(context);

    ref.listen(orderDetailControllerProvider(orderId), (previous, next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Order details')),
      body: orderAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$error', textAlign: TextAlign.center),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: () =>
                    ref.invalidate(orderDetailControllerProvider(orderId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (order) {
          final payment = order.payment;
          final needsProof = payment != null &&
              payment.method == PaymentMethodKind.bankTransfer &&
              (payment.status == PaymentStatusState.pending ||
                  payment.status ==
                      PaymentStatusState.awaitingPaymentVerification);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Order ${order.id.substring(0, 8)}',
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    order.status.label,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(color: theme.colorScheme.primary),
                  ),
                ],
              ),
              Text(
                order.createdAt.toLocal().toString().substring(0, 16),
                style: theme.textTheme.bodySmall,
              ),
              // §7C tracking presentation — mocked courier details, tracking
              // number, status-aware ETA and the step indicator, one card
              // (PRES-05 extracted widget).
              OrderTrackingCard(order: order),
              if (order.cancellationReason.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Reason: ${order.cancellationReason}',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.error),
                  ),
                ),
              const SizedBox(height: 16),

              // Items (§19 historical snapshots) — tappable OrderItemCards
              // with the product's current thumbnail; tapping opens the
              // product page (route-name navigation only, ARCH-04).
              Text('Items',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              for (final item in order.items)
                OrderItemCard(
                  item: item,
                  onTap: item.productId.isEmpty
                      ? null
                      : () => context.pushNamed(
                            AppRoutes.productDetail,
                            pathParameters: {'id': item.productId},
                          ),
                ),
              const SizedBox(height: 8),

              if (payment != null) ...[
                Text('Payment',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.payment_outlined),
                  title: Text(switch (payment.method) {
                    PaymentMethodKind.qr => 'KHQR payment',
                    PaymentMethodKind.bankTransfer => 'Bank transfer',
                    _ => 'Cash on delivery',
                  }),
                  subtitle: Text(
                    '${Money(payment.amountMinor).format()} · ${payment.status.name}',
                  ),
                  trailing: needsProof
                      ? FilledButton.tonal(
                          onPressed: () => _pickAndUploadProof(context, ref),
                          child: const Text('Upload proof'),
                        )
                      : null,
                ),
              ],

              Text('Shipping address',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              Text(
                '${order.shippingRecipientName}\n'
                '${[order.shippingLine1, order.shippingLine2, order.shippingCity].whereType<String>().where((part) => part.isNotEmpty).join(', ')}\n'
                '${order.shippingPhone}',
                style: theme.textTheme.bodyMedium,
              ),
              const Divider(height: 32),
              _SummaryRow('Subtotal', Money(order.subtotalMinor).format()),
              if (order.discountMinor > 0)
                _SummaryRow('Discount', '-${Money(order.discountMinor).format()}'),
              _SummaryRow('Delivery fee', Money(order.deliveryFeeMinor).format()),
              _SummaryRow('Total', Money(order.totalMinor).format(), bold: true),

              const SizedBox(height: 24),
              if (order.delivered) ...[
                Text(
                  'Review purchased items below.',
                  style: theme.textTheme.bodySmall,
                ),
                for (final item in order.items)
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    // Thumbnail + tap-through (same contract as the §19
                    // items section above).
                    leading: SizedBox(
                      width: 44,
                      height: 44,
                      child: ClipRRect(
                        borderRadius: AppRadii.br12,
                        child: MonogramImage(
                          imageUrl: item.imageUrl,
                          name: item.productName,
                        ),
                      ),
                    ),
                    onTap: item.productId.isEmpty
                        ? null
                        : () => context.pushNamed(
                              AppRoutes.productDetail,
                              pathParameters: {'id': item.productId},
                            ),
                    title: Text(
                      item.variantName == null
                          ? item.productName
                          : '${item.productName} (${item.variantName})',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: item.reviewed
                        ? const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle_outline,
                                  size: 16, color: AppColors.accentEmerald),
                              SizedBox(width: 4),
                              Text('Reviewed'),
                            ],
                          )
                        : TextButton(
                            onPressed: () => context.pushNamed(
                              AppRoutes.reviewCompose,
                              extra: (
                                item.id,
                                item.productId,
                                item.productName
                              ),
                            ),
                            child: const Text('Review'),
                          ),
                  ),
              ],
              if (order.cancellable) ...[
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => _confirmCancel(context, ref),
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text('Cancel order'),
                ),
              ],
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
