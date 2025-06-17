import 'package:flutter/material.dart';

import '../models/address_model.dart';
import '../widgets/address_form_sheet.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  Future<void> _confirmDelete(
      BuildContext context, AddressModel address, AddressBookModel model) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Удалить адрес?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
    if (result == true) {
      await model.remove(address);
    }
  }

  void _add(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.white,
      builder: (_) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.pop(context),
        child: GestureDetector(
          onTap: () {},
          child: const AddressFormSheet(),
        ),
      ),
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
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _confirmDelete(context, a, model),
                ),
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
