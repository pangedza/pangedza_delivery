import 'package:flutter_test/flutter_test.dart';
import 'package:pangedza_delivery/main.dart';

void main() {
  testWidgets('App starts with login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Вход'), findsOneWidget);
    expect(find.text('Войти'), findsOneWidget);
  });
}
