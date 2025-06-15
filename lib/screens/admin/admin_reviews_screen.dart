import 'package:flutter/material.dart';
import '../../models/review_model.dart';

class AdminReviewsScreen extends StatefulWidget {
  const AdminReviewsScreen({super.key});

  @override
  State<AdminReviewsScreen> createState() => _AdminReviewsScreenState();
}

class _AdminReviewsScreenState extends State<AdminReviewsScreen> {
  final model = ReviewModel.instance;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: model,
      builder: (_, __) {
        if (model.reviews.isEmpty) {
          return const Center(child: Text('Нет отзывов'));
        }
        return ListView.builder(
          itemCount: model.reviews.length,
          itemBuilder: (_, index) {
            final review = model.reviews[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text('${review.dishId} (${review.stars}★)'),
                subtitle: review.text != null ? Text(review.text!) : null,
                trailing: Switch(
                  value: !review.hidden,
                  onChanged: (_) => model.toggleHidden(review),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
