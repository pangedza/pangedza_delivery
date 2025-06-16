import 'package:flutter/material.dart';
import '../models/dish.dart';
import '../models/dish_variant.dart';
import '../models/cart_model.dart';

class DishDetailScreen extends StatefulWidget {
  final Dish dish;
  const DishDetailScreen({super.key, required this.dish});

  @override
  State<DishDetailScreen> createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends State<DishDetailScreen> {
  late DishVariant _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.dish.modifiers.first;
  }

  void _add() {
    CartModel.instance.addItem(widget.dish, _selected);
    Navigator.of(context).pop();
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
            ...dish.modifiers.map(
              (v) => RadioListTile<DishVariant>(
                title: Text('${v.title} - ${v.price} ₽'),
                value: v,
                groupValue: _selected,
                onChanged: (val) => setState(() => _selected = val!),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _add,
                child: Text('Добавить за ${_selected.price} ₽'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
