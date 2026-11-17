import 'package:flutter/material.dart';

import '../../../../core/presentation/theme/app_dimensions.dart';
import 'export_format.dart';

/// Asks which file format the admin wants. Returns `null` when dismissed.
Future<ExportFormat?> showExportFormatSheet(BuildContext context) {
  return showModalBottomSheet<ExportFormat>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      final theme = Theme.of(sheetContext);
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: Text('Export as', style: theme.textTheme.titleMedium),
            ),
            for (final format in ExportFormat.values)
              ListTile(
                leading: Icon(format.icon),
                title: Text(format.label),
                subtitle: Text(format.description),
                onTap: () => Navigator.of(sheetContext).pop(format),
              ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      );
    },
  );
}
