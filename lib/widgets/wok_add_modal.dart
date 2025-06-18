import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../models/dish.dart';
import '../models/dish_variant.dart';
import '../models/modifier.dart';
import '../services/dish_service.dart';

class WokAddModal extends StatefulWidget {
  final Dish dish;
  const WokAddModal({super.key, required this.dish});

  @override
  State<WokAddModal> createState() => _WokAddModalState();
}

class _WokAddModalState extends State<WokAddModal> {
  int _qty = 1;
  Modifier? _selectedNoodle;
  final Set<Modifier> _selectedAddons = {};
  List<Modifier> _mods = [];

  @override
  void initState() {
    super.initState();
    _mods = widget.dish.modifiers;
    if (_mods.isEmpty) {
      _loadModifiers();
    } else {
      _initDefaults();
    }
  }

  Future<void> _loadModifiers() async {
    try {
      final mods = await DishService().fetchModifiers(widget.dish.id);
      if (mounted) {
        setState(() {
          _mods = mods;
          _initDefaults();
        });
      }
    } catch (_) {}
  }

  void _initDefaults() {
    final noodles = _mods
        .where((m) => (m.groupName ?? '').toLowerCase() == 'лапша')
        .toList();
    if (noodles.isNotEmpty && _selectedNoodle == null) {
      _selectedNoodle = noodles.first;
    }
  }

  int get _priceWithMods =>
      widget.dish.price + _selectedAddons.fold(0, (s, m) => s + m.price);

  List<Modifier> get _noodleMods => _mods
      .where((m) => (m.groupName ?? '').toLowerCase() == 'лапша')
      .toList();

  List<Modifier> get _addonMods => _mods
      .where((m) => (m.groupName ?? '').toLowerCase() == 'добавки')
      .toList();

  void _add() {
    final variant = DishVariant(title: widget.dish.weight, price: widget.dish.price);
    final mods = <Modifier>[];
    if (_selectedNoodle != null) mods.add(_selectedNoodle!);
    mods.addAll(_selectedAddons);
    for (int i = 0; i < _qty; i++) {
      CartModel.instance.addItem(widget.dish, variant, mods);
    }
    Navigator.of(context).pop();
  }

  Widget _buildNoodleOptions() {
    final noodles = _noodleMods;
    if (noodles.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Text('Лапша', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        ...noodles.map((m) => RadioListTile<Modifier>(
              title: Text(m.name),
              value: m,
              groupValue: _selectedNoodle,
              onChanged: (val) => setState(() => _selectedNoodle = val),
            )),
      ],
    );
  }

  Widget _buildAddonOptions() {
    final addons = _addonMods;
    if (addons.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Text('Добавки', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        ...addons.map((m) {
          final checked = _selectedAddons.contains(m);
          return CheckboxListTile(
            title: Text('${m.name}${m.price > 0 ? ' +${m.price} ₽' : ''}'),
            value: checked,
            onChanged: (_) {
              setState(() {
                if (checked) {
                  _selectedAddons.remove(m);
                } else {
                  _selectedAddons.add(m);
                }
              });
            },
          );
        }),
      ],
    );
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
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: d.imageUrl.isNotEmpty
                    ? Image.network(
                        d.imageUrl,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 160,
                          width: double.infinity,
                          color: Colors.grey.shade300,
                          alignment: Alignment.center,
                          child: const Icon(Icons.fastfood, size: 64),
                        ),
                      )
                    : Container(
                        height: 160,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: const Icon(Icons.fastfood, size: 64),
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
              _buildNoodleOptions(),
              const SizedBox(height: 8),
              _buildAddonOptions(),
              const SizedBox(height: 12),
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
      ),
    );
  }
}
