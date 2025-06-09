import 'package:flutter/material.dart';

class QuickOrderPage extends StatelessWidget {
  const QuickOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Быстрый заказ')),
      body: const Center(
        child: Text('Страница быстрого заказа'),
      ),
    );
  }
}
