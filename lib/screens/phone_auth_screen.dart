import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/firebase_service.dart';
import 'profile_edit_screen.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _phoneCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  String? _verificationId;
  bool _codeSent = false;
  bool _loading = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    setState(() => _loading = true);
    await FirebaseService.instance.auth.verifyPhoneNumber(
      phoneNumber: _phoneCtrl.text,
      verificationCompleted: (cred) async {
        await FirebaseService.instance.auth.signInWithCredential(cred);
      },
      verificationFailed: (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Ошибка')),
        );
      },
      codeSent: (id, _) {
        setState(() {
          _verificationId = id;
          _codeSent = true;
        });
      },
      codeAutoRetrievalTimeout: (_) {},
    );
    setState(() => _loading = false);
  }

  Future<void> _verifyCode() async {
    if (_verificationId == null) return;
    setState(() => _loading = true);
    final cred = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: _codeCtrl.text,
    );
    await FirebaseService.instance.auth.signInWithCredential(cred);
    setState(() => _loading = false);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfileEditScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Вход / Регистрация')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            if (!_codeSent)
              TextField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Номер телефона'),
              )
            else
              TextField(
                controller: _codeCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Код из SMS'),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading
                  ? null
                  : _codeSent
                      ? _verifyCode
                      : _sendCode,
              child: Text(_codeSent ? 'Подтвердить' : 'Продолжить'),
            ),
          ],
        ),
      ),
    );
  }
}
