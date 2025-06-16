import 'package:flutter/material.dart';

import '../services/orders_service.dart';
import '../models/profile_model.dart';
import '../models/cart_model.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import 'package:intl/intl.dart';
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
  final OrdersService service = OrdersService();
  final cart = CartModel.instance;
  List<Order> _orders = [];
  late TabController _tabController;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadOrders() async {
    final userId = context.read<ProfileModel>().id;
    if (userId == null) {
      setState(() => _loading = false);
      return;
    }

    List<Map<String, dynamic>> fetchedOrders = [];
    try {
      fetchedOrders = await OrdersService().getOrders(userId);
    } catch (e) {
      // print('🔴 Ошибка загрузки заказов: $e'); // [removed for production]
    }
    // print('Заказы загружаются для user_id: $userId'); // [removed for production]
    // print('Получено заказов: ${fetchedOrders.length}'); // [removed for production]
    if (!mounted) return;
    setState(() {
      _orders = fetchedOrders.map((json) => Order.fromJson(json)).toList();
      _loading = false;
    });
  }

  void _repeat(order) {
    for (final item in order.items) {
      for (var i = 0; i < item.quantity; i++) {
        cart.addItem(item.dish, item.variant);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = _orders.where((o) => o.status != 'Закрыт').toList();
    final historyOrders = _orders.where((o) => o.status == 'Закрыт').toList();
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
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
              : ActiveOrderScreen(order: active.first, onCancelled: _loadOrders),
          historyOrders.isEmpty
              ? const Center(child: Text('У вас пока нет заказов'))
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
                            Text('Заказ №${order.orderNumber}',
                                style: const TextStyle(fontWeight: FontWeight.bold)),
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
