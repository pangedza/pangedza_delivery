import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isAdmin;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    final items = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Профиль',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.restaurant_menu),
        label: 'Меню',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.shopping_cart),
        label: 'Корзина',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.history),
        label: 'История',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.reviews),
        label: 'Отзывы',
      ),
    ];
    if (isAdmin) {
      items.add(const BottomNavigationBarItem(
        icon: Icon(Icons.admin_panel_settings),
        label: 'Админ',
      ));
    }
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      items: items,
    );
  }
}
