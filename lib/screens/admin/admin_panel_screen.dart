import 'package:flutter/material.dart';
import 'admin_orders_screen.dart';
import 'admin_reviews_screen.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  int _selected = 0;

  final List<Widget> _screens = const [
    AdminOrdersScreen(),
    AdminReviewsScreen(),
    Center(child: Text('Стоп-лист')),
    Center(child: Text('Меню')),
    Center(child: Text('Промокоды')),
    Center(child: Text('Пользователи')),
    Center(child: Text('Доставка')),
    Center(child: Text('Аналитика')),
    Center(child: Text('Настройки')),
  ];

  @override
  Widget build(BuildContext context) {
    // Access control is disabled in local builds

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selected,
            onDestinationSelected: (i) => setState(() => _selected = i),
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.list_alt),
                label: Text('Заказы'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.reviews),
                label: Text('Отзывы'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.no_food),
                label: Text('Стоп-лист'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.restaurant_menu),
                label: Text('Меню'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.card_giftcard),
                label: Text('Промокоды'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text('Пользователи'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.delivery_dining),
                label: Text('Доставка'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.analytics),
                label: Text('Аналитика'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('Настройки'),
              ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: _screens[_selected]),
        ],
      ),
    );
  }
}
