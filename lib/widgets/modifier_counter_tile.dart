import 'package:flutter/material.dart';
import '../models/modifier.dart';

class ModifierCounterTile extends StatelessWidget {
  final Modifier modifier;
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const ModifierCounterTile({
    super.key,
    required this.modifier,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(modifier.name),
                if (modifier.groupName != null && modifier.groupName!.isNotEmpty)
                  Text(
                    modifier.groupName!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          if (modifier.price > 0)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text('${modifier.price} ₽'),
            ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: count > 0 ? onDecrement : null,
          ),
          Text('$count'),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: onIncrement,
          ),
        ],
      ),
    );
  }
}
