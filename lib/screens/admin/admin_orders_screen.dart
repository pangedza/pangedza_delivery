import 'package:flutter/material.dart';
import '../../models/order.dart';
import '../../models/order_history_model.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = OrderHistoryModel.instance.orders;
    if (orders.isEmpty) {
      return const Center(child: Text('Нет заказов'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (_, index) {
        final Order order = orders[index];
        return Card(
          child: ListTile(
            title: Text(order.name),
            subtitle: Text(order.phone),
            trailing: Text('${order.total}\u20BD'),
          ),
        );
      },
    );
  }
}
