
import 'package:flutter/material.dart';

/// Bottom sheet widget allowing users to build their own noodles.
class NoodleBuilderBottomSheet extends StatefulWidget {
  const NoodleBuilderBottomSheet({super.key});

  @override
  State<NoodleBuilderBottomSheet> createState() => _NoodleBuilderBottomSheetState();
}

class _NoodleBuilderBottomSheetState extends State<NoodleBuilderBottomSheet> {
  final List<String> _noodles = [
    'Удон',
    'Соба',
    'Фунчоза',
    'Рисовая',
    'Рис',
    'Лагманная',
  ];

  final Map<String, int> _fillingPrices = {
    'Курица': 440,
    'Креветка': 500,
    'Свинина': 470,
    'Овощи': 450,
  };

  String _selectedNoodle = 'Удон';
  String _selectedFilling = 'Курица';

  int get _price => _fillingPrices[_selectedFilling] ?? 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Тип лапши',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ..._noodles.map(
                (n) => RadioListTile<String>(
                  title: Text(n),
                  value: n,
                  groupValue: _selectedNoodle,
                  onChanged: (val) => setState(() => _selectedNoodle = val!),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Начинка',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ..._fillingPrices.keys.map(
                (f) => RadioListTile<String>(
                  title: Text(f),
                  value: f,
                  groupValue: _selectedFilling,
                  onChanged: (val) => setState(() => _selectedFilling = val!),
                ),
              ),
              const SizedBox(height: 12),
              Text('Итого: $_price ₽', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // ignore: avoid_print
                    print('Добавлено: $_selectedNoodle с $_selectedFilling - $_price ₽');
                    Navigator.of(context).pop();
                  },
                  child: const Text('Добавить в корзину'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
