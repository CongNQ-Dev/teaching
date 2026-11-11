import 'package:flutter_test/flutter_test.dart';

import 'package:expense_tracker/main.dart';

void main() {
  testWidgets('switch between LIVE and SOLUTION', (tester) async {
    await tester.pumpWidget(const TeachingRoot());
    expect(find.text('LIVE ⇄'), findsOneWidget);

    await tester.tap(find.text('LIVE ⇄'));
    await tester.pumpAndSettle();

    expect(find.text('SOLUTION ⇄'), findsOneWidget);
    expect(find.text('Flutter ExpenseTracker'), findsOneWidget);
    expect(find.text('Flutter Course'), findsOneWidget);
  });
}
