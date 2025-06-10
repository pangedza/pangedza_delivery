import 'package:flutter/material.dart';

import '../models/address_model.dart';
import '../widgets/address_form_sheet.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  void _add(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const AddressFormSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = AddressBookModel.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Адреса')),
      body: AnimatedBuilder(
        animation: model,
        builder: (_, __) {
          if (model.addresses.isEmpty) {
            return const Center(child: Text('Нет сохранённых адресов'));
          }
          return ListView.builder(
            itemCount: model.addresses.length,
            itemBuilder: (_, index) {
              final a = model.addresses[index];
              final subtitle = [a.street, a.house, if(a.flat != null && a.flat!.isNotEmpty) 'кв. ${a.flat}'].where((e) => e.isNotEmpty).join(', ');
              return ListTile(
                leading: const Icon(Icons.place),
                title: Text(a.title ?? '${a.street}, ${a.house}'),
                subtitle: Text(subtitle),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _add(context),
            child: const Text('Добавить адрес'),
          ),
        ),
      ),
    );
  }
}
