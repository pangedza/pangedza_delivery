import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/review.dart';

class ReviewForm extends StatefulWidget {
  final void Function(Review review, Uint8List? image) onSubmit;
  const ReviewForm({super.key, required this.onSubmit});

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final _controller = TextEditingController();
  bool _positive = true;
  final _picker = ImagePicker();
  XFile? _image;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final res = await _picker.pickImage(source: ImageSource.gallery);
    if (res != null) setState(() => _image = res);
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final review = Review(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userName: 'Вы',
      text: text,
      rating: _positive ? 5 : 1,
      createdAt: DateTime.now(),
      photoUrl: null,
    );
    final bytes = _image != null ? await _image!.readAsBytes() : null;
    widget.onSubmit(review, bytes);
    setState(() {
      _controller.clear();
      _image = null;
      _positive = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.camera_alt),
                ),
                if (_image != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Image.file(
                      File(_image!.path),
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                const Spacer(),
                ChoiceChip(
                  label: const Text('Позитивный'),
                  selected: _positive,
                  onSelected: (_) => setState(() => _positive = true),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Негативный'),
                  selected: !_positive,
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
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE30613),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Отправить'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
