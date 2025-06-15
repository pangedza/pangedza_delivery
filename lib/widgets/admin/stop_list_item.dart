import 'package:flutter/material.dart';

import '../../models/dish.dart';
import '../../services/stop_list_service.dart';
import '../../di.dart';

class StopListItem extends StatefulWidget {
  final Dish dish;
  const StopListItem({super.key, required this.dish});

  @override
  State<StopListItem> createState() => _StopListItemState();
}

class _StopListItemState extends State<StopListItem> {
  final StopListService service = stopListService;

  @override
  void initState() {
    super.initState();
    service.addListener(_update);
  }

  @override
  void dispose() {
    service.removeListener(_update);
    super.dispose();
  }

  void _update() => setState(() {});

  Future<void> _setLeftover() async {
    final controller = TextEditingController();
    final count = await showDialog<int>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Остаток'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Количество'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              if (value != null) Navigator.pop(context, value);
            },
            child: const Text('Ок'),
          ),
        ],
      ),
    );
    if (count != null) {
      service.setLeftover(widget.dish.name, count);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isStopped = service.isStopped(widget.dish.name);
    final left = service.leftover(widget.dish.name);
    return ListTile(
      title: Text(widget.dish.name),
      subtitle: isStopped
          ? const Text('В стопе')
          : left != null
              ? Text('Осталось: $left')
              : null,
      trailing: Wrap(
        spacing: 8,
        children: [
          TextButton(onPressed: _setLeftover, child: const Text('Остаток')),
          TextButton(
            onPressed: () => service.stopDish(widget.dish.name),
            child: const Text('Стоп'),
          ),
          TextButton(
            onPressed: () => service.removeStop(widget.dish.name),
            child: const Text('Снять'),
          ),
        ],
      ),
    );
  }
}
