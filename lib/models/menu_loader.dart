import 'dart:convert';
import 'package:flutter/widgets.dart';

import 'category.dart';
import 'dish.dart';

Future<List<Category>> loadMenu(BuildContext context) async {
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
  return grouped.entries
      .map((e) => Category.fromEntry(e))
      .toList();
}
