import 'package:flutter/material.dart';
import '../../models/review.dart';
import '../../widgets/reviews/review_card.dart';

class MyReviewsScreen extends StatelessWidget {
  final List<Review> reviews;
  const MyReviewsScreen({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    final sorted = reviews
        .where((r) => r.userName == 'Вы')
        .toList()
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
