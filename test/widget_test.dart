import 'package:flutter_test/flutter_test.dart';
import 'package:pangedza_delivery/main.dart';

void main() {
  testWidgets('App starts with welcome screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Регистрация'), findsOneWidget);
    expect(find.text('Вход'), findsOneWidget);
  });
}
