import 'package:flutter/foundation.dart';

import 'legacy_review.dart';

class ReviewModel extends ChangeNotifier {
  ReviewModel._();
  static final ReviewModel instance = ReviewModel._();

  final List<LegacyReview> reviews = [
    LegacyReview(
      id: '1',
      userId: 'user2',
      dishId: 'Жареный рай',
      stars: 5,
      text: 'Очень вкусно!',
      emoji: '😍',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    LegacyReview(
      id: '2',
      userId: 'user3',
      dishId: 'Острые ощущения',
      stars: 4,
      text: 'Неплохо',
      emoji: '🔥',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  void addReview(LegacyReview review) {
    reviews.insert(0, review);
    notifyListeners();
  }

  void updateReview(LegacyReview review) {
    final index = reviews.indexWhere((r) => r.id == review.id);
    if (index != -1) {
      reviews[index] = review;
      notifyListeners();
    }
  }

  void deleteReview(LegacyReview review) {
    reviews.removeWhere((r) => r.id == review.id);
    notifyListeners();
  }

  void toggleHidden(LegacyReview review) {
    final index = reviews.indexWhere((r) => r.id == review.id);
    if (index != -1) {
      reviews[index].hidden = !reviews[index].hidden;
      notifyListeners();
    }
  }
}

const currentUserId = 'user1';

