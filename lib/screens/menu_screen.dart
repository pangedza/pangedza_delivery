import 'package:flutter/material.dart';
import '../widgets/noodle_builder_bottom_sheet.dart';

/// Simple menu screen containing a single custom noodles category.
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _openBuilder(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const NoodleBuilderBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            title: const Text('Собери лапшу сам'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _openBuilder(context),
          ),
        ),
      ],
    );
  }
}
