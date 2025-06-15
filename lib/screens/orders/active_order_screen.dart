import 'package:flutter/material.dart';

import '../../models/order.dart';

class ActiveOrderScreen extends StatelessWidget {
  final Order order;
  const ActiveOrderScreen({super.key, required this.order});

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
      ],
    );
  }
}
