import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/failures.dart';
import '../../domain/entities/return_request.dart';
import '../controllers/business_returns_controller.dart';

/// Business-side returns processing (spec §28.1): approve or reject pending
/// return requests whose items belong to this business.
class BusinessReturnsScreen extends ConsumerWidget {
  const BusinessReturnsScreen({super.key});

  String _returnLine(ReturnItemInfo item) {
    final base = '${item.productName} × ${item.quantity}';
    return item.reason.isEmpty ? base : '$base — "${item.reason}"';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final returnsAsync = ref.watch(businessReturnsControllerProvider);
    final theme = Theme.of(context);

    ref.listen(businessReturnsControllerProvider, (previous, next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Returns')),
      body: returnsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (returns) {
          if (returns.isEmpty) {
            return const Center(child: Text('No return requests.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: returns.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final request = returns[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Order ${request.orderId.substring(0, 8)}',
                              style: theme.textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Chip(
                            label: Text(request.status.name),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                      for (final item in request.items)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(_returnLine(item)),
                        ),
                      if (request.status == ReturnStatus.pending) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: () => ref
                                  .read(businessReturnsControllerProvider
                                      .notifier)
                                  .process(
                                    returnId: request.id,
                                    approve: false,
                                  ),
                              child: const Text('Reject'),
                            ),
                            const SizedBox(width: 8),
                            FilledButton(
                              onPressed: () => ref
                                  .read(businessReturnsControllerProvider
                                      .notifier)
                                  .process(
                                    returnId: request.id,
                                    approve: true,
                                  ),
                              child: const Text('Approve'),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
