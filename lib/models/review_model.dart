import 'package:flutter/foundation.dart';

import 'legacy_review.dart';

class ReviewModel extends ChangeNotifier {
  ReviewModel._();
  static final ReviewModel instance = ReviewModel._();

  /// In-memory list of reviews. It starts empty and new reviews are added
  /// using the current user's id from Supabase authentication.
  final List<LegacyReview> reviews = [];

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

