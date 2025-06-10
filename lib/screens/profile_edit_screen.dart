import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/profile_model.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    var text = '';
    for (var i = 0; i < digits.length && i < 8; i++) {
      if (i == 2 || i == 4) text += '/';
      text += digits[i];
    }
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final profile = ProfileModel.instance;
  late final TextEditingController _nameController;
  late final TextEditingController _dateController;
  DateTime? _birthDate;
  String _gender = 'не выбрано';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: profile.name);
    _birthDate = profile.birthDate;
    _dateController = TextEditingController(
      text: _birthDate != null
          ? DateFormat('dd/MM/yyyy', 'ru').format(_birthDate!)
          : '',
    );
    _gender = profile.gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = _birthDate ?? DateTime(now.year - 20);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: now,
      locale: const Locale('ru'),
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
        _dateController.text =
            DateFormat('dd/MM/yyyy', 'ru').format(_birthDate!);
      });
    }
  }

  void _save() {
    DateTime? manualDate;
    try {
      manualDate = DateFormat('dd/MM/yyyy', 'ru').parseStrict(_dateController.text);
    } catch (_) {}
    _birthDate = manualDate ?? _birthDate;
    profile.updateName(_nameController.text);
    profile.updateBirthDate(_birthDate);
    profile.updateGender(_gender);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать профиль'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Имя'),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: TextField(
                  controller: _dateController,
                  keyboardType: TextInputType.datetime,
                  inputFormatters: [DateInputFormatter()],
                  decoration: const InputDecoration(
                    labelText: 'Дата рождения',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _gender,
              items: const [
                DropdownMenuItem(value: 'не выбрано', child: Text('Не выбрано')),
                DropdownMenuItem(value: 'мужчина', child: Text('Мужчина')),
                DropdownMenuItem(value: 'женщина', child: Text('Женщина')),
              ],
              onChanged: (val) => setState(() => _gender = val ?? 'не выбрано'),
              decoration: const InputDecoration(labelText: 'Пол'),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text('Сохранить'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
