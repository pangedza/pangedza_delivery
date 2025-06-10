import 'package:flutter_test/flutter_test.dart';
import 'package:pangedza_delivery/models/category.dart';
import 'package:pangedza_delivery/models/dish.dart';
import 'package:pangedza_delivery/utils/search_filter.dart';

void main() {
  test('filterCategories returns only categories with matched dishes', () {
    final categories = [
      Category(name: 'A', dishes: const [
        Dish(name: 'Soup', weight: '', price: 100, modifiers: []),
        Dish(name: 'Salad', weight: '', price: 200, modifiers: []),
      ]),
      Category(name: 'B', dishes: const [
        Dish(name: 'Pie', weight: '', price: 150, modifiers: []),
      ]),
    ];

    final result = filterCategories(categories, 'sal');

    expect(result.length, 1);
    expect(result.first.name, 'A');
    expect(result.first.dishes.length, 1);
    expect(result.first.dishes.first.name, 'Salad');
  });
}
