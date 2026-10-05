import 'package:flutter/material.dart';

/// Visual star display of an aggregate or individual rating (assignment
/// §3/§7F). Half steps render via the half-star glyph.
class RatingStars extends StatelessWidget {
  const RatingStars({super.key, required this.rating, this.starSize = 18});

  final double rating;
  final double starSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 5; i++)
          Icon(
            rating >= i
                ? Icons.star
                : rating >= i - 0.5
                    ? Icons.star_half
                    : Icons.star_border,
            size: starSize,
            color: Colors.amber,
          ),
        const SizedBox(width: 4),
        Text(rating.toStringAsFixed(1)),
      ],
    );
  }
}
