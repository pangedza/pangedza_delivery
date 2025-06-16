import 'package:flutter/material.dart';
import '../models/dish.dart';
import '../models/dish_variant.dart';
import '../models/modifier.dart';
import '../models/cart_model.dart';
import '../services/dish_service.dart';

class DishDetailScreen extends StatefulWidget {
  final Dish dish;
  const DishDetailScreen({super.key, required this.dish});

  @override
  State<DishDetailScreen> createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends State<DishDetailScreen> {
  final Set<Modifier> _selectedMods = {};
  List<Modifier> _mods = [];
  
  @override
  void initState() {
    super.initState();
    _mods = widget.dish.modifiers;
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
        });
      }
    } catch (_) {
      // ignore errors
    }
  }

  void _add() {
    final variant = DishVariant(title: '', price: widget.dish.price);
    CartModel.instance.addItem(widget.dish, variant, _selectedMods.toList());
    Navigator.of(context).pop();
  }

  int get _priceWithMods =>
      widget.dish.price + _selectedMods.fold(0, (s, m) => s + m.price);

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
        final checked = _selectedMods.contains(m);
        widgets.add(CheckboxListTile(
          title: Text('${m.name}${m.price > 0 ? ' +${m.price} ₽' : ''}'),
          value: checked,
          onChanged: (_) {
            setState(() {
              if (checked) {
                _selectedMods.remove(m);
              } else {
                _selectedMods.add(m);
              }
            });
          },
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
            if (dish.description != null) ...[
              Text(dish.description!),
              const SizedBox(height: 16),
            ],
            ..._buildModifierWidgets(),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _add,
                child: Text('Добавить за ${_priceWithMods} ₽'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
