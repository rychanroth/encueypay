import 'dart:convert';
import 'dart:typed_data';

/// One worksheet in an exported workbook. [rows] is header-first: the first
/// row is styled bold, every row is written as-is.
class WorkbookSheet {
  const WorkbookSheet({required this.name, required this.rows});

  final String name;
  final List<List<Object?>> rows;
}

/// Minimal, dependency-free `.xlsx` writer (DEPS-03).
///
/// An XLSX file is a ZIP archive of XML parts. The ZIP is written with the
/// *store* method (no compression) so no package is needed: Excel and Google
/// Sheets accept uncompressed entries. Strings are inline (`t="inlineStr"`),
/// numbers/booleans are typed cells, and the header row gets a bold fill.
Uint8List buildXlsxWorkbook(List<WorkbookSheet> sheets) {
  if (sheets.isEmpty) {
    throw ArgumentError.value(sheets, 'sheets', 'At least one sheet required');
  }

  final usedNames = <String>{};
  final names = [for (final sheet in sheets) _sheetName(sheet.name, usedNames)];

  final files = <String, List<int>>{
    '[Content_Types].xml': utf8.encode(_contentTypes(names)),
    '_rels/.rels': utf8.encode(_rootRels()),
    'xl/workbook.xml': utf8.encode(_workbookXml(names)),
    'xl/_rels/workbook.xml.rels': utf8.encode(_workbookRels(names.length)),
    'xl/styles.xml': utf8.encode(_stylesXml),
  };
  for (var i = 0; i < sheets.length; i++) {
    files['xl/worksheets/sheet${i + 1}.xml'] = utf8.encode(
      _sheetXml(sheets[i].rows),
    );
  }

  return _zip(files);
}

String _contentTypes(List<String> names) {
  final buffer = StringBuffer()
    ..write('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>')
    ..write(
      '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">',
    )
    ..write(
      '<Default Extension="rels" '
      'ContentType="application/vnd.openxmlformats-package.relationships+xml"/>',
    )
    ..write('<Default Extension="xml" ContentType="application/xml"/>')
    ..write(
      '<Override PartName="/xl/workbook.xml" '
      'ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>',
    )
    ..write(
      '<Override PartName="/xl/styles.xml" '
      'ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>',
    );
  for (var i = 0; i < names.length; i++) {
    buffer.write(
      '<Override PartName="/xl/worksheets/sheet${i + 1}.xml" '
      'ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>',
    );
  }
  buffer.write('</Types>');
  return buffer.toString();
}

String _rootRels() =>
    '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
    '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
    '<Relationship Id="rId1" '
    'Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" '
    'Target="xl/workbook.xml"/>'
    '</Relationships>';

String _workbookXml(List<String> names) {
  final buffer = StringBuffer()
    ..write('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>')
    ..write(
      '<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" '
      'xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">'
      '<sheets>',
    );
  for (var i = 0; i < names.length; i++) {
    buffer.write(
      '<sheet name="${_xmlEscape(names[i])}" sheetId="${i + 1}" '
      'r:id="rId${i + 1}"/>',
    );
  }
  buffer.write('</sheets></workbook>');
  return buffer.toString();
}

String _workbookRels(int sheetCount) {
  final buffer = StringBuffer()
    ..write('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>')
    ..write(
      '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">',
    );
  for (var i = 0; i < sheetCount; i++) {
    buffer.write(
      '<Relationship Id="rId${i + 1}" '
      'Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" '
      'Target="worksheets/sheet${i + 1}.xml"/>',
    );
  }
  buffer.write(
    '<Relationship Id="rId${sheetCount + 1}" '
    'Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" '
    'Target="styles.xml"/>',
  );
  buffer.write('</Relationships>');
  return buffer.toString();
}

