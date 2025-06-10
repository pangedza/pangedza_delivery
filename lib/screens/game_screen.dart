import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

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
        title: const Text('Игра'),
      ),
      body: const Center(child: Text('Игра — скоро')),
    );
  }
}
