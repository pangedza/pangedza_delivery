import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../services/reviews_service.dart';

class ReviewFormModal extends StatefulWidget {
  final VoidCallback onSubmitted;
  const ReviewFormModal({super.key, required this.onSubmitted});

  @override
  State<ReviewFormModal> createState() => _ReviewFormModalState();
}

class _ReviewFormModalState extends State<ReviewFormModal> {
  final TextEditingController _controller = TextEditingController();
  int? _rating; // 1 positive, 0 negative
  File? _photo;

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() => _photo = File(picked.path));
    }
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _rating == null) return;
    final userId = Supabase.instance.client.auth.currentUser?.id;
    await ReviewsService()
        .addReview(userId: userId, text: text, rating: _rating!, photo: _photo);
    if (mounted) {
      Navigator.pop(context);
      widget.onSubmitted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: _pickPhoto,
                    icon: const Icon(Icons.camera_alt),
                  ),
                  if (_photo != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _photo!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                color: Colors.grey.shade300,
                child: const Text('Совершите заказ и напишите отзыв'),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => setState(() => _rating = 1),
                      child: const Text(
                        'ПОЗИТИВНЫЙ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => setState(() => _rating = 0),
                      child: const Text(
                        'НЕГАТИВНЫЙ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _controller,
                maxLength: 600,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Отзыв (максимальная длина 600 символов)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _submit,
                  child: const Text(
                    'ОТПРАВИТЬ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
