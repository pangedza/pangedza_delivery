import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../models/dish.dart';
import '../models/dish_variant.dart';

class DishAddModal extends StatefulWidget {
  final Dish dish;
  const DishAddModal({super.key, required this.dish});

  @override
  State<DishAddModal> createState() => _DishAddModalState();
}

class _DishAddModalState extends State<DishAddModal> {
  int _qty = 1;

  void _add() {
    final variant = DishVariant(title: widget.dish.weight, price: widget.dish.price);
    for (int i = 0; i < _qty; i++) {
      CartModel.instance.addItem(widget.dish, variant, const []);
    }
    Navigator.of(context).pop();
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _add,
                  child: const Text('Добавить в корзину'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
