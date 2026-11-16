import 'package:flutter/material.dart';

import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../domain/entities/cart_view.dart';
import '../states/cart_filter_state.dart';

/// Cart search + filter chips + sort (Orders-screen pattern): keyword search
/// over product/variant names, the sale/availability chips and a sort sheet.
/// Everything is client-side over the loaded cart — no server round-trip.
class CartFilterBar extends StatefulWidget {
  const CartFilterBar({
    super.key,
    required this.state,
    required this.onQueryChanged,
    required this.onFilterChanged,
    required this.onSortChanged,
    required this.onClear,
  });

  final CartFilterState state;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<CartFilter> onFilterChanged;
  final ValueChanged<CartSort> onSortChanged;
  final VoidCallback onClear;

  @override
  State<CartFilterBar> createState() => _CartFilterBarState();
}

class _CartFilterBarState extends State<CartFilterBar> {
  late final TextEditingController _searchController = TextEditingController(
    text: widget.state.query,
  );

  @override
  void didUpdateWidget(covariant CartFilterBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Keep the field in sync when the filter is cleared from elsewhere (the
    // empty-results action or the clear button).
    if (_searchController.text != widget.state.query) {
      _searchController.text = widget.state.query;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _pickSort() async {
    final picked = await showModalBottomSheet<CartSort>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                0,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Sort cart',
                  style: Theme.of(sheetContext).textTheme.titleMedium,
                ),
              ),
            ),
            for (final sort in CartSort.values)
              ListTile(
                leading: Icon(
                  sort == widget.state.sort
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                ),
                title: Text(sort.label),
                onTap: () => Navigator.of(sheetContext).pop(sort),
              ),
          ],
        ),
      ),
    );
    if (picked != null) widget.onSortChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _searchController,
          onChanged: widget.onQueryChanged,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            isDense: true,
            hintText: 'Search your cart',
            prefixIcon: const Icon(Icons.search, size: 20),
            suffixIcon: _searchController.text.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Clear search',
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      widget.onQueryChanged('');
                    },
                  ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (final filter in CartFilter.values)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: ChoiceChip(
                    label: Text(filter.label),
                    selected: widget.state.filter == filter,
                    onSelected: (_) => widget.onFilterChanged(filter),
                  ),
                ),
              if (widget.state.hasActiveFilter)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: ActionChip(
                    avatar: const Icon(Icons.close, size: 16),
                    label: const Text('Clear'),
                    onPressed: widget.onClear,
                  ),
                ),
              ActionChip(
                avatar: Icon(
                  Icons.swap_vert,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                label: Text(widget.state.sort.label),
                onPressed: _pickSort,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
