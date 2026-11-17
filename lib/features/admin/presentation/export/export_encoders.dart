import 'dart:convert';
import 'dart:typed_data';

/// CSV bytes with a UTF-8 BOM so Excel opens the file with the right
/// encoding (the BOM is what the old inline exporters used).
Uint8List csvBytes(List<List<Object?>> rows) {
  final csv = rows.map((row) => row.map(_csvCell).join(',')).join('\r\n');
  return Uint8List.fromList(utf8.encode('\uFEFF$csv'));
}

/// Pretty-printed JSON bytes (UTF-8, no BOM).
Uint8List jsonBytes(Object? value) => Uint8List.fromList(
  utf8.encode(const JsonEncoder.withIndent('  ').convert(value)),
);

/// Header-first rows → one object per data row, keyed by the header names.
List<Map<String, Object?>> rowsToRecords(List<List<Object?>> rows) {
  if (rows.isEmpty) return const [];
  final header = [for (final cell in rows.first) cell?.toString() ?? ''];
  return [
    for (final row in rows.skip(1))
      {
        for (var i = 0; i < header.length; i++)
          header[i]: i < row.length ? row[i] : null,
      },
  ];
}

String _csvCell(Object? value) {
  final text = value?.toString() ?? '';
  final escaped = text.replaceAll('"', '""');
  return RegExp(r'[",\r\n]').hasMatch(escaped) ? '"$escaped"' : escaped;
}
