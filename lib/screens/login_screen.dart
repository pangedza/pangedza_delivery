import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../services/users_service.dart';
import '../models/profile_model.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _pinController = TextEditingController();

  Future<void> _login() async {
    final userId = await UsersService().loginUser(
      phone: _phoneController.text.trim(),
      pin: _pinController.text.trim(),
    );

    if (userId != null && mounted) {
      final profile = await UsersService().getProfile(userId);
      if (profile != null) {
        context.read<ProfileModel>().setUser(profile);
      }
      Navigator.of(context).pushReplacementNamed('/main');
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Неверный номер или PIN")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final _phoneMask = MaskTextInputFormatter(
      mask: '+7 (###) ###-##-##',
      filter: {"#": RegExp(r'[0-9]')},
    );

    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      appBar: AppBar(title: Text("Вход")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              inputFormatters: [_phoneMask],
              keyboardType: TextInputType.phone,
              decoration: AppTheme.input("Ваш номер телефона", "+7 (900) 000-00-00"),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: AppTheme.input("Введите PIN", "4 цифры"),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              style: AppTheme.redButton,
              onPressed: _login,
              child: Text("Войти"),
            )
          ],
        ),
      ),
    );
  }
}

