import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../services/users_service.dart';
import '../models/profile_model.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
      context.read<ProfileModel>().setUserId(userId);
      Navigator.of(context).pushReplacementNamed('/main');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ошибка регистрации")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final _phoneMask = MaskTextInputFormatter(
      mask: '+7 (###) ###-##-##',
      filter: {"#": RegExp(r'[0-9]')},
    );

    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(title: Text("Регистрация")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Ваше имя",
                hintText: "Имя",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              inputFormatters: [_phoneMask],
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Ваш номер телефона",
                hintText: "+7 (900) 000-00-00",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Придумайте PIN",
                hintText: "4 цифры",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.black,
                textStyle: TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _register,
              child: Text("Зарегистрироваться"),
            )
          ],
        ),
      ),
    );
  }
}

