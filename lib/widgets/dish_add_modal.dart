import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../models/dish.dart';
import '../models/dish_variant.dart';
import '../models/modifier.dart';
import 'modifier_counter_tile.dart';
import '../services/dish_service.dart';

class DishAddModal extends StatefulWidget {
  final Dish dish;
  const DishAddModal({super.key, required this.dish});

  @override
  State<DishAddModal> createState() => _DishAddModalState();
}

class _DishAddModalState extends State<DishAddModal> {
  int _qty = 1;
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
    } catch (_) {}
  }

  void _add() {
    final variant = DishVariant(title: widget.dish.weight, price: widget.dish.price);
    final mods = <Modifier>[];
    _modCounts.forEach((id, count) {
      final mod = _mods.firstWhere((m) => m.id == id);
      for (int i = 0; i < count; i++) {
        mods.add(mod);
      }
    });
    for (int i = 0; i < _qty; i++) {
      CartModel.instance.addItem(widget.dish, variant, mods);
    }
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
    final d = widget.dish;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: d.imageUrl.isNotEmpty
                    ? Image.network(
                        d.imageUrl,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          'assets/images/placeholder.jpg',
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        'assets/images/placeholder.jpg',
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 8),
              Text(
                d.name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (d.weight.isNotEmpty)
                Text(
                  d.weight,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              if (d.description != null && d.description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(d.description!),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: _qty > 1 ? () => setState(() => _qty--) : null,
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text('$_qty', style: const TextStyle(fontSize: 16)),
                  IconButton(
                    onPressed: () => setState(() => _qty++),
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ..._buildModifierWidgets(),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _add,
                  child: Text('Добавить за $_priceWithMods р'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
