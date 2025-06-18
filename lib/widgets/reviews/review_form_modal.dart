import 'package:flutter/material.dart';
import '../../models/review.dart';

class ReviewFormModal extends StatefulWidget {
  final void Function(Review) onSubmit;
  final Review? review;
  const ReviewFormModal({super.key, required this.onSubmit, this.review});

  @override
  State<ReviewFormModal> createState() => _ReviewFormModalState();
}

class _ReviewFormModalState extends State<ReviewFormModal> {
  late final TextEditingController _controller;
  int _rating = 5;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.review?.text ?? '');
    _rating = widget.review?.rating ?? 5;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    // debug print with review data before submit
    print('Submit review text: "$text" rating: $_rating');
    final review = Review(
      id: widget.review?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      userName: widget.review?.userName ?? 'Вы',
      text: text,
      rating: _rating,
      createdAt: widget.review?.createdAt ?? DateTime.now(),
    );
    // debug print with resulting review map
    print('Review object: ${review.toMap()}');
    // pass review to callback
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
                  Row(
                    children: List.generate(5, (index) {
                      final filled = index < _rating;
                      return IconButton(
                        icon: Icon(
                          filled ? Icons.star : Icons.star_border,
                          color: Colors.orange,
                        ),
                        onPressed: () => setState(() => _rating = index + 1),
                      );
                    }),
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
                  child: Text(widget.review == null ? 'Отправить' : 'Сохранить'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
