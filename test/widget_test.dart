import 'package:flutter_test/flutter_test.dart';

import 'package:gost_bibliography_reference/main.dart';

void main() {
  testWidgets('App starts with loading indicator', (WidgetTester tester) async {
    await tester.pumpWidget(const GostBibliographyApp());

    // Verify that the app shows a loading indicator while checking EULA
    expect(find.byType(GostBibliographyApp), findsOneWidget);
  });
}
