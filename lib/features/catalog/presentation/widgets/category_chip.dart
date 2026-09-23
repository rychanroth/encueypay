import 'package:flutter/material.dart';

import '../../domain/entities/category.dart';

/// Horizontal-strip category chip (PRES-06).
class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final Category category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(category.name),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}
