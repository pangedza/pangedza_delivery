import 'dish_variant.dart';

class Dish {
  final String id;
  final String name;
  final String? description;
  final String imageUrl;
  final List<DishVariant> variants;

  const Dish({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.variants,
    this.description,
  });
}
