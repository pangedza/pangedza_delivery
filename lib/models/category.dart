import 'dish.dart';

class Category {
  final String name;
  final List<Dish> dishes;

  const Category({required this.name, required this.dishes});

  factory Category.fromEntry(MapEntry<String, List<Dish>> entry) =>
      Category(name: entry.key.trim(), dishes: entry.value);
}
