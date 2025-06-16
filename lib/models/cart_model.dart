import 'package:flutter/foundation.dart';

import 'cart_item.dart';
import 'dish.dart';
import 'dish_variant.dart';
import 'modifier.dart';

class CartModel extends ChangeNotifier {
  CartModel._();
  static final CartModel instance = CartModel._();

  final List<CartItem> items = [];

  int get total => items.fold(0, (sum, item) => sum + item.total);
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  int get totalPrice => total;

  void addItem(Dish dish, DishVariant variant, [List<Modifier> mods = const []]) {
    try {
      final existing = items.firstWhere((i) =>
          i.dish.name == dish.name &&
          i.variant.title == variant.title &&
          _modsEqual(i.modifiers, mods));
      existing.quantity++;
    } catch (_) {
      items.add(CartItem(dish: dish, variant: variant, modifiers: mods));
    }
    notifyListeners();
  }

  bool _modsEqual(List<Modifier> a, List<Modifier> b) {
    if (a.length != b.length) return false;
    final aNames = a.map((e) => e.name).toSet();
    final bNames = b.map((e) => e.name).toSet();
    return setEquals(aNames, bNames);
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

  List<Map<String, dynamic>> toJson() => items
      .map((e) => {
            'dish': e.dish.name,
            'variant': e.variant.title,
            'modifiers': e.modifiers.map((m) => m.toMap()).toList(),
            'price': e.variant.price + e.modifiersPrice,
            'quantity': e.quantity,
          })
      .toList();
}
