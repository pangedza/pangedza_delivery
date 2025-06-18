import 'package:flutter/material.dart';
import '../../models/review.dart';
import '../../widgets/reviews/review_form_modal.dart';
import '../../services/reviews_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyReviewsScreen extends StatefulWidget {
  const MyReviewsScreen({super.key});

  @override
  State<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends State<MyReviewsScreen> {
  final List<Review> _reviews = [];
  bool _loading = true;

  Future<void> _editReview(Review review) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ReviewFormModal(
        review: review,
        onSubmit: (r) async {
          final user = Supabase.instance.client.auth.currentUser;
          if (user != null) {
            print('Отправляем отзыв: ${r.toMap()}');
            await ReviewsService().addReview(r, user.id);
            if (context.mounted) Navigator.pop(context, r);
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Сначала нужно авторизоваться')));
            }
          }
        },
      ),
    );
    await _load();
  }

  Future<void> _deleteReview(Review review) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Удалить отзыв?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
    if (res == true) {
      await ReviewsService().deleteReview(review.id);
      if (mounted) {
        setState(() => _reviews.removeWhere((r) => r.id == review.id));
      }
    }
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildCard(Review review) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  _formatDate(review.createdAt),
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editReview(review),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteReview(review),
                ),
              ],
            ),
            Row(
              children: [
                Row(
                  children: List.generate(
                    review.rating,
                    (i) => const Icon(
                      Icons.star,
                      color: Colors.orange,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  review.userName,
                  style: const TextStyle(color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(review.text),
            if (review.photoUrl != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Image.network(
                  review.photoUrl!,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = Supabase.instance.client.auth.currentUser?.id;
    if (id != null) {
      final res = await ReviewsService().getUserReviews(id);
      if (mounted) {
        setState(() {
          _reviews.addAll(res);
          _loading = false;
        });
      }
    } else {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text('Ваши отзывы')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final sorted = List<Review>.from(_reviews)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Scaffold(
      appBar: AppBar(title: const Text('Ваши отзывы')),
      body: sorted.isEmpty
          ? const Center(child: Text('Вы пока не оставили отзывов'))
          : ListView.builder(
              itemCount: sorted.length,
              itemBuilder: (context, i) => _buildCard(sorted[i]),
            ),
    );
  }
}
