import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/users_service.dart';
import '../models/profile_model.dart';

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
      Provider.of<ProfileModel>(context, listen: false).setUserId(userId);
      Navigator.of(context).pushReplacementNamed('/main');
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Неверный номер или PIN")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Вход")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Телефон")),
            TextField(
                controller: _pinController,
                decoration: InputDecoration(labelText: "PIN")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: Text("Войти"))
          ],
        ),
      ),
    );
  }
}

