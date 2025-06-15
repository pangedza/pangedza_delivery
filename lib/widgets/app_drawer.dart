import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/profile_model.dart';

/// Common application drawer used across multiple screens.
class MyAppDrawer extends StatefulWidget {
  const MyAppDrawer({super.key});

  @override
  State<MyAppDrawer> createState() => _MyAppDrawerState();
}

class _MyAppDrawerState extends State<MyAppDrawer> {
  final profile = ProfileModel.instance;

  @override
  void initState() {
    super.initState();
    profile.addListener(_onProfileChange);
    profile.load();
  }

  @override
  void dispose() {
    profile.removeListener(_onProfileChange);
    super.dispose();
  }

  void _onProfileChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Text('Навигация'),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Профиль'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Меню'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/main');
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Корзина'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/cart');
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('История заказов'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/history');
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Отзывы'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/reviews');
              },
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Админ'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/admin_panel');
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Уведомления'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/notifications');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('О нас'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/about');
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      final uri = Uri.parse(
                        'https://www.instagram.com/pangedza.nvrsk?igsh=MWQyOWh0c2FvNnRxZA==',
                      );
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    },
                    icon: Image.asset(
                      'assets/icons/logo_inst.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: () async {
                      final uri = Uri.parse('https://vk.com/pangedza');
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    },
                    icon: Image.asset(
                      'assets/icons/logo_vk.png',
                      width: 40,
                      height: 40,
                    ),
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
