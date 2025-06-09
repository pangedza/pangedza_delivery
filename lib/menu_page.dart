import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_provider.dart';
import 'models/menu_item.dart';
import 'models/category.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  List<Category> get categories => [
        Category(id: '1', name: 'Пицца'),
        Category(id: '2', name: 'Напитки'),
      ];

  List<MenuItem> get items => [
        MenuItem(
            id: '1',
            name: 'Маргарита',
            description: 'Классическая пицца',
            price: 5.99,
            categoryId: '1'),
        MenuItem(
            id: '2',
            name: 'Пепперони',
            description: 'Пикантная пепперони',
            price: 6.99,
            categoryId: '1'),
        MenuItem(
            id: '3',
            name: 'Кола',
            description: 'Газированный напиток',
            price: 1.99,
            categoryId: '2'),
      ];

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Меню'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text('Корзина: \${cart.items.length}')),
          )
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(item.name,
                    style: Theme.of(context).textTheme.titleMedium),
                Text('\${item.price.toStringAsFixed(2)} \$'),
                Text(item.description),
                ElevatedButton(
                  onPressed: () => cart.add(item),
                  child: const Text('Добавить'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
