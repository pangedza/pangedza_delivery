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
  final Set<String> _ignoredOrderIds = <String>{};

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
        cart.addItem(item.dish, item.variant, item.modifiers);
      }
    }
  }

  Future<void> _confirmDelete(Order order) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить заказ?'),
        content: const Text('Заказ будет скрыт из истории на этом устройстве.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );

    if (result == true) {
      setState(() {
        _ignoredOrderIds.add(order.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered =
        _orders.where((o) => !_ignoredOrderIds.contains(o.id)).toList();
    final active = filtered.where((o) => o.status == 'active').toList();
    final historyOrders =
        filtered.where((o) => o.status != 'active').toList();
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
            Tab(text: 'Активные заказы'),
            Tab(text: 'История заказов'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          active.isEmpty
              ? const Center(child: Text('Нет активных заказов'))
              : ActiveOrderScreen(orders: active, onCancelled: _loadOrders),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Заказ №${order.orderNumber}',
                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  tooltip: 'Удалить',
                                  onPressed: () => _confirmDelete(order),
                                ),
                              ],
                            ),
                            Text(dateStr),
                            const SizedBox(height: 4),
                            for (final item in order.items)
                              Text(
                                '${item.dish.name} ${item.variant.title} ${item.modifiers.isNotEmpty ? '(' + item.modifiers.map((m) => m.name).join(', ') + ')' : ''} x${item.quantity}',
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
                            Text('📦 ${order.deliveryType == 'pickup' ? 'Самовывоз' : 'Доставка'}'),
                            Text('📌 Статус: ${order.statusDisplay}'),
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
