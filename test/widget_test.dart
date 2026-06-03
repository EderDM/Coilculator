import 'package:flutter_test/flutter_test.dart';

import 'package:coilculator/main.dart';

void main() {
  testWidgets('renders coil calculator home screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Coil Length Calculator'), findsOneWidget);
    expect(find.text('Estimated Length'), findsOneWidget);
  });
}
