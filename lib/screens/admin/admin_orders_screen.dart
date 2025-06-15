import 'package:flutter/material.dart';
import '../../models/order.dart';
import '../../services/order_service.dart';
import '../../di.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  final OrderService _service = orderService;

  @override
  void initState() {
    super.initState();
    _service.addListener(_update);
  }

  @override
  void dispose() {
    _service.removeListener(_update);
    super.dispose();
  }

  void _update() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final orders = _service.orders;
    if (orders.isEmpty) {
      return const Center(child: Text('Нет заказов'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (_, index) {
        final Order order = orders[index];
        final address = order.pickup
            ? 'Самовывоз'
            : [
                order.city,
                order.street,
                'д. ${order.house}',
                if (order.flat.isNotEmpty) 'кв. ${order.flat}',
              ].join(', ');
        final items = order.items
            .map((e) =>
                '${e.dish.name} ${e.variant.title} x${e.quantity}')
            .join(', ');
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text('${order.name} • ${order.phone}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(address),
                Text(items),
                if (order.comment.isNotEmpty)
                  Text('Комментарий: ${order.comment}'),
              ],
            ),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${order.total}\u20BD'),
                const SizedBox(height: 4),
                Text(order.status),
              ],
            ),
          ),
        );
      },
    );
  }
}
