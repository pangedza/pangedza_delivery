import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/dish.dart';
import '../models/dish_variant.dart';
import '../models/cart_model.dart';
import '../models/cart_item.dart';
import '../services/stop_list_service.dart';
import '../di.dart';
import '../screens/dish_detail_screen.dart';

class DishCard extends StatelessWidget {
  final Dish dish;
  const DishCard({super.key, required this.dish});

  void _openDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => DishDetailScreen(dish: dish),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasMods = dish.modifiers.isNotEmpty;
    final firstVariant = DishVariant(title: dish.weight, price: dish.price);

    final cart = CartModel.instance;
    final StopListService stopService = stopListService;
    final bool stopped = stopService.isStopped(dish.name);
    final count = cart.items
        .where((i) => i.dish.name == dish.name)
        .fold<int>(0, (sum, i) => sum + i.quantity);

    void add() {
      cart.addItem(dish, firstVariant, const []);
      stopService.consume(dish.name);
    }

    final mediaQuery = MediaQuery.of(context);
    return SafeArea(
      bottom: true,
      child: Padding(
        padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: mediaQuery.size.height * 0.9,
            minHeight: math.max(240.0, mediaQuery.size.height * 0.4),
          ),
          child: Stack(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 100,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            dish.imageUrl.isNotEmpty
                                ? dish.imageUrl
                                : 'https://via.placeholder.com/512x300.png?text=%D0%91%D0%BB%D1%8E%D0%B4%D0%BE',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey[200],
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.image,
                                size: 48,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${dish.price} ₽',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        dish.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (dish.weight.isNotEmpty)
                        Text(
                          dish.weight,
                          style: TextStyle(color: Colors.grey[600]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: SizedBox(
                          width: double.infinity,
                          child: count == 0
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(36),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    backgroundColor: Theme.of(
                                      context,
                                    ).primaryColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: stopped
                                      ? null
                                      : hasMods
                                      ? () => _openDetail(context)
                                      : add,
                                  child: const Text(
                                    'Добавить',
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                        iconSize: 20,
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          CartItem? item;
                                          for (final i in cart.items) {
                                            if (i.dish.name == dish.name) {
                                              item = i;
                                              break;
                                            }
                                          }
                                          if (item != null)
                                            cart.decrement(item);
                                        },
                                      ),
                                      Text(
                                        '$count',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        iconSize: 20,
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                        onPressed: stopped
                                            ? null
                                            : hasMods
                                            ? () => _openDetail(context)
                                            : add,
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (stopped)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withAlpha((0.7 * 255).toInt()),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Transform.rotate(
                      angle: -0.5,
                      child: const Text(
                        'Закончилось',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
