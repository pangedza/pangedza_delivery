import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as flutter_provider;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  _PhoneLoginScreenState createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  bool codeSent = false;

  Future<void> sendCode() async {
    final phone = _phoneController.text.trim();
    await Supabase.instance.client.auth.signInWithOtp(phone: phone);
    if (!context.mounted) return;
    setState(() => codeSent = true);
  }

  Future<void> verifyCode() async {
    final phone = _phoneController.text.trim();
    final code = _codeController.text.trim();
    final result = await Supabase.instance.client.auth.verifyOTP(
      phone: phone,
      token: code,
      type: OtpType.sms,
    );

    if (!context.mounted) return;
    if (result.user != null) {
      final userId = result.user!.id;
      final profile = flutter_provider.Provider.of<ProfileModel>(context, listen: false);
      profile.setUserId(userId);
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Неверный код")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Вход по номеру"), backgroundColor: Colors.red),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Номер телефона",
                border: OutlineInputBorder(),
              ),
            ),
            if (codeSent)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Код из SMS",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.black,
                textStyle: TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: codeSent ? verifyCode : sendCode,
              child: Text(
                codeSent ? "Подтвердить код" : "Отправить код",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
