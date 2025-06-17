import 'package:flutter/material.dart';
import '../../models/review.dart';
import '../../widgets/reviews/review_card.dart';
import '../../services/reviews_service.dart';
import '../../models/profile_model.dart';

class MyReviewsScreen extends StatefulWidget {
  const MyReviewsScreen({super.key});

  @override
  State<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends State<MyReviewsScreen> {
  final List<Review> _reviews = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = ProfileModel.instance.id;
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
          ? const Center(child: Text('Нет отзывов'))
          : ListView.builder(
              itemCount: sorted.length,
              itemBuilder: (context, i) => ReviewCard(review: sorted[i]),
            ),
    );
  }
}
