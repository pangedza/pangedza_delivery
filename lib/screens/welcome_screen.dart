import 'package:flutter/material.dart';
import '../main.dart';
import 'phone_auth_screen.dart';

/// A simple welcome screen displayed on app start.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _openAuth(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PhoneAuthScreen()),
    );
  }

  void _quickOrder(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  ElevatedButton(
                    onPressed: () => _openAuth(context),
                    child: const Text('Вход'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _openAuth(context),
                    child: const Text('Регистрация'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _quickOrder(context),
                    child: const Text('Быстрый заказ'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
