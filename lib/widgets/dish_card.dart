import 'package:flutter/material.dart';
import '../models/dish.dart';
import 'dish_variant_sheet.dart';

class DishCard extends StatelessWidget {
  final Dish dish;
  const DishCard({super.key, required this.dish});

  void _openSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => DishVariantSheet(dish: dish),
    );
  }

  @override
  Widget build(BuildContext context) {
    final variant = dish.variants.first;
    return Card(
      child: ListTile(
        onTap: () => _openSheet(context),
        title: Text(dish.name),
        subtitle: Text('${variant.weight} - ${variant.price} ₽'),
        trailing: TextButton(
          onPressed: () {
            // ignore: avoid_print
            print('Добавлено: ${dish.name} - ${variant.weight} - ${variant.price} ₽');
          },
          child: const Text('Добавить'),
        ),
      ),
    );
  }
}
