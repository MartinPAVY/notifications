import 'package:flutter_test/flutter_test.dart';
import 'package:notify_me/main.dart';

void main() {
  testWidgets('Smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Note: This test might fail if it tries to initialize notifications in test env.
    await tester.pumpWidget(const NotifyMeApp());

    expect(find.byType(NotifyMeApp), findsOneWidget);
  });
}
