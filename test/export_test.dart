import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:encueypay/features/admin/domain/entities/admin.dart';
import 'package:encueypay/features/admin/presentation/export/export_encoders.dart';
import 'package:encueypay/features/admin/presentation/export/sales_report_export.dart';
import 'package:encueypay/features/admin/presentation/export/xlsx_writer.dart';

/// Guards the in-repo export layer: CSV quoting/BOM, JSON shape, the sales
/// report layout, and that the hand-rolled XLSX is a readable ZIP of the
/// expected OOXML parts (no dependency, DEPS-03).
void main() {
  group('CSV', () {
    test('writes a UTF-8 BOM and escapes commas/quotes', () {
      final bytes = csvBytes([
        ['Name', 'Note'],
        ['ACME, Inc', 'Said "hi"'],
      ]);
      final text = utf8.decode(bytes);

      expect(bytes.sublist(0, 3), [0xEF, 0xBB, 0xBF]);
      expect(text, 'Name,Note\r\n"ACME, Inc","Said ""hi"""');
    });
  });

  group('JSON', () {
    test('rows become header-keyed records with typed values', () {
      final records = rowsToRecords([
        ['Name', 'Stock'],
        ['Rice', 12],
      ]);

      expect(records, [
        {'Name': 'Rice', 'Stock': 12},
      ]);
    });
  });

  group('sales report export', () {
    final report = AdminSalesReport(
      from: DateTime(2026, 10, 19),
      to: DateTime(2026, 11, 17),
      totalOrders: 42,
      completedOrders: 30,
      cancelledOrders: 2,
      totalSalesMinor: 123456,
      averageOrderValueMinor: 2939,
      realizedOrders: 35,
      lowStockProducts: 4,
      outOfStockProducts: 1,
      bestSellers: const [AdminBestSeller(name: 'Rice', units: 12)],
      topCategories: const [AdminCategoryUnits(name: 'Food', units: 20)],
      purchaseFrequency: const [
        AdminCustomerFrequency(name: 'Dara', orders: 3),
      ],
      netSettledMinor: 100000,
      inventoryValuationMinor: 500000,
      paymentSplit: const AdminPaymentSplit(
        qrCount: 10,
        codCount: 5,
        qrAmountMinor: 90000,
        codAmountMinor: 20000,
      ),
      brandRevenue: const [
        AdminBrandRevenue(name: 'ACME', revenueMinor: 50000),
      ],
    );

    test('workbook has one sheet per report section', () {
      final sheets = SalesReportExport.workbook(report);

      expect(
        [for (final sheet in sheets) sheet.name],
        [
          'Summary',
          'Best sellers',
          'Top categories',
          'Brand revenue',
          'Purchase frequency',
        ],
      );
      expect(sheets.first.rows, contains(equals(['Orders', 42])));
      expect(sheets[1].rows, contains(equals([1, 'Rice', 12])));
    });

    test('JSON keeps money in exact minor units', () {
      final json = SalesReportExport.json(report);

      expect(json['from'], '2026-10-19');
      expect(json['to'], '2026-11-17');
      expect((json['summary'] as Map)['totalSalesMinor'], 123456);
      expect((json['paymentSplit'] as Map)['qrCount'], 10);
      expect((json['bestSellers'] as List).first, {
        'rank': 1,
        'name': 'Rice',
        'units': 12,
      });
    });

    test('CSV flattens sections and names the file from the range', () {
      final rows = SalesReportExport.flatRows(report);

      expect(rows.first, ['Sales report']);
      expect(rows, contains(equals(['Summary'])));
      expect(rows, contains(equals(['Best sellers'])));
      expect(
        SalesReportExport.fileNameStem(report),
        'sales_report_20261019_20261117',
      );
    });
  });

  group('XLSX writer', () {
    test('emits a stored ZIP with the required OOXML parts', () {
      final bytes = buildXlsxWorkbook([
        const WorkbookSheet(
          name: 'Orders',
          rows: [
            ['Order ID', 'Total'],
            ['A&B <1>', 12],
          ],
        ),
      ]);

      expect(bytes.sublist(0, 4), [0x50, 0x4B, 0x03, 0x04]);

      final entries = _readStoredZip(bytes);
      expect(
        entries.keys,
        containsAll([
          '[Content_Types].xml',
          '_rels/.rels',
          'xl/workbook.xml',
          'xl/_rels/workbook.xml.rels',
          'xl/styles.xml',
          'xl/worksheets/sheet1.xml',
        ]),
      );

      final workbook = utf8.decode(entries['xl/workbook.xml']!);
      expect(workbook, contains('name="Orders"'));

      final sheet = utf8.decode(entries['xl/worksheets/sheet1.xml']!);
      expect(sheet, contains('t="inlineStr"'));
      expect(sheet, contains('A&amp;B &lt;1&gt;'));
      expect(sheet, contains('<c r="B2"><v>12</v></c>'));
      expect(sheet, contains('s="1"')); // bold header row
    });

    test('sanitizes and de-duplicates sheet names', () {
      final bytes = buildXlsxWorkbook(const [
        WorkbookSheet(name: 'a/b:c', rows: []),
        WorkbookSheet(name: 'a/b:c', rows: []),
        WorkbookSheet(name: '', rows: []),
      ]);
      final entries = _readStoredZip(bytes);
      final workbook = utf8.decode(entries['xl/workbook.xml']!);

      expect(workbook, contains('name="a b c"'));
      expect(workbook, contains('name="a b c (2)"'));
      expect(workbook, contains('name="Sheet"'));
    });
  });
}

/// Minimal reader for the store-method ZIP produced by `buildXlsxWorkbook`.
Map<String, Uint8List> _readStoredZip(Uint8List bytes) {
  final data = ByteData.sublistView(bytes);
  final entries = <String, Uint8List>{};
  var offset = 0;

  while (offset + 4 <= bytes.length &&
      data.getUint32(offset, Endian.little) == 0x04034b50) {
    final size = data.getUint32(offset + 18, Endian.little);
    final nameLength = data.getUint16(offset + 26, Endian.little);
    final extraLength = data.getUint16(offset + 28, Endian.little);
    final nameStart = offset + 30;
    final dataStart = nameStart + nameLength + extraLength;
    final name = utf8.decode(bytes.sublist(nameStart, nameStart + nameLength));
    entries[name] = bytes.sublist(dataStart, dataStart + size);
    offset = dataStart + size;
  }

  expect(
    data.getUint32(bytes.length - 22, Endian.little),
    0x06054b50,
    reason: 'ZIP end-of-central-directory record',
  );
  return entries;
}
