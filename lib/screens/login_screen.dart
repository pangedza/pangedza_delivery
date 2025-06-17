import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/users_service.dart';
import '../models/profile_model.dart';
import '../theme/app_theme.dart';
import '../utils/shared_prefs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _pinController = TextEditingController();

  Future<void> loginWithPhoneAndPin() async {
    final rawPhone = _phoneController.text.trim();
    final phone = rawPhone.replaceAll(RegExp(r'[^+0-9]'), '');
    final pin = _pinController.text.trim();

    final response = await Supabase.instance.client
        .from('users')
        .select()
        .eq('phone', phone)
        .eq('pin_code', pin)
        .maybeSingle();

    if (!mounted) return;

    if (response == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Неверный номер или PIN")));
      return;
    }

    final userId = response['id'] as String;
    await SharedPrefs.instance.setUserId(userId);
    final profile = await UsersService().getProfile(userId);
    if (!mounted) return;
    if (profile != null) {
      context.read<ProfileModel>().setUser(profile);
    }
    Navigator.of(context).pushReplacementNamed('/main');
  }

  @override
  Widget build(BuildContext context) {
    final phoneMask = MaskTextInputFormatter(
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
              inputFormatters: [phoneMask],
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
              onPressed: loginWithPhoneAndPin,
              child: Text("Войти"),
            )
          ],
        ),
      ),
    );
  }
}

