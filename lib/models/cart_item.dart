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

  int get total => variant.price * quantity;
}
