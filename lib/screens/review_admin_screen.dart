import 'package:flutter/material.dart';
import '../models/review_model.dart';

class ReviewAdminScreen extends StatelessWidget {
  ReviewAdminScreen({super.key});

  final ReviewModel model = ReviewModel.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Админ: отзывы')),
      body: AnimatedBuilder(
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
      ),
    );
  }
}
