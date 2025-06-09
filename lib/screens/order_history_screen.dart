import 'package:flutter/material.dart';

import '../models/order_history_model.dart';
import '../models/cart_model.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final history = OrderHistoryModel.instance;
  final cart = CartModel.instance;

  @override
  void initState() {
    super.initState();
    history.addListener(_update);
  }

  @override
  void dispose() {
    history.removeListener(_update);
    super.dispose();
  }

  void _update() => setState(() {});

  void _repeat(order) {
    for (final item in order.items) {
      for (var i = 0; i < item.quantity; i++) {
        cart.addItem(item.dish, item.variant);
      }
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Товары добавлены в корзину')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('История заказов')),
      body: history.orders.isEmpty
          ? const Center(child: Text('Заказы отсутствуют'))
          : ListView.builder(
              itemCount: history.orders.length,
              itemBuilder: (_, index) {
                final order = history.orders[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(order.date.toString()),
                        const SizedBox(height: 4),
                        for (final item in order.items)
                          Text(
                              '${item.dish.name} ${item.variant.title} x${item.quantity}'),
                        const SizedBox(height: 4),
                        if (order.pickup)
                          const Text(
                              'Самовывоз: г. Новороссийск, ул. Коммунистическая, д. 51')
                        else
                          Text(
                              '${order.city}, ${order.district}, ${order.street}, д. ${order.house}'),
                        const SizedBox(height: 4),
                        Text('Итого: ${order.total} ₽'),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => _repeat(order),
                            child: const Text('Повторить заказ'),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
