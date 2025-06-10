import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/order_history_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/reviews_screen.dart';
import 'screens/review_admin_screen.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(const MyApp());
}

/// Root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}

/// Stateful widget that holds bottom navigation logic.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return const MenuScreen();
      case 1:
        return const CartScreen();
      case 2:
        return const GameScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Меню',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Корзина',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videogame_asset),
            label: 'Игра',
          ),
        ],
      ),
    );
  }
}
