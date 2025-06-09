import 'package:flutter/material.dart';
import 'models/menu_item.dart';

class CartProvider extends ChangeNotifier {
  final Map<MenuItem, int> _items = {};

  Map<MenuItem, int> get items => Map.unmodifiable(_items);

  void add(MenuItem item) {
    _items.update(item, (count) => count + 1, ifAbsent: () => 1);
    notifyListeners();
  }

  void remove(MenuItem item) {
    if (!_items.containsKey(item)) return;
    final count = _items[item]! - 1;
    if (count <= 0) {
      _items.remove(item);
    } else {
      _items[item] = count;
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
