import 'package:flutter_test/flutter_test.dart';
import 'package:pangedza_delivery/main.dart';

void main() {
  testWidgets('Start page shows main buttons', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Вход'), findsOneWidget);
    expect(find.text('Регистрация'), findsOneWidget);
    expect(find.text('Быстрый заказ'), findsOneWidget);
  });
}
