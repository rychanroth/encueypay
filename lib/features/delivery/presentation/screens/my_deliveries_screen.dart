import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/money.dart';
import '../controllers/my_deliveries_controller.dart';

/// Driver tab 2 — My deliveries: the active run with its pickup route
/// (spec §16) plus completed history.
class MyDeliveriesScreen extends ConsumerWidget {
  const MyDeliveriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(myDeliveriesControllerProvider);
    final theme = Theme.of(context);

    ref.listen(myDeliveriesControllerProvider, (previous, next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('My deliveries')),
      body: stateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$error', textAlign: TextAlign.center),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: () => ref.invalidate(myDeliveriesControllerProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (state) {
          final active = state.activeDelivery;
          return RefreshIndicator(
            onRefresh: () async => ref.refresh(myDeliveriesControllerProvider.future),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (active != null) ...[
                  Text('Active delivery',
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${active.customerName} · ${active.dropoffLine1}, ${active.dropoffCity}',
                                  style: theme.textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(active.status.name,
                                  style: theme.textTheme.bodySmall),
                            ],
                          ),
                          const SizedBox(height: 12),
                          for (final stop in active.stops)
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(
                                stop.completed
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: stop.completed
                                    ? Colors.green
                                    : theme.colorScheme.outline,
                              ),
                              title: Text(
                                  '${stop.sequence}. ${stop.businessName}'),
                              trailing: stop.completed
                                  ? null
                                  : FilledButton.tonal(
                                      onPressed: () => ref
                                          .read(myDeliveriesControllerProvider
                                              .notifier)
                                          .completeStop(stop.id),
                                      child: const Text('Picked up'),
                                    ),
                            ),
                          if (active.canStart)
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                onPressed: () => ref
                                    .read(myDeliveriesControllerProvider
                                        .notifier)
                                    .start(active.id),
                                child: const Text('Start delivery'),
                              ),
                            ),
                          if (active.canComplete)
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                onPressed: () => ref
                                    .read(myDeliveriesControllerProvider
                                        .notifier)
                                    .markDelivered(active.id),
                                child: const Text('Mark delivered'),
                              ),
                            ),
                          if (active.canReject)
                            OutlinedButton(
                              onPressed: () => ref
                                  .read(myDeliveriesControllerProvider.notifier)
                                  .reject(active.id),
                              child: const Text('Release delivery'),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ] else
                  const Text('No active delivery.'),
                Text('History',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (state.history.isEmpty)
                  const Text('No completed deliveries yet.')
                else
                  for (final delivery in state.history)
                    ListTile(
                      dense: true,
                      leading: const Icon(Icons.check_circle_outline),
                      title: Text(
                          '${delivery.customerName} → ${delivery.dropoffCity}'),
                      subtitle: Text(delivery.createdAt
                          .toLocal()
                          .toString()
                          .substring(0, 16)),
                      trailing: Text(
                        Money(delivery.earningMinor).format(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}
