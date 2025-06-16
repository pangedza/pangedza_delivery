import 'package:flutter/foundation.dart';
import 'dish.dart';
import 'dish_variant.dart';
import 'modifier.dart';

class CartItem {
  final Dish dish;
  final DishVariant variant;
  final List<Modifier> modifiers;
  int quantity;

  CartItem({
    required this.dish,
    required this.variant,
    this.modifiers = const [],
    this.quantity = 1,
  });

  factory CartItem.fromJson(dynamic json) {
    try {
      if (json is! Map<String, dynamic>) {
        throw ArgumentError('CartItem.fromJson expects a Map');
      }
      final dishRaw = json['dish'];
      final variantRaw = json['variant'];
      final modsRaw = json['modifiers'] as List? ?? [];
      final price = json['price'] as int? ??
          (variantRaw is Map ? variantRaw['price'] as int? : null) ??
          (dishRaw is Map ? dishRaw['price'] as int? : null) ??
          0;

      final dish = dishRaw is Map<String, dynamic>
          ? Dish.fromJson(dishRaw)
          : Dish(name: dishRaw?.toString() ?? '', weight: '', price: price, imageUrl: '', modifiers: const []);

      final variant = variantRaw is Map<String, dynamic>
          ? DishVariant.fromJson(variantRaw)
          : DishVariant(title: variantRaw?.toString() ?? '', price: price);

      final mods = modsRaw
          .map((e) => Modifier.fromJson(e as Map<String, dynamic>))
          .toList();

      return CartItem(
        dish: dish,
        variant: variant,
        modifiers: mods,
        quantity: json['quantity'] as int? ?? 1,
      );
    } catch (e) {
      debugPrint('CartItem.fromJson error: $e');
      int qty = 1;
      if (json is Map && json['quantity'] != null) {
        qty = int.tryParse(json['quantity'].toString()) ?? 1;
      }
      return CartItem(
        dish: Dish(name: '', weight: '', price: 0, imageUrl: '', modifiers: const []),
        variant: const DishVariant(title: '', price: 0),
        modifiers: const [],
        quantity: qty,
      );
    }
  }

  int get modifiersPrice => modifiers.fold(0, (sum, m) => sum + m.price);
  int get total => (variant.price + modifiersPrice) * quantity;

  Map<String, dynamic> toMap() => {
        'dish': dish.name,
        'variant': variant.title,
        'modifiers': modifiers.map((e) => e.toMap()).toList(),
        'price': variant.price + modifiersPrice,
        'quantity': quantity,
      };
}
