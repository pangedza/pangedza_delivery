import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'category.dart';
import 'dish.dart';
import 'modifier.dart';

Future<List<Category>> loadMenu(BuildContext context) async {
  final client = Supabase.instance.client;
  final List data = await client
      .from('dishes')
      .select(
          'id, name, weight, price, description, image_url, categories(name, sort_order), dish_modifiers(modifiers(name, price, group_name))');

    final Map<String, List<Dish>> grouped = {};
    final Map<String, int> orders = {};
    for (final item in data) {
      final catMap = item['categories'] as Map<String, dynamic>?;
      final cat = (catMap?['name'] as String?) ?? '';
      final order = (catMap?['sort_order'] as int?) ?? 0;
      orders.putIfAbsent(cat, () => order);
      final modsRaw = item['dish_modifiers'] as List? ?? [];
      final mods = modsRaw
          .map((e) => Modifier.fromJson(e['modifiers'] as Map<String, dynamic>))
          .toList();

      final dish = Dish(
        id: item['id']?.toString() ?? '',
        name: item['name'] as String,
        weight: item['weight']?.toString() ?? '',
        price: (item['price'] as num).toInt(),
        imageUrl: item['image_url'] as String? ?? '',
        description: item['description'] as String?,
        modifiers: mods,
      );
      grouped.putIfAbsent(cat, () => []).add(dish);
    }

  var categories = grouped.entries
      .map((e) => Category.fromEntry(e, orders[e.key] ?? 0))
      .toList();
  categories.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  return categories;
}
