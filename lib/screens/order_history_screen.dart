import 'package:flutter/material.dart';

import '../models/order_history_model.dart';
import '../models/cart_model.dart';
import 'package:intl/intl.dart';
import '../widgets/empty_placeholder.dart';
import '../main.dart';
import '../widgets/app_drawer.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyAppDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('История заказов'),
      ),
      body: history.orders.isEmpty
          ? EmptyPlaceholder(
              message: 'Вы еще не сделали у нас ни одного заказа',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MainScreen(),
                  ),
                );
              },
            )
          : ListView.builder(
              itemCount: history.orders.length,
              itemBuilder: (_, index) {
                final order = history.orders[index];
                final dateStr = DateFormat(
                  'dd.MM.yyyy HH:mm',
                ).format(order.date);
                final priceStr = NumberFormat.decimalPattern(
                  'ru',
                ).format(order.total);
                return Card(
                  key: ValueKey(order.date.toIso8601String()),
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(dateStr),
                        const SizedBox(height: 4),
                        for (final item in order.items)
                          Text(
                            '${item.dish.name} ${item.variant.title} x${item.quantity}',
                          ),
                        const SizedBox(height: 4),
                        if (order.pickup)
                          const Text(
                            'Самовывоз: г. Новороссийск, ул. Коммунистическая, д. 51',
                          )
                        else
                          Text(
                            '${order.city}, ${order.district}, ${order.street}, д. ${order.house}',
                          ),
                        const SizedBox(height: 4),
                        Text('Итого: $priceStr ₽'),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => _repeat(order),
                            child: const Text('Повторить заказ'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
