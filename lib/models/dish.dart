import 'dish_variant.dart';

class Dish {
  final String name;
  final String weight;
  final int price;
  final String? description;
  final List<DishVariant> modifiers;

  const Dish({
    required this.name,
    required this.weight,
    required this.price,
    required this.modifiers,
    this.description,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    final mods = (json['modifiers'] as List?)
            ?.map((e) => DishVariant.fromJson(e as Map<String, dynamic>))
            .toList() ?? [];
    return Dish(
      name: json['name'] as String,
      weight: json['weight']?.toString() ?? '',
      price: json['price'] as int,
      description: json['description'] as String?,
      modifiers: mods,
    );
  }
}
