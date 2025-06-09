import 'package:flutter/foundation.dart';

import 'review.dart';

class ReviewModel extends ChangeNotifier {
  ReviewModel._();
  static final ReviewModel instance = ReviewModel._();

  final List<Review> reviews = [
    Review(
      id: '1',
      userId: 'user2',
      dishId: 'Жареный рай',
      stars: 5,
      text: 'Очень вкусно!',
      emoji: '😍',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Review(
      id: '2',
      userId: 'user3',
      dishId: 'Острые ощущения',
      stars: 4,
      text: 'Неплохо',
      emoji: '🔥',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  void addReview(Review review) {
    reviews.insert(0, review);
    notifyListeners();
  }

  void updateReview(Review review) {
    final index = reviews.indexWhere((r) => r.id == review.id);
    if (index != -1) {
      reviews[index] = review;
      notifyListeners();
    }
  }

  void deleteReview(Review review) {
    reviews.removeWhere((r) => r.id == review.id);
    notifyListeners();
  }

  void toggleHidden(Review review) {
    final index = reviews.indexWhere((r) => r.id == review.id);
    if (index != -1) {
      reviews[index].hidden = !reviews[index].hidden;
      notifyListeners();
    }
  }
}

const currentUserId = 'user1';

