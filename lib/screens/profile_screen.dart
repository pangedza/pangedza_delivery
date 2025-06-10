import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Имя: Гость', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            const Text('Телефон: -', style: TextStyle(fontSize: 18)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Выйти'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
