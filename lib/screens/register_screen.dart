import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../services/users_service.dart';
import '../models/profile_model.dart';
import '../theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _pinController = TextEditingController();

  Future<void> _register() async {
    final userId = await UsersService().registerUser(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      pin: _pinController.text.trim(),
    );

    if (userId != null && mounted) {
      final profile = await UsersService().getProfile(userId);
      if (!mounted) return;
      if (profile != null) {
        context.read<ProfileModel>().setUser(profile);
      }
      Navigator.of(context).pushReplacementNamed('/main');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ошибка регистрации")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final phoneMask = MaskTextInputFormatter(
      mask: '+7 (###) ###-##-##',
      filter: {"#": RegExp(r'[0-9]')},
    );

    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      appBar: AppBar(title: Text("Регистрация")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: AppTheme.input("Ваше имя", "Имя"),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              inputFormatters: [phoneMask],
              keyboardType: TextInputType.phone,
              decoration: AppTheme.input("Ваш номер телефона", "+7 (900) 000-00-00"),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: AppTheme.input("Придумайте PIN", "4 цифры"),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              style: AppTheme.redButton,
              onPressed: _register,
              child: Text("Зарегистрироваться"),
            )
          ],
        ),
      ),
    );
  }
}

