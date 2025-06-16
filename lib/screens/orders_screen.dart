import 'package:flutter/material.dart';
import '../services/orders_service.dart';
import '../models/profile_model.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final OrdersService _service = OrdersService();
  List<Map<String, dynamic>> _orders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final userId = ProfileModel.instance.id;
      final orders = await _service.getOrders(userId);
      setState(() {
        _orders = orders;
        _loading = false;
      });
    } catch (e) {
      print('Ошибка загрузки заказов: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Заказы')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                return ListTile(
                  title: Text(order['name'] ?? 'Без имени'),
                  subtitle: Text('Сумма: ${order['total'] ?? 0}'),
                );
              },
            ),
    );
  }
}
