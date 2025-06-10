import 'package:flutter/material.dart';
import '../models/dish.dart';
import '../models/dish_variant.dart';
import '../models/cart_model.dart';
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

    final cart = CartModel.instance;
    final count = cart.items
        .where((i) => i.dish.name == dish.name)
        .fold<int>(0, (sum, i) => sum + i.quantity);

    void add() {
      cart.addItem(dish, firstVariant);
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 215),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: hasMods ? () => _openSheet(context) : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dish.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${firstVariant.title.isNotEmpty ? '${firstVariant.title} - ' : ''}${firstVariant.price} ₽',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
            Positioned(
              bottom: 8,
              right: 0,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  InkWell(
                    onTap: hasMods ? () => _openSheet(context) : add,
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.redAccent,
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                  if (count > 0)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.white,
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
