import 'package:flutter/material.dart';
import '../models/dish.dart';
import '../models/dish_variant.dart';
import '../models/cart_model.dart';

class DishVariantSheet extends StatefulWidget {
  final Dish dish;
  const DishVariantSheet({super.key, required this.dish});

  @override
  State<DishVariantSheet> createState() => _DishVariantSheetState();
}

class _DishVariantSheetState extends State<DishVariantSheet> {
  late DishVariant _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.dish.modifiers.first;
  }

  void _add() {
    CartModel.instance.addItem(widget.dish, _selected);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Добавлено в корзину')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dish = widget.dish;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 120,
                width: double.infinity,
                color: Colors.grey.shade300,
                alignment: Alignment.center,
                child: const Icon(Icons.fastfood, size: 64),
              ),
              const SizedBox(height: 8),
              Text(
                dish.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              if (dish.description != null) ...[
                const SizedBox(height: 8),
                Text(dish.description!),
              ],
              const SizedBox(height: 16),
              if (dish.modifiers.length > 1)
                ...dish.modifiers.map(
                  (v) => RadioListTile<DishVariant>(
                    title: Text('${v.title} - ${v.price} ₽'),
                    value: v,
                    groupValue: _selected,
                    onChanged: (val) => setState(() => _selected = val!),
                  ),
                )
              else
                Text('${_selected.title} - ${_selected.price} ₽'),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _add,
                  child: const Text('Добавить'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
