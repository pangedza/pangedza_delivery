import 'package:flutter/material.dart';
import '../models/menu_data.dart';
import '../widgets/noodle_builder_bottom_sheet.dart';
import '../widgets/dish_card.dart';

/// Simple menu screen containing a single custom noodles category.
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _openBuilder(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const NoodleBuilderBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            title: const Text('Собери лапшу сам'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _openBuilder(context),
          ),
        ),
        const SizedBox(height: 16),
        for (final category in menuCategories) ...[
          Text(
            category.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          for (final dish in category.dishes) DishCard(dish: dish),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}