const String _stylesXml =
    '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
    '<styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">'
    '<fonts count="2">'
    '<font><sz val="11"/><color rgb="FF1F2937"/><name val="Calibri"/><family val="2"/></font>'
    '<font><b/><sz val="11"/><color rgb="FF1F2937"/><name val="Calibri"/><family val="2"/></font>'
    '</fonts>'
    '<fills count="3">'
    '<fill><patternFill patternType="none"/></fill>'
    '<fill><patternFill patternType="gray125"/></fill>'
    '<fill><patternFill patternType="solid"><fgColor rgb="FFEFF3F8"/><bgColor indexed="64"/></patternFill></fill>'
    '</fills>'
    '<borders count="1"><border><left/><right/><top/><bottom/><diagonal/></border></borders>'
    '<cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs>'
    '<cellXfs count="2">'
    '<xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"/>'
    '<xf numFmtId="0" fontId="1" fillId="2" borderId="0" xfId="0" applyFont="1" applyFill="1"/>'
    '</cellXfs>'
    '<cellStyles count="1"><cellStyle name="Normal" xfId="0" builtinId="0"/></cellStyles>'
    '</styleSheet>';

String _sheetXml(List<List<Object?>> rows) {
  final widths = _columnWidths(rows);
  final buffer = StringBuffer()
    ..write('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>')
    ..write(
      '<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">',
    );

  if (widths.isNotEmpty) {
    buffer.write('<cols>');
    for (var i = 0; i < widths.length; i++) {
      buffer.write(
        '<col min="${i + 1}" max="${i + 1}" width="${widths[i]}" customWidth="1"/>',
      );
    }
    buffer.write('</cols>');
  }

  buffer.write('<sheetData>');
  for (var r = 0; r < rows.length; r++) {
    final row = rows[r];
    final rowNumber = r + 1;
    buffer.write('<row r="$rowNumber">');
    for (var c = 0; c < row.length; c++) {
      final value = row[c];
      if (value == null) continue;
      final ref = '${_columnName(c)}$rowNumber';
      final style = r == 0 ? ' s="1"' : '';
      if (value is num && value.isFinite) {
        buffer.write('<c r="$ref"$style><v>$value</v></c>');
      } else if (value is bool) {
        buffer.write('<c r="$ref" t="b"$style><v>${value ? 1 : 0}</v></c>');
      } else {
        final text = _xmlEscape(value.toString());
        buffer.write(
          '<c r="$ref" t="inlineStr"$style><is>'
          '<t xml:space="preserve">$text</t></is></c>',
        );
      }
    }
    buffer.write('</row>');
  }
  buffer.write('</sheetData></worksheet>');
  return buffer.toString();
}

List<int> _columnWidths(List<List<Object?>> rows) {
  var columns = 0;
  for (final row in rows) {
    if (row.length > columns) columns = row.length;
  }
  if (columns == 0) return const [];

  final widths = List<int>.filled(columns, 8);
  for (final row in rows) {
    for (var c = 0; c < row.length; c++) {
      final text = row[c]?.toString() ?? '';
      if (text.length + 2 > widths[c]) widths[c] = text.length + 2;
    }
  }
  return [for (final width in widths) width.clamp(8, 60)];
}

String _columnName(int index) {
  var name = '';
  var value = index + 1;
  while (value > 0) {
    final remainder = (value - 1) % 26;
    name = String.fromCharCode(65 + remainder) + name;
    value = (value - 1) ~/ 26;
  }
  return name;
}

String _sheetName(String raw, Set<String> used) {
  final cleaned = raw.replaceAll(RegExp(r'[\[\]:*?/\\]'), ' ').trim();
  final base = cleaned.isEmpty ? 'Sheet' : cleaned;
  final shortened = base.length > 31 ? base.substring(0, 31) : base;

  var candidate = shortened;
  var index = 2;
  while (used.contains(candidate.toLowerCase())) {
    final suffix = ' ($index)';
    candidate = shortened.length + suffix.length > 31
        ? '${shortened.substring(0, 31 - suffix.length)}$suffix'
        : '$shortened$suffix';
    index++;
  }
  used.add(candidate.toLowerCase());
  return candidate;
}

