import 'dish_variant.dart';
import 'modifier.dart';

class Dish {
  final String name;
  final String weight;
  final int price;
  final String? description;
  final String imageUrl;
  final List<Modifier> modifiers;

  const Dish({
    required this.name,
    required this.weight,
    required this.price,
    required this.imageUrl,
    required this.modifiers,
    this.description,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    final mods = (json['modifiers'] as List?)
            ?.map((e) => Modifier.fromJson(e as Map<String, dynamic>))
            .toList() ?? [];
    return Dish(
      name: json['name'] as String,
      weight: json['weight']?.toString() ?? '',
      price: (json['price'] as num).toInt(),
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String? ?? '',
      modifiers: mods,
    );
  }
}
