import 'package:flutter/material.dart';

/// File formats offered by every admin export action (orders, products and
/// the sales report). All three are produced in-repo — no new dependency
/// (DEPS-03): CSV and JSON are plain text, XLSX is written by
/// `xlsx_writer.dart`.
enum ExportFormat {
  csv(
    label: 'CSV',
    extension: 'csv',
    mimeType: 'text/csv',
    icon: Icons.table_rows_outlined,
    description: 'Plain table — opens in any app',
  ),
  xlsx(
    label: 'Excel (.xlsx)',
    extension: 'xlsx',
    mimeType:
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    icon: Icons.grid_on_outlined,
    description: 'Excel / Google Sheets workbook',
  ),
  json(
    label: 'JSON',
    extension: 'json',
    mimeType: 'application/json',
    icon: Icons.data_object_outlined,
    description: 'Structured data for integrations',
  );

  const ExportFormat({
    required this.label,
    required this.extension,
    required this.mimeType,
    required this.icon,
    required this.description,
  });

  final String label;
  final String extension;
  final String mimeType;
  final IconData icon;
  final String description;
}

/// `orders_20261117_1042` — the shared filename stem for exports
/// (local time, matching the timestamps inside the files).
String exportFileStamp(DateTime value) {
  final local = value.toLocal();
  String two(int part) => part.toString().padLeft(2, '0');
  return '${local.year.toString().padLeft(4, '0')}'
      '${two(local.month)}${two(local.day)}_'
      '${two(local.hour)}${two(local.minute)}';
}
