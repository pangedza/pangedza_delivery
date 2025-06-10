import 'package:flutter/material.dart';

import '../models/cart_model.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/order_history_model.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

enum PaymentMethod { cash, terminal, online }
enum CheckoutMode { delivery, pickup }

class _CheckoutScreenState extends State<CheckoutScreen> {
  final cart = CartModel.instance;
  final history = OrderHistoryModel.instance;

  final cityCtrl = TextEditingController(text: 'Новороссийск');
  final streetCtrl = TextEditingController();
  final houseCtrl = TextEditingController();
  final flatCtrl = TextEditingController();
  final floorCtrl = TextEditingController();
  final intercomCtrl = TextEditingController();
  final promoCtrl = TextEditingController();
  final commentCtrl = TextEditingController();

  PaymentMethod _payment = PaymentMethod.cash;
  bool _leaveAtDoor = false;
  CheckoutMode _mode = CheckoutMode.delivery;
  String _district = 'Центральный';

  @override
  void dispose() {
    cityCtrl.dispose();
    streetCtrl.dispose();
    houseCtrl.dispose();
    flatCtrl.dispose();
    floorCtrl.dispose();
    intercomCtrl.dispose();
    promoCtrl.dispose();
    commentCtrl.dispose();
    super.dispose();
  }

  void _confirm() {
    final bool pickup = _mode == CheckoutMode.pickup;
    final order = Order(
      date: DateTime.now(),
      items: cart.items
          .map((e) => CartItem(
                dish: e.dish,
                variant: e.variant,
                quantity: e.quantity,
              ))
          .toList(),
      total: cart.total,
      city: pickup ? 'Новороссийск' : cityCtrl.text,
      district: pickup ? '' : _district,
      street: pickup ? 'Коммунистическая' : streetCtrl.text,
      house: pickup ? '51' : houseCtrl.text,
      flat: pickup ? '' : flatCtrl.text,
      intercom: pickup ? '' : intercomCtrl.text,
      comment: commentCtrl.text,
      payment: _payment.name,
      leaveAtDoor: _payment == PaymentMethod.online && _leaveAtDoor,
      pickup: pickup,
    );
    history.addOrder(order);
    cart.clear();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Заказ оформлен'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Ок'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Оформление заказа')),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/fon.jpeg', fit: BoxFit.cover),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
          children: [
            ToggleButtons(
              isSelected: [
                _mode == CheckoutMode.delivery,
                _mode == CheckoutMode.pickup
              ],
              onPressed: (index) => setState(() {
                    _mode =
                        index == 0 ? CheckoutMode.delivery : CheckoutMode.pickup;
                    if (_mode == CheckoutMode.pickup &&
                        _payment == PaymentMethod.online) {
                      _payment = PaymentMethod.cash;
                    }
                  }),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Доставка'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Самовывоз'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _mode == CheckoutMode.pickup
                  ? const Text(
                      'г. Новороссийск, ул. Коммунистическая, д. 51',
                      key: ValueKey('pickup'),
                    )
                  : Column(
                      key: const ValueKey('delivery'),
                      children: [
                        TextField(
                          controller: cityCtrl,
                          decoration:
                              const InputDecoration(labelText: 'Город'),
                        ),
                        DropdownButtonFormField<String>(
                          value: _district,
                          decoration:
                              const InputDecoration(labelText: 'Район'),
                          items: const [
                            DropdownMenuItem(
                                value: 'Центральный', child: Text('Центральный')),
                            DropdownMenuItem(value: 'Южный', child: Text('Южный')),
                            DropdownMenuItem(
                                value: 'Восточный', child: Text('Восточный')),
                            DropdownMenuItem(
                                value: 'Приморский', child: Text('Приморский')),
                          ],
                          onChanged: (val) =>
                              setState(() => _district = val ?? _district),
                        ),
                        TextField(
                          controller: streetCtrl,
                          decoration:
                              const InputDecoration(labelText: 'Улица'),
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: TextField(
                                controller: houseCtrl,
                                decoration:
                                    const InputDecoration(labelText: 'Дом'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: TextField(
                                controller: flatCtrl,
                                decoration: const InputDecoration(labelText: 'Квартира'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: TextField(
                                controller: floorCtrl,
                                decoration: const InputDecoration(labelText: 'Этаж'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: TextField(
                                controller: intercomCtrl,
                                decoration: const InputDecoration(labelText: 'Домофон'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
            TextField(
              controller: commentCtrl,
              decoration: const InputDecoration(labelText: 'Комментарий'),
            ),
            const SizedBox(height: 16),
            RadioListTile<PaymentMethod>(
              title: const Text('Наличные'),
              value: PaymentMethod.cash,
              groupValue: _payment,
              onChanged: (val) => setState(() => _payment = val!),
            ),
            RadioListTile<PaymentMethod>(
              title: Text(_mode == CheckoutMode.delivery
                  ? 'Оплата картой курьеру'
                  : 'Оплата картой'),
              value: PaymentMethod.terminal,
              groupValue: _payment,
              onChanged: (val) => setState(() => _payment = val!),
            ),
            if (_mode == CheckoutMode.delivery)
              RadioListTile<PaymentMethod>(
                title: const Text('Онлайн-оплата'),
                value: PaymentMethod.online,
                groupValue: _payment,
                onChanged: (val) => setState(() => _payment = val!),
              ),
            if (_mode == CheckoutMode.delivery &&
                _payment == PaymentMethod.online)
              CheckboxListTile(
                title: const Text('Оставить у двери'),
                value: _leaveAtDoor,
                onChanged: (val) => setState(() => _leaveAtDoor = val ?? false),
              ),
            TextField(
              controller: promoCtrl,
              decoration: const InputDecoration(labelText: 'Введите промокод'),
              onChanged: (val) => print('Промокод: $val'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _confirm,
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Подтвердить заказ'),
              ),
            ),
          ],
        ),
      ),
    ],
  ),
);
  }
}