String _xmlEscape(String value) => value
    .replaceAll(RegExp(r'[\u0000-\u0008\u000B\u000C\u000E-\u001F]'), '')
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');

// ---------------------------------------------------------------- ZIP (store)

final List<int> _crcTable = List<int>.generate(256, (n) {
  var c = n;
  for (var k = 0; k < 8; k++) {
    c = (c & 1) != 0 ? 0xEDB88320 ^ (c >> 1) : c >> 1;
  }
  return c;
});

int _crc32(List<int> bytes) {
  var crc = 0xFFFFFFFF;
  for (final byte in bytes) {
    crc = _crcTable[(crc ^ byte) & 0xFF] ^ (crc >> 8);
  }
  return (crc ^ 0xFFFFFFFF) & 0xFFFFFFFF;
}

/// Writes a ZIP archive using the store method (no compression), which every
/// spreadsheet app reads. Entries are emitted in map order.
Uint8List _zip(Map<String, List<int>> files) {
  final output = BytesBuilder(copy: false);
  final central = BytesBuilder(copy: false);
  final now = DateTime.now();
  final dosTime = (now.hour << 11) | (now.minute << 5) | (now.second ~/ 2);
  final dosDate = ((now.year - 1980) << 9) | (now.month << 5) | now.day;
  var offset = 0;

  for (final entry in files.entries) {
    final name = utf8.encode(entry.key);
    final data = entry.value;
    final crc = _crc32(data);

    final local = ByteData(30)
      ..setUint32(0, 0x04034b50, Endian.little)
      ..setUint16(4, 20, Endian.little)
      ..setUint16(6, 0x0800, Endian.little) // UTF-8 names.
      ..setUint16(8, 0, Endian.little) // store
      ..setUint16(10, dosTime, Endian.little)
      ..setUint16(12, dosDate, Endian.little)
      ..setUint32(14, crc, Endian.little)
      ..setUint32(18, data.length, Endian.little)
      ..setUint32(22, data.length, Endian.little)
      ..setUint16(26, name.length, Endian.little)
      ..setUint16(28, 0, Endian.little);

    output
      ..add(local.buffer.asUint8List())
      ..add(name)
      ..add(data);

    final header = ByteData(46)
      ..setUint32(0, 0x02014b50, Endian.little)
      ..setUint16(4, 20, Endian.little)
      ..setUint16(6, 20, Endian.little)
      ..setUint16(8, 0x0800, Endian.little)
      ..setUint16(10, 0, Endian.little)
      ..setUint16(12, dosTime, Endian.little)
      ..setUint16(14, dosDate, Endian.little)
      ..setUint32(16, crc, Endian.little)
      ..setUint32(20, data.length, Endian.little)
      ..setUint32(24, data.length, Endian.little)
      ..setUint16(28, name.length, Endian.little)
      ..setUint16(30, 0, Endian.little) // extra
      ..setUint16(32, 0, Endian.little) // comment
      ..setUint16(34, 0, Endian.little) // disk
      ..setUint16(36, 0, Endian.little) // internal attrs
      ..setUint32(38, 0, Endian.little) // external attrs
      ..setUint32(42, offset, Endian.little);

    central
      ..add(header.buffer.asUint8List())
      ..add(name);

    offset += 30 + name.length + data.length;
  }

  final centralBytes = central.takeBytes();
  output.add(centralBytes);

  final end = ByteData(22)
    ..setUint32(0, 0x06054b50, Endian.little)
    ..setUint16(4, 0, Endian.little)
    ..setUint16(6, 0, Endian.little)
    ..setUint16(8, files.length, Endian.little)
    ..setUint16(10, files.length, Endian.little)
    ..setUint32(12, centralBytes.length, Endian.little)
    ..setUint32(16, offset, Endian.little)
    ..setUint16(20, 0, Endian.little);

  output.add(end.buffer.asUint8List());
  return output.takeBytes();
}
