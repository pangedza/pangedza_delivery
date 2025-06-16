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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DishDetailScreen(dish: dish)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasMods = dish.modifiers.isNotEmpty;
    final firstVariant =
        hasMods ? dish.modifiers.first : DishVariant(title: dish.weight, price: dish.price);

    final cart = CartModel.instance;
    final StopListService stopService = stopListService;
    final bool stopped = stopService.isStopped(dish.name);
    final int? left = stopService.leftover(dish.name);
    final count = cart.items
        .where((i) => i.dish.name == dish.name)
        .fold<int>(0, (sum, i) => sum + i.quantity);

    void add() {
      cart.addItem(dish, firstVariant);
      stopService.consume(dish.name);
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 230),
      child: Stack(
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: dish.imageUrl.isNotEmpty
                      ? Image.network(
                          dish.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[200],
                            alignment: Alignment.center,
                            child:
                                const Icon(Icons.image, size: 48, color: Colors.grey),
                          ),
                        )
                      : Container(
                          color: Colors.grey[200],
                          alignment: Alignment.center,
                          child:
                              const Icon(Icons.image, size: 48, color: Colors.grey),
                        ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                dish.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (dish.weight.isNotEmpty)
                Text(
                  dish.weight,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${firstVariant.price} ₽',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (left != null && !stopped)
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(
                        'Осталось: $left',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  Stack(
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
                          child:
                              const Icon(Icons.add, color: Colors.white),
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
                ],
              ),
            ],
          ),
        ),
      ),
          if (stopped)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha((0.7 * 255).toInt()), // deprecated .withOpacity()
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
    );
  }
}
