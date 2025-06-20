import 'package:flutter/material.dart';

import '../models/cart_model.dart';
import '../models/cart_item.dart';
import '../widgets/empty_placeholder.dart';
import '../main.dart';
import 'checkout_screen.dart';
import '../widgets/app_drawer.dart';

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
      drawer: const MyAppDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('Корзина'),
      ),
      body: SafeArea(
        child: cart.items.isEmpty
            ? EmptyPlaceholder(
                message:
                    'Вы еще не добавили ни одного товара в корзину',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MainScreen(),
                    ),
                  );
                },
              )
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
                                      if (item.modifiers.isNotEmpty)
                                        Text(item.modifiers.map((m) => m.name).join(', ')),
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
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: const Text('Оформить'),
                        ),
                      ],
                    ),
                  ),
                ],
                ),
        ),
      );
  }
}
