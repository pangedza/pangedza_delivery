import 'dish.dart';

class Category {
  final String name;
  final List<Dish> dishes;
  final int sortOrder;

  const Category({
    required this.name,
    required this.dishes,
    this.sortOrder = 0,
  });

  factory Category.fromEntry(MapEntry<String, List<Dish>> entry,
          [int sortOrder = 0]) =>
      Category(name: entry.key.trim(), dishes: entry.value, sortOrder: sortOrder);
}
