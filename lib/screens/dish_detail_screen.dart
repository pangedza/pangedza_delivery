import 'package:flutter/material.dart';
import '../models/dish.dart';
import '../models/dish_variant.dart';
import '../models/modifier.dart';
import '../models/cart_model.dart';
import '../services/dish_service.dart';
import '../widgets/modifier_counter_tile.dart';

class DishDetailScreen extends StatefulWidget {
  final Dish dish;
  const DishDetailScreen({super.key, required this.dish});

  @override
  State<DishDetailScreen> createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends State<DishDetailScreen> {
  final Map<String, int> _modCounts = {};
  List<Modifier> _mods = [];
  
  @override
  void initState() {
    super.initState();
    _mods = widget.dish.modifiers;
    for (final m in _mods) {
      _modCounts.putIfAbsent(m.id, () => 0);
    }
    if (_mods.isEmpty) {
      _loadModifiers();
    }
  }

  Future<void> _loadModifiers() async {
    try {
      final mods = await DishService().fetchModifiers(widget.dish.id);
      if (mounted) {
          setState(() {
            _mods = mods;
            for (final m in _mods) {
              _modCounts.putIfAbsent(m.id, () => 0);
            }
          });
      }
    } catch (_) {
      // ignore errors
    }
  }

  void _add() {
    final variant = DishVariant(title: '', price: widget.dish.price);
    final mods = <Modifier>[];
    _modCounts.forEach((id, count) {
      final mod = _mods.firstWhere((m) => m.id == id);
      for (int i = 0; i < count; i++) {
        mods.add(mod);
      }
    });
    CartModel.instance.addItem(widget.dish, variant, mods);
    Navigator.of(context).pop();
  }

  int get _priceWithMods =>
      widget.dish.price +
          _modCounts.entries.fold(0, (s, e) {
            final mod = _mods.firstWhere((m) => m.id == e.key);
            return s + mod.price * e.value;
          });

  List<Widget> _buildModifierWidgets() {
    if (_mods.isEmpty) return [];
    final Map<String, List<Modifier>> groups = {};
    for (final m in _mods) {
      groups.putIfAbsent(m.groupName ?? '', () => []).add(m);
    }
    final widgets = <Widget>[];
    groups.forEach((name, list) {
      if (name.isNotEmpty) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        ));
      }
      for (final m in list) {
        _modCounts.putIfAbsent(m.id, () => 0);
        final count = _modCounts[m.id]!;
        widgets.add(ModifierCounterTile(
          modifier: m,
          count: count,
          onDecrement: () => setState(() {
            if (count > 0) _modCounts[m.id] = count - 1;
          }),
          onIncrement: () => setState(() {
            _modCounts[m.id] = count + 1;
          }),
        ));
      }
    });
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final dish = widget.dish;
    return Scaffold(
      appBar: AppBar(title: Text(dish.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: dish.imageUrl.isNotEmpty
                  ? Image.network(
                      dish.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: const Icon(Icons.fastfood, size: 64),
                      ),
                    )
                  : Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: const Icon(Icons.fastfood, size: 64),
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              dish.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (dish.weight.isNotEmpty)
              Text(
                dish.weight,
                style: TextStyle(color: Colors.grey[600]),
              ),
            if (dish.description != null) ...[
              const SizedBox(height: 8),
              Text(dish.description!),
            ],
            const SizedBox(height: 8),
            Text(
              '${dish.price} ₽',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ..._buildModifierWidgets(),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _add,
                child: Text('Добавить за $_priceWithMods ₽'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
