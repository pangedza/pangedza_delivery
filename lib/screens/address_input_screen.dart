import 'package:flutter/material.dart';

import '../models/profile_model.dart';

class AddressInputScreen extends StatefulWidget {
  const AddressInputScreen({super.key});

  @override
  State<AddressInputScreen> createState() => _AddressInputScreenState();
}

class _AddressInputScreenState extends State<AddressInputScreen> {
  final profile = ProfileModel.instance;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _streetCtrl;
  late final TextEditingController _houseCtrl;


  @override
  void initState() {
    super.initState();
    final parts = profile.address.split(',');
    _cityCtrl = TextEditingController(
      text: parts.isNotEmpty && parts.first.isNotEmpty
          ? parts.first.trim()
          : 'Новороссийск',
    );
    _streetCtrl = TextEditingController(
      text: parts.length > 1 ? parts[1].trim() : '',
    );
    _houseCtrl = TextEditingController(
      text: parts.length > 2 ? parts[2].trim() : '',
    );

  }

  @override
  void dispose() {
    _cityCtrl.dispose();
    _streetCtrl.dispose();
    _houseCtrl.dispose();
    super.dispose();
  }


  void _save() {
    final addr = '${_cityCtrl.text}, ${_streetCtrl.text}, ${_houseCtrl.text}'
        .trim();
    profile.updateAddress(addr);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Адрес')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _cityCtrl,
              decoration: const InputDecoration(labelText: 'Город'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _streetCtrl,
              decoration: const InputDecoration(labelText: 'Улица'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _houseCtrl,
              decoration: const InputDecoration(labelText: 'Дом'),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text('Сохранить адрес'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
