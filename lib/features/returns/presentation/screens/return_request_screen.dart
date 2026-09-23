import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/failures.dart';
import '../controllers/return_request_controller.dart';
import '../../domain/entities/return_request.dart';

/// Submit a return for a delivered order (spec §28): quantities capped at
/// purchased, per-item reason, business decides the outcome.
class ReturnRequestScreen extends ConsumerStatefulWidget {
  const ReturnRequestScreen({super.key, required this.orderId});

  final String orderId;

  @override
  ConsumerState<ReturnRequestScreen> createState() =>
      _ReturnRequestScreenState();
}

class _ReturnRequestScreenState extends ConsumerState<ReturnRequestScreen> {
  final _selected = <String, int>{};
  final _reasonControllers = <String, TextEditingController>{};

  @override
  void dispose() {
    for (final controller in _reasonControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submit(List<ReturnableItem> items) async {
    final drafts = <ReturnItemDraft>[];
    for (final item in items) {
      final quantity = _selected[item.orderItemId] ?? 0;
      if (quantity == 0) continue;
      drafts.add(ReturnItemDraft(
        orderItemId: item.orderItemId,
        quantity: quantity,
        reason: _reasonControllers[item.orderItemId]?.text.trim() ?? '',
      ));
    }
    if (drafts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one item')),
      );
      return;
    }
    await ref.read(returnRequestControllerProvider(widget.orderId).notifier).submit(drafts);
    final hasError =
        ref.read(returnRequestControllerProvider(widget.orderId)).hasError;
    if (!hasError && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(returnRequestControllerProvider(widget.orderId));

    ref.listen(returnRequestControllerProvider(widget.orderId), (previous, next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Request return')),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (items) {
          final submitting = ref.watch(
            returnRequestControllerProvider(widget.orderId)
                .select((async) => async.isLoading),
          );
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (final item in items)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.variantName == null
                              ? item.productName
                              : '${item.productName} (${item.variantName})',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text('Purchased: ${item.purchasedQuantity}'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text('Return qty'),
                            const Spacer(),
                            IconButton(
                              onPressed: () => setState(() {
                                final current = _selected[item.orderItemId] ?? 0;
                                if (current > 0) {
                                  _selected[item.orderItemId] = current - 1;
                                }
                              }),
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                            Text('${_selected[item.orderItemId] ?? 0}'),
                            IconButton(
                              onPressed: () => setState(() {
                                final current = _selected[item.orderItemId] ?? 0;
                                if (current < item.purchasedQuantity) {
                                  _selected[item.orderItemId] = current + 1;
                                }
                              }),
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                          ],
                        ),
                        TextField(
                          controller: _reasonControllers.putIfAbsent(
                            item.orderItemId,
                            () => TextEditingController(),
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Reason',
                            isDense: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: submitting ? null : () => _submit(items),
                child: const Text('Submit return request'),
              ),
            ],
          );
        },
      ),
    );
  }
}
