import 'package:flutter/material.dart';
import '../models/profile_model.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final profile = ProfileModel.instance;
  late final TextEditingController _nameController;
  DateTime? _birthDate;
  String _gender = 'не выбрано';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: profile.name);
    _birthDate = profile.birthDate;
    _gender = profile.gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
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
    );
    if (picked != null) {
      setState(() => _birthDate = picked);
    }
  }

  void _save() {
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
                  decoration: InputDecoration(
                    labelText: 'Дата рождения',
                    hintText: _birthDate != null
                        ? '${_birthDate!.day.toString().padLeft(2, '0')}.${_birthDate!.month.toString().padLeft(2, '0')}.${_birthDate!.year}'
                        : '',
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
