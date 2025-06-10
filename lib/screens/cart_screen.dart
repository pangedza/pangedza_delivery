import 'package:flutter/material.dart';

import '../models/cart_model.dart';
import '../models/cart_item.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final cart = CartModel.instance;

  @override
  void initState() {
    super.initState();
    cart.addListener(_update);
  }

  @override
  void dispose() {
    cart.removeListener(_update);
    super.dispose();
  }

  void _update() => setState(() {});

  void _checkout() {
    if (cart.items.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CheckoutScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: cart.items.isEmpty
            ? const Center(child: Text('Корзина пуста'))
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cart.items.length,
                      itemBuilder: (_, index) {
                        final CartItem item = cart.items[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.dish.name),
                                      if (item.variant.title.isNotEmpty)
                                        Text(item.variant.title),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () => cart.decrement(item),
                                    ),
                                    Text('${item.quantity}'),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () => cart.increment(item),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                Text('${item.total} ₽'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Итого: ${cart.total} ₽'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _checkout,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.black,
                          ),
                          child: const Text('Оформить заказ'),
                        ),
                      ],
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
