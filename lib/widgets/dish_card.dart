import 'package:flutter/material.dart';
import '../models/dish.dart';
import '../models/dish_variant.dart';
import '../models/cart_model.dart';
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

    return Stack(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(minHeight: 220),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Image.network(
                      dish.imageUrl.isNotEmpty
                          ? dish.imageUrl
                          : 'https://via.placeholder.com/512x300.png?text=%D0%91%D0%BB%D1%8E%D0%B4%D0%BE',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[200],
                        alignment: Alignment.center,
                        child: const Icon(Icons.image, size: 48, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${dish.price} ₽',
                  style: const TextStyle(fontWeight: FontWeight.bold),
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
                  ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      InkWell(
                        onTap: stopped
                            ? null
                            : hasMods
                                ? () => _openDetail(context)
                                : add,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: stopped
                              ? Colors.grey
                              : Theme.of(context).primaryColor,
                          child: const Icon(Icons.add, color: Colors.white),
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
    );
  }
}
