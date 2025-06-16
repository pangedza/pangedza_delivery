import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      Provider.of<ProfileModel>(context, listen: false).setUserId(userId);
      Navigator.of(context).pushReplacementNamed('/main');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ошибка регистрации")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Регистрация")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Имя")),
            TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Телефон")),
            TextField(
                controller: _pinController,
                decoration: InputDecoration(labelText: "4-значный PIN")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _register, child: Text("Зарегистрироваться"))
          ],
        ),
      ),
    );
  }
}

