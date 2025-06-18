import 'package:flutter/material.dart';
import '../models/dish.dart';
import '../models/dish_variant.dart';
import '../models/modifier.dart';
import '../models/cart_model.dart';

class DishVariantSheet extends StatefulWidget {
  final Dish dish;
  const DishVariantSheet({super.key, required this.dish});

  @override
  State<DishVariantSheet> createState() => _DishVariantSheetState();
}

class _DishVariantSheetState extends State<DishVariantSheet> {
  late Modifier _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.dish.modifiers.first;
  }

  void _add() {
    final variant = DishVariant(
      title: '',
      price: widget.dish.price + _selected.price,
    );
    CartModel.instance.addItem(widget.dish, variant, [_selected]);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final dish = widget.dish;
    final double imageHeight = MediaQuery.of(context).size.height * 0.4;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                child: dish.imageUrl.isNotEmpty
                    ? Image.network(
                        dish.imageUrl,
                        height: imageHeight,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          'assets/images/placeholder.jpg',
                          height: imageHeight,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        'assets/images/placeholder.jpg',
                        height: imageHeight,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 8),
              Text(
                dish.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (dish.description != null) ...[
                const SizedBox(height: 8),
                Text(dish.description!),
              ],
              const SizedBox(height: 16),
              if (dish.modifiers.length > 1)
                ...dish.modifiers.map(
                  (v) => RadioListTile<Modifier>(
                    title: Text('${v.name} - ${v.price} ₽'),
                    value: v,
                    groupValue: _selected,
                    onChanged: (val) => setState(() => _selected = val!),
                  ),
                )
              else
                Text('${_selected.name} - ${_selected.price} ₽'),
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
