import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/main.dart';

void main() {
  testWidgets('RecapAiApp renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const RecapAiApp());
    expect(find.text('Catalogue Récap AI'), findsOneWidget);
  });
}
