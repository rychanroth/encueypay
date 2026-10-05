import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/money.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/order.dart';
import '../controllers/order_detail_controller.dart';
import '../widgets/order_status_timeline.dart';

/// Customer order detail (spec §12/§13/§20/§21): order parts, payment proof
/// upload, delivery progress view, cancel, return and review entry points.
/// Customer-only by design — the business counterpart is
/// ManagedOrderDetailScreen, driver flows live in the delivery feature.
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
          'Verified bank transfers are marked as refund-required.',
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
                    order.status.wireName,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(color: theme.colorScheme.primary),
                  ),
                ],
              ),
              Text(
                order.createdAt.toLocal().toString().substring(0, 16),
                style: theme.textTheme.bodySmall,
              ),
              // Tracking header (assignment §7, Section 7C — prototype
              // scope): mock tracking number, an ETA only while in transit,
              // and the store standing in as its own courier.
              const SizedBox(height: 4),
              Text(
                'Tracking #${order.id.substring(0, 8).toUpperCase()}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              if (order.status != OrderStatus.delivered &&
                  order.status != OrderStatus.cancelled &&
                  order.status != OrderStatus.returned)
                Text(
                  'Estimated delivery: '
                  '${order.createdAt.toLocal().add(const Duration(days: 3)).toString().substring(0, 10)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              Text(
                'Delivery managed by EncueYPay',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              const SizedBox(height: 16),

              // Visual status timeline (assignment §7): the order's single
              // lifecycle, read verbatim (Section 7A).
              OrderStatusTimeline(status: order.status),
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

              // Items (§19 historical snapshots).
              Text('Items',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              for (final item in order.items)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.variantName == null
                              ? '${item.productName} × ${item.quantity}'
                              : '${item.productName} '
                                  '(${item.variantName}) × ${item.quantity}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(Money(item.lineTotalMinor).format()),
                    ],
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
                  title: Text(payment.method == PaymentMethodKind.bankTransfer
                      ? 'Bank transfer'
                      : 'Cash on delivery'),
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
                FilledButton.tonalIcon(
                  onPressed: () => context.pushNamed(
                    AppRoutes.returnRequest,
                    pathParameters: {'id': order.id},
                  ),
                  icon: const Icon(Icons.assignment_return_outlined),
                  label: const Text('Request return'),
                ),
                const SizedBox(height: 8),
                Text(
                  'Review purchased items below.',
                  style: theme.textTheme.bodySmall,
                ),
              ],
              if (order.delivered)
                for (final item in order.items)
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      item.variantName == null
                          ? item.productName
                          : '${item.productName} (${item.variantName})',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: TextButton(
                      onPressed: () => context.pushNamed(
                        AppRoutes.reviewCompose,
                        extra: (item.id, item.productName),
                      ),
                      child: const Text('Review'),
                    ),
                  ),
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
