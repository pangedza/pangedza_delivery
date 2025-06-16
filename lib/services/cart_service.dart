import '../models/cart_model.dart';
import '../models/dish.dart';
import '../models/dish_variant.dart';
import '../models/modifier.dart';

/// Service responsible for cart operations.
class CartService {
  CartService._();
  static final CartService instance = CartService._();

  final CartModel _cart = CartModel.instance;

  /// Adds [dish] to the cart with optional [modifiers].
  /// The final price is calculated as base price plus all selected modifiers.
  void addDish(Dish dish, {List<Modifier> modifiers = const []}) {
    final variant = DishVariant(title: dish.weight, price: dish.price);
    _cart.addItem(dish, variant, modifiers);
  }
}
