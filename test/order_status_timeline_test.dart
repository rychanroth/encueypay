import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:encueypay/features/orders/domain/entities/order.dart';
import 'package:encueypay/features/orders/presentation/widgets/order_status_timeline.dart';

OrderStatusEvent _event(OrderStatus status, int hour, int minute) {
  return OrderStatusEvent(
    status: status,
    changedAt: DateTime(2026, 11, 19, hour, minute),
  );
}

void main() {
  testWidgets('exact timeline keeps one row and labels only three stages', (
    tester,
  ) async {
    final history = [
      _event(OrderStatus.pending, 9, 0),
      _event(OrderStatus.confirmed, 9, 5),
      _event(OrderStatus.processing, 9, 10),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 320,
              child: OrderStatusTimeline(
                status: OrderStatus.processing,
                history: history,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    // Previous, current and final stage keep their labels.
    expect(find.text('Confirmed'), findsOneWidget);
    expect(find.text('Processing'), findsOneWidget);
    expect(find.text('Delivered'), findsOneWidget);
    // Other stages are dots only, saving the row's width.
    expect(find.text('Pending'), findsNothing);
    expect(find.text('Packed'), findsNothing);
    expect(find.text('Out for Delivery'), findsNothing);

    // Reached stages carry the server logout time; future ones do not.
    expect(find.text('19 Nov'), findsNWidgets(3));
    expect(find.text('09:00'), findsOneWidget);
    expect(find.text('09:05'), findsOneWidget);
    expect(find.text('09:10'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'collapsed track keeps every stage as a dot, no labels or times',
    (tester) async {
      final history = [
        _event(OrderStatus.pending, 9, 0),
        _event(OrderStatus.confirmed, 9, 5),
        _event(OrderStatus.processing, 9, 10),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 320,
                child: OrderStatusTimeline(
                  status: OrderStatus.processing,
                  history: history,
                  showDetails: false,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // Dots only: no stage names, no log times, still one row.
      expect(find.text('Confirmed'), findsNothing);
      expect(find.text('Processing'), findsNothing);
      expect(find.text('Delivered'), findsNothing);
      expect(find.text('09:00'), findsNothing);
      expect(find.text('19 Nov'), findsNothing);
      // Two earlier stages carry the completed check; the current one pulses.
      expect(find.byIcon(Icons.check), findsNWidgets(2));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('cancelled order shows the notice with its log time', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OrderStatusTimeline(
            status: OrderStatus.cancelled,
            history: [_event(OrderStatus.cancelled, 10, 30)],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(
      find.text('This order was cancelled at 19 Nov 10:30.'),
      findsOneWidget,
    );
  });
}
