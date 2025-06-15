import 'package:flutter/material.dart';
import '../../models/order.dart';
import '../../services/order_service.dart';
import '../../di.dart';
import '../../services/promo_service.dart';
import '../../models/promo.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  final OrderService _service = orderService;
  final PromoService _promoService = promoService;

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
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('${order.name} • ${order.phone}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(address),
                      Text(items),
                      if (order.comment.isNotEmpty)
                        Text('Комментарий: ${order.comment}'),
                      if (order.promo != null)
                        Text('Промокод: ${order.promo!.code}'),
                      if (order.discount > 0)
                        Text('Скидка: ${order.discount}%'),
                    ],
                  ),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${order.discountedTotal}\u20BD'),
                      const SizedBox(height: 4),
                      Text(order.status),
                    ],
                  ),
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    TextButton(
                      onPressed: () {
                        order.status = 'Готовится';
                        _service.updateOrder();
                      },
                      child: const Text('Готовится'),
                    ),
                    TextButton(
                      onPressed: () {
                        order.status = 'В пути';
                        _service.updateOrder();
                      },
                      child: const Text('Отправить курьера'),
                    ),
                    TextButton(
                      onPressed: () {
                        order.status = 'Закрыт';
                        _service.updateOrder();
                      },
                      child: const Text('Закрыть заказ'),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    TextButton(
                      onPressed: () async {
                        final discount = await _askDiscount(context);
                        if (discount != null) {
                          order.discount = discount;
                          _service.updateOrder();
                        }
                      },
                      child: const Text('Назначить скидку'),
                    ),
                    TextButton(
                      onPressed: () async {
                        final promo = await _choosePromo(context);
                        if (promo != null) {
                          order.promo = promo;
                          _service.updateOrder();
                        }
                      },
                      child: const Text('Применить промокод'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<int?> _askDiscount(BuildContext context) async {
    final controller = TextEditingController();
    final result = await showDialog<int>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Скидка %'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'от 5 до 100'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              if (value != null && value >= 5 && value <= 100) {
                Navigator.pop(context, value);
              }
            },
            child: const Text('Ок'),
          ),
        ],
      ),
    );
    return result;
  }

  Future<Promo?> _choosePromo(BuildContext context) async {
    final promos = _promoService.promos.where((p) => p.active).toList();
    if (promos.isEmpty) return null;
    return showDialog<Promo>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text('Выберите промокод'),
        children: [
          for (final p in promos)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, p),
              child: Text('${p.code} (${p.discount}%)'),
            ),
        ],
      ),
    );
  }
}
