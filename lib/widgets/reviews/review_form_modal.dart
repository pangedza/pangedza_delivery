import 'package:flutter/material.dart';
import '../../models/review.dart';

class ReviewFormModal extends StatefulWidget {
  final void Function(Review) onSubmit;
  const ReviewFormModal({super.key, required this.onSubmit});

  @override
  State<ReviewFormModal> createState() => _ReviewFormModalState();
}

class _ReviewFormModalState extends State<ReviewFormModal> {
  final _controller = TextEditingController();
  bool _positive = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final review = Review(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userName: 'Вы',
      text: text,
      isPositive: _positive,
      createdAt: DateTime.now(),
    );
    widget.onSubmit(review);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.camera_alt, color: Colors.black54),
                  ),
                  const SizedBox(width: 16),
                  ChoiceChip(
                    label: const Text('Позитивный'),
                    selected: _positive,
                    selectedColor: Colors.green.shade200,
                    onSelected: (_) => setState(() => _positive = true),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Негативный'),
                    selected: !_positive,
                    selectedColor: Colors.red.shade200,
                    onSelected: (_) => setState(() => _positive = false),
                  ),
                ],
              ),
              TextField(
                controller: _controller,
                maxLength: 600,
                maxLines: null,
                decoration: const InputDecoration(labelText: 'Отзыв'),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE30613),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _submit,
                  child: const Text('Отправить'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
