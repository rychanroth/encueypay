import 'package:flutter/material.dart';

import '../../domain/entities/product_detail.dart';
import 'rating_stars.dart';

/// A customer review on the product detail screen (Section 7F): reviewer
/// avatar (profile icon fallback) + name, the five-star rating, the text,
/// and the date. Non-interactive — reviewer profile screens are deferred
/// (living spec Part B §7F).
class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key, required this.review});

  final ProductReviewInfo review;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: review.avatarUrl != null
                      ? NetworkImage(review.avatarUrl!)
                      : null,
                  child: review.avatarUrl == null
                      ? const Icon(Icons.person, size: 16)
                      : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    review.authorName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  _date(review.createdAt),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 6),
            RatingStars(rating: review.rating.toDouble(), starSize: 14),
            const SizedBox(height: 6),
            if (review.text.isNotEmpty)
              Text(review.text, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  static String _date(DateTime value) =>
      value.toLocal().toString().substring(0, 10);
}
