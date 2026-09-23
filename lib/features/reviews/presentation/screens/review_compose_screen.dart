import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/failures.dart';
import '../controllers/review_compose_controller.dart';

/// Compose the (single, read-only after submission) review for a purchased
/// OrderItem (spec §29). Target passed via the router `extra` record —
/// no cross-feature import (ARCH-04).
class ReviewComposeScreen extends ConsumerStatefulWidget {
  const ReviewComposeScreen({
    super.key,
    required this.orderItemId,
    required this.productName,
  });

  final String orderItemId;
  final String productName;

  @override
  ConsumerState<ReviewComposeScreen> createState() =>
      _ReviewComposeScreenState();
}

class _ReviewComposeScreenState extends ConsumerState<ReviewComposeScreen> {
  int _rating = 5;
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    await ref.read(reviewComposeControllerProvider.notifier).submit(
          orderItemId: widget.orderItemId,
          rating: _rating,
          text: _textController.text.trim(),
        );
    final hasError = ref.read(reviewComposeControllerProvider).hasError;
    if (!hasError && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final submitting = ref.watch(
      reviewComposeControllerProvider.select((async) => async.isLoading),
    );

    ref.listen(reviewComposeControllerProvider, (previous, next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Write a review')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            widget.productName,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var star = 1; star <= 5; star++)
                IconButton(
                  iconSize: 36,
                  icon: Icon(
                    star <= _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () => setState(() => _rating = star),
                ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _textController,
            decoration: const InputDecoration(
              labelText: 'Your review',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: submitting ? null : _submit,
            child: submitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Submit review'),
          ),
          const SizedBox(height: 8),
          const Text(
            'Reviews are read-only once submitted.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
