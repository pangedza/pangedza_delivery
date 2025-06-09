import 'package:flutter/material.dart';
import '../models/dish.dart';
import '../models/dish_variant.dart';
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
    final hasMods = dish.modifiers.isNotEmpty;
    final firstVariant = hasMods
        ? dish.modifiers.first
        : DishVariant(title: dish.weight, price: dish.price);
    return Card(
      child: ListTile(
        onTap: hasMods ? () => _openSheet(context) : null,
        title: Text(dish.name),
        subtitle: Text(
            '${firstVariant.title.isNotEmpty ? '${firstVariant.title} - ' : ''}${firstVariant.price} ₽'),
        trailing: TextButton(
          onPressed: hasMods
              ? () => _openSheet(context)
              : () {
                  // ignore: avoid_print
                  print('Добавлено: ${dish.name} - ${firstVariant.title} - ${firstVariant.price} ₽');
                },
          child: const Text('Добавить'),
        ),
      ),
    );
  }
}
