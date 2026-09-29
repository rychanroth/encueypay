import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/money.dart';
import '../controllers/business_transactions_provider.dart';

/// Business tab — TransactionHistory (spec §58): realized profit per day,
/// one line per completed order, with a date picker.
class BusinessTransactionsScreen extends ConsumerStatefulWidget {
  const BusinessTransactionsScreen({super.key});

  @override
  ConsumerState<BusinessTransactionsScreen> createState() =>
      _BusinessTransactionsScreenState();
}

class _BusinessTransactionsScreenState
    extends ConsumerState<BusinessTransactionsScreen> {
  DateTime _day = DateTime.now();

  DateTime get _dateOnly => DateTime(_day.year, _day.month, _day.day);

  Future<void> _pickDay() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _day,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    setState(() => _day = picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entriesAsync = ref.watch(businessTransactionsProvider(_dateOnly));

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _dateOnly.toLocal().toString().substring(0, 10),
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  tooltip: 'Pick a day',
                  icon: const Icon(Icons.calendar_month_outlined),
                  onPressed: _pickDay,
                ),
              ],
            ),
          ),
          Expanded(
            child: entriesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('$error', textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    FilledButton.tonal(
                      onPressed: () => ref
                          .invalidate(businessTransactionsProvider(_dateOnly)),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (entries) {
                final total = entries
                    .fold<int>(0, (sum, entry) => sum + entry.amountMinor);
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Profit',
                              style: theme.textTheme.titleMedium),
                          Text(
                            Money(total).format(),
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: entries.isEmpty
                          ? const Center(child: Text('No transactions.'))
                          : ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: entries.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final entry = entries[index];
                                return Card(
                                  child: ListTile(
                                    title: Text(entry.label),
                                    subtitle: Text(entry.occurredAt
                                        .toLocal()
                                        .toString()
                                        .substring(0, 16)),
                                    trailing: Text(
                                      Money(entry.amountMinor).format(),
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
