import 'dish.dart';

class Category {
  final String id;
  final String name;
  final List<Dish> dishes;
  final int sortOrder;

  const Category({
    this.id = '',
    required this.name,
    required this.dishes,
    this.sortOrder = 0,
  });

  factory Category.fromEntry(MapEntry<String, List<Dish>> entry,
          [int sortOrder = 0]) =>
      Category(
        name: entry.key.trim(),
        dishes: entry.value,
        sortOrder: sortOrder,
      );

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id']?.toString() ?? '',
        name: json['name'] as String? ?? '',
        sortOrder: (json['sort_order'] as int?) ?? 0,
        dishes: const [],
      );
}
