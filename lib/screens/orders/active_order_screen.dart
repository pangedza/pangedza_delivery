import 'package:flutter/material.dart';
import '../../models/order.dart';
import '../../services/orders_service.dart';

class ActiveOrderScreen extends StatelessWidget {
  final List<Order> orders;
  final VoidCallback onCancelled;

  const ActiveOrderScreen({super.key, required this.orders, required this.onCancelled});

  Future<void> _cancelOrder(BuildContext context, Order order) async {
    final success = await OrdersService().cancelOrder(order);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(success ? 'Заказ отменён' : 'Не удалось отменить заказ'),
        ),
      );
    }
    if (success) onCancelled();
  }

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const Center(child: Text('Нет активных заказов'));
    }
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _ActiveOrderTile(
          order: order,
          onCancelled: () => _cancelOrder(context, order),
        );
      },
    );
  }
}

class _ActiveOrderTile extends StatefulWidget {
  final Order order;
  final VoidCallback onCancelled;

  const _ActiveOrderTile({required this.order, required this.onCancelled});

  @override
  State<_ActiveOrderTile> createState() => _ActiveOrderTileState();
}

class _ActiveOrderTileState extends State<_ActiveOrderTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final firstItem = order.items.isNotEmpty ? order.items.first : null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('🧾 Заказ №${order.orderNumber}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          if (_expanded)
            ...order.items.map(
              (item) => Text('🍽 ${item.dish.name} ×${item.quantity}'),
            )
          else if (firstItem != null)
            Text('🍽 ${firstItem.dish.name} ×${firstItem.quantity}'),
          Text('📦 ${order.deliveryType == 'pickup' ? 'Самовывоз' : 'Доставка'}'),
          Text('📌 Статус: ${order.statusDisplay}'),
          Text('💰 Сумма: ${order.discountedTotal}₽'),
          TextButton.icon(
            onPressed: () => setState(() => _expanded = !_expanded),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            label: Text(_expanded ? 'Скрыть позиции' : 'Показать позиции'),
          ),
          if (order.status == 'active')
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: widget.onCancelled,
                child: const Text('Отменить заказ'),
              ),
            ),
        ],
      ),
    );
  }
}
