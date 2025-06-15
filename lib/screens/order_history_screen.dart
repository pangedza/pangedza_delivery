import 'package:flutter/material.dart';

import '../services/order_service.dart';
import '../models/cart_model.dart';
import 'package:intl/intl.dart';
import '../widgets/empty_placeholder.dart';
import '../main.dart';
import '../widgets/app_drawer.dart';
import 'orders/active_order_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with SingleTickerProviderStateMixin {
  final OrderService service = orderService;
  final cart = CartModel.instance;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    service.addListener(_update);
  }

  @override
  void dispose() {
    service.removeListener(_update);
    _tabController.dispose();
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
    final active = service.activeOrders;
    final historyOrders = service.completedOrders;
    return Scaffold(
      drawer: const MyAppDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('Заказы'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Активный заказ'),
            Tab(text: 'История заказов'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          active.isEmpty
              ? const Center(child: Text('Нет активных заказов'))
              : ActiveOrderScreen(order: active.first),
          historyOrders.isEmpty
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
                  itemCount: historyOrders.length,
                  itemBuilder: (_, index) {
                    final order = historyOrders[index];
                    final dateStr =
                        DateFormat('dd/MM/yyyy HH:mm', 'ru').format(order.date);
                    final priceStr =
                        NumberFormat.decimalPattern('ru').format(order.total);
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
        ],
      ),
    );
  }
}
