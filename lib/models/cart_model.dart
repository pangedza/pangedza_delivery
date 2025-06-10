import 'package:flutter/foundation.dart';

import 'cart_item.dart';
import 'dish.dart';
import 'dish_variant.dart';

class CartModel extends ChangeNotifier {
  CartModel._();
  static final CartModel instance = CartModel._();

  final List<CartItem> items = [];

  int get total => items.fold(0, (sum, item) => sum + item.total);
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  int get totalPrice => total;

  void addItem(Dish dish, DishVariant variant) {
    try {
      final existing = items.firstWhere((i) =>
          i.dish.name == dish.name && i.variant.title == variant.title);
      existing.quantity++;
    } catch (_) {
      items.add(CartItem(dish: dish, variant: variant));
    }
    notifyListeners();
  }

  void increment(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  void decrement(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      items.remove(item);
    }
    notifyListeners();
  }

  void clear() {
    items.clear();
    notifyListeners();
  }
}
