import 'package:flutter/material.dart';

/// A searchable record option for [SearchablePickerField].
class SearchableOption {
  const SearchableOption({required this.id, required this.label});

  final String id;
  final String label;
}

/// Search-as-you-type record picker for foreign-key fields (Section 2d): a
/// plain dropdown stops scaling once the catalog grows past a handful of
/// entries. The field opens a bottom sheet with a filter box over the
/// already-fetched options (client-side filtering — adequate at catalog
/// scale); an optional "no selection" row supports nullable references.
class SearchablePickerField extends StatelessWidget {
  const SearchablePickerField({
    super.key,
    required this.label,
    required this.options,
    this.valueId,
    required this.onChanged,
    this.allowEmpty = false,
  });

  final String label;
  final List<SearchableOption> options;
  final String? valueId;
  final ValueChanged<String?> onChanged;

  /// When true the sheet offers a "no selection" row (optional FKs).
  final bool allowEmpty;

  String? get _selectedLabel {
    for (final option in options) {
      if (option.id == valueId) return option.label;
    }
    return null;
  }

  Future<void> _openSheet(BuildContext context) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) => _SearchSheet(
        title: label,
        options: options,
        allowEmpty: allowEmpty,
      ),
    );
    if (selected != null) {
      // Sentinel for the "no selection" row.
      onChanged(selected.isEmpty ? null : selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _openSheet(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: valueId != null
              ? IconButton(
                  tooltip: 'Clear',
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => onChanged(null),
                )
              : const Icon(Icons.search),
        ),
        child: Text(
          _selectedLabel ?? 'Search…',
          style: theme.textTheme.bodyLarge?.copyWith(
            color:
                _selectedLabel == null ? theme.colorScheme.onSurfaceVariant : null,
          ),
        ),
      ),
    );
  }
}

class _SearchSheet extends StatefulWidget {
  const _SearchSheet({
    required this.title,
    required this.options,
    required this.allowEmpty,
  });

  final String title;
  final List<SearchableOption> options;
  final bool allowEmpty;

  @override
  State<_SearchSheet> createState() => _SearchSheetState();
}

class _SearchSheetState extends State<_SearchSheet> {
  final _filterController = TextEditingController();
  String _filter = '';

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final normalized = _filter.trim().toLowerCase();
    final filtered = normalized.isEmpty
        ? widget.options
        : widget.options
            .where((option) =>
                option.label.toLowerCase().contains(normalized))
            .toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Select ${widget.title.toLowerCase()}',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          TextField(
            controller: _filterController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Search…',
              prefixIcon: Icon(Icons.search),
              isDense: true,
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => setState(() => _filter = value),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                if (widget.allowEmpty)
                  ListTile(
                    leading: const Icon(Icons.close),
                    title: const Text('No selection'),
                    onTap: () => Navigator.of(context).pop(''),
                  ),
                for (final option in filtered)
                  ListTile(
                    title: Text(option.label),
                    onTap: () => Navigator.of(context).pop(option.id),
                  ),
                if (filtered.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No matches.'),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
