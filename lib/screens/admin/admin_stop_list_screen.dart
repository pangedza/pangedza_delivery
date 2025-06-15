import 'package:flutter/material.dart';

import '../../models/category.dart';
import '../../models/menu_loader.dart';
import '../../widgets/admin/stop_list_item.dart';

/// Screen that allows to manage dish availability and leftovers.
class AdminStopListScreen extends StatefulWidget {
  const AdminStopListScreen({super.key});

  @override
  State<AdminStopListScreen> createState() => _AdminStopListScreenState();
}

class _AdminStopListScreenState extends State<AdminStopListScreen> {
  Future<List<Category>>? _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= loadMenu(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final categories = snapshot.data!;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final cat in categories)
              ExpansionTile(
                title: Text(cat.name),
                children: [
                  for (final dish in cat.dishes)
                    StopListItem(dish: dish),
                ],
              ),
          ],
        );
      },
    );
  }
}
