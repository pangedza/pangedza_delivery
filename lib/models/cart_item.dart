import 'dish.dart';
import 'dish_variant.dart';

class CartItem {
  final Dish dish;
  final DishVariant variant;
  int quantity;

  CartItem({
    required this.dish,
    required this.variant,
    this.quantity = 1,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        dish: Dish.fromJson(json['dish'] as Map<String, dynamic>),
        variant: DishVariant.fromJson(json['variant'] as Map<String, dynamic>),
        quantity: json['quantity'] as int? ?? 1,
      );

  int get total => variant.price * quantity;
}
