import '../../../../core/domain/money.dart';
import '../../domain/entities/admin.dart';
import 'xlsx_writer.dart';

/// Serializes the Reports tab for the three export formats. Kept as pure
/// functions so column layout is testable without a widget.
abstract final class SalesReportExport {
  /// `sales_report_20261019_20261117` — the report's own date range, so the
  /// file is self-describing.
  static String fileNameStem(AdminSalesReport report) =>
      'sales_report_${_compact(report.from)}_${_compact(report.to)}';

  /// Multi-sheet workbook: KPIs + gateway split on the first sheet, one sheet
  /// per ranking section.
  static List<WorkbookSheet> workbook(AdminSalesReport report) => [
    WorkbookSheet(
      name: 'Summary',
      rows: [
        ['Metric', 'Value'],
        ['From', _day(report.from)],
        ['To', _day(report.to)],
        ['Orders', report.totalOrders],
        ['Completed orders', report.completedOrders],
        ['Cancelled orders', report.cancelledOrders],
        ['Realized orders', report.realizedOrders],
        [
          'Gross realized revenue (USD)',
          Money(report.totalSalesMinor).format(),
        ],
        [
          'Average order value (USD)',
          Money(report.averageOrderValueMinor).format(),
        ],
        ['Net settled balance (USD)', Money(report.netSettledMinor).format()],
        [
          'Inventory valuation (USD)',
          Money(report.inventoryValuationMinor).format(),
        ],
        ['Low-stock products (≤5)', report.lowStockProducts],
        ['Out-of-stock products', report.outOfStockProducts],
        const [],
        ['Payment gateway distribution'],
        ['Gateway', 'Orders', 'Amount (USD)'],
        [
          'Bakong KHQR',
          report.paymentSplit.qrCount,
          Money(report.paymentSplit.qrAmountMinor).format(),
        ],
        [
          'COD',
          report.paymentSplit.codCount,
          Money(report.paymentSplit.codAmountMinor).format(),
        ],
      ],
    ),
    WorkbookSheet(
      name: 'Best sellers',
      rows: [
        ['Rank', 'Product', 'Units sold'],
        for (final (index, item) in report.bestSellers.indexed)
          [index + 1, item.name, item.units],
      ],
    ),
    WorkbookSheet(
      name: 'Top categories',
      rows: [
        ['Rank', 'Category', 'Units sold'],
        for (final (index, item) in report.topCategories.indexed)
          [index + 1, item.name, item.units],
      ],
    ),
    WorkbookSheet(
      name: 'Brand revenue',
      rows: [
        ['Rank', 'Brand', 'Revenue (USD)'],
        for (final (index, item) in report.brandRevenue.indexed)
          [index + 1, item.name, Money(item.revenueMinor).format()],
      ],
    ),
    WorkbookSheet(
      name: 'Purchase frequency',
      rows: [
        ['Rank', 'Customer', 'Orders'],
        for (final (index, item) in report.purchaseFrequency.indexed)
          [index + 1, item.name, item.orders],
      ],
    ),
  ];

  /// CSV is one square-ish table, so sections are separated by a title row and
  /// a blank row.
  static List<List<Object?>> flatRows(AdminSalesReport report) => [
    ['Sales report'],
    ['Range', '${_day(report.from)} – ${_day(report.to)}'],
    const [],
    ['Summary'],
    ['Metric', 'Value'],
    ['Orders', report.totalOrders],
    ['Completed orders', report.completedOrders],
    ['Cancelled orders', report.cancelledOrders],
    ['Realized orders', report.realizedOrders],
    ['Gross realized revenue (USD)', Money(report.totalSalesMinor).format()],
    [
      'Average order value (USD)',
      Money(report.averageOrderValueMinor).format(),
    ],
    ['Net settled balance (USD)', Money(report.netSettledMinor).format()],
    [
      'Inventory valuation (USD)',
      Money(report.inventoryValuationMinor).format(),
    ],
    ['Low-stock products (≤5)', report.lowStockProducts],
    ['Out-of-stock products', report.outOfStockProducts],
    const [],
    ['Payment gateway distribution'],
    ['Gateway', 'Orders', 'Amount (USD)'],
    [
      'Bakong KHQR',
      report.paymentSplit.qrCount,
      Money(report.paymentSplit.qrAmountMinor).format(),
    ],
    [
      'COD',
      report.paymentSplit.codCount,
      Money(report.paymentSplit.codAmountMinor).format(),
    ],
    const [],
    ['Best sellers'],
    ['Rank', 'Product', 'Units sold'],
    for (final (index, item) in report.bestSellers.indexed)
      [index + 1, item.name, item.units],
    const [],
    ['Top categories'],
    ['Rank', 'Category', 'Units sold'],
    for (final (index, item) in report.topCategories.indexed)
      [index + 1, item.name, item.units],
    const [],
    ['Brand revenue'],
    ['Rank', 'Brand', 'Revenue (USD)'],
    for (final (index, item) in report.brandRevenue.indexed)
      [index + 1, item.name, Money(item.revenueMinor).format()],
    const [],
    ['Customer purchase frequency'],
    ['Rank', 'Customer', 'Orders'],
    for (final (index, item) in report.purchaseFrequency.indexed)
      [index + 1, item.name, item.orders],
  ];

  /// Structured JSON for integrations — money stays in exact minor units.
  static Map<String, Object?> json(AdminSalesReport report) => {
    'from': _day(report.from),
    'to': _day(report.to),
    'summary': {
      'totalOrders': report.totalOrders,
      'completedOrders': report.completedOrders,
      'cancelledOrders': report.cancelledOrders,
      'realizedOrders': report.realizedOrders,
      'totalSalesMinor': report.totalSalesMinor,
      'averageOrderValueMinor': report.averageOrderValueMinor,
      'netSettledMinor': report.netSettledMinor,
      'inventoryValuationMinor': report.inventoryValuationMinor,
      'lowStockProducts': report.lowStockProducts,
      'outOfStockProducts': report.outOfStockProducts,
    },
    'paymentSplit': {
      'qrCount': report.paymentSplit.qrCount,
      'qrAmountMinor': report.paymentSplit.qrAmountMinor,
      'codCount': report.paymentSplit.codCount,
      'codAmountMinor': report.paymentSplit.codAmountMinor,
    },
    'bestSellers': [
      for (final (index, item) in report.bestSellers.indexed)
        {'rank': index + 1, 'name': item.name, 'units': item.units},
    ],
    'topCategories': [
      for (final (index, item) in report.topCategories.indexed)
        {'rank': index + 1, 'name': item.name, 'units': item.units},
    ],
    'brandRevenue': [
      for (final (index, item) in report.brandRevenue.indexed)
        {
          'rank': index + 1,
          'name': item.name,
          'revenueMinor': item.revenueMinor,
        },
    ],
    'purchaseFrequency': [
      for (final (index, item) in report.purchaseFrequency.indexed)
        {'rank': index + 1, 'name': item.name, 'orders': item.orders},
    ],
  };
}

String _day(DateTime value) {
  final local = value.toLocal();
  String two(int part) => part.toString().padLeft(2, '0');
  return '${local.year.toString().padLeft(4, '0')}-'
      '${two(local.month)}-${two(local.day)}';
}

String _compact(DateTime value) => _day(value).replaceAll('-', '');
