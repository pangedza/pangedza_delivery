import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants.dart';
import 'menu_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _codeSent = false;

  Future<void> _sendCode() async {
    await Supabase.instance.client.auth.signInWithOtp(phone: _phoneController.text);
    setState(() => _codeSent = true);
  }

  Future<void> _verify() async {
    final res = await Supabase.instance.client.auth.verifyOTP(
      type: OtpType.sms,
      token: _otpController.text,
      phone: _phoneController.text,
    );
    if (res.session != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MenuScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Вход')),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(hintText: 'Номер телефона'),
            ),
            if (_codeSent) ...[
              const SizedBox(height: defaultPadding),
              TextField(
                controller: _otpController,
                decoration: const InputDecoration(hintText: 'Код из SMS'),
              ),
            ],
            const SizedBox(height: defaultPadding),
            ElevatedButton(
              onPressed: _codeSent ? _verify : _sendCode,
              child: Text(_codeSent ? 'Проверить' : 'Отправить код'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MenuScreen()),
                );
              },
              child: const Text('Войти как админ'),
            ),
          ],
        ),
      ),
    );
  }
}
