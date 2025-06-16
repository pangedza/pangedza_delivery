import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'category.dart';
import 'dish.dart';
import 'modifier.dart';

Future<List<Category>> loadMenu(BuildContext context) async {
  final client = Supabase.instance.client;
  try {
    final List data = await client
        .from('dishes')
        .select(
            'name, weight, price, description, image_url, categories(name), dish_modifiers(modifiers(name, price, group_name))');

    final Map<String, List<Dish>> grouped = {};
    for (final item in data) {
      final cat = (item['categories']?['name'] as String?) ?? '';
      final modsRaw = item['dish_modifiers'] as List? ?? [];
      final mods = modsRaw
          .map((e) => Modifier.fromJson(e['modifiers'] as Map<String, dynamic>))
          .toList();

      final dish = Dish(
        name: item['name'] as String,
        weight: item['weight']?.toString() ?? '',
        price: (item['price'] as num).toInt(),
        imageUrl: item['image_url'] as String? ?? '',
        description: item['description'] as String?,
        modifiers: mods,
      );
      grouped.putIfAbsent(cat, () => []).add(dish);
    }

    return grouped.entries.map(Category.fromEntry).toList();
  } catch (_) {
    final jsonStr = await DefaultAssetBundle.of(context)
        .loadString('assets/data/pangedza_menu_final_modifiers.json');
    final List<dynamic> data = jsonDecode(jsonStr) as List<dynamic>;
    final Map<String, List<Dish>> grouped = {};
    for (final item in data) {
      final map = item as Map<String, dynamic>;
      final cat = map['category'] as String? ?? '';
      final dish = Dish.fromJson(map);
      grouped.putIfAbsent(cat, () => []).add(dish);
    }
    return grouped.entries.map((e) => Category.fromEntry(e)).toList();
  }
}
