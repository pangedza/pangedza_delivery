import 'package:flutter/material.dart';

import '../../models/order.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ActiveOrderScreen extends StatelessWidget {
  final Order order;
  final VoidCallback onCancelled;
  const ActiveOrderScreen({super.key, required this.order, required this.onCancelled});

  @override
  Widget build(BuildContext context) {
    final address = order.pickup
        ? 'Самовывоз'
        : [
            order.city,
            order.street,
            'д. ${order.house}',
            if (order.flat.isNotEmpty) 'кв. ${order.flat}'
          ].join(', ');
    final items = order.items
        .map((e) => '${e.dish.name} ${e.variant.title} x${e.quantity}')
        .join(', ');

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Заказ №${order.orderNumber}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(address),
        const SizedBox(height: 8),
        Text(items),
        if (order.comment.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text('Комментарий: ${order.comment}')
        ],
        const SizedBox(height: 8),
        Text('Статус: ${order.status}'),
        const SizedBox(height: 8),
        Text('Сумма: ${order.discountedTotal}\u20BD'),
        if (order.status == 'active') ...[
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final result = await Supabase.instance.client
                  .from('orders')
                  .update({'status': 'cancelled'})
                  .eq('id', order.id)
                  .execute();
              if (result.error == null) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Заказ отменён')),
                  );
                }
                onCancelled();
              }
            },
            child: const Text('Отменить заказ'),
          ),
        ],
      ],
    );
  }
}
