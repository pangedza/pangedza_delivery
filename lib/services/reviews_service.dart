import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/review.dart';

class ReviewsService {
  final _client = Supabase.instance.client;

  Future<List<Review>> getGeneralReviews() async {
    final res = await _client
        .from('general_reviews')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(res)
        .map(Review.fromMap)
        .toList();
  }

  Future<List<Review>> getUserReviews(String userId) async {
    final res = await _client
        .from('reviews')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(res)
        .map(Review.fromMap)
        .toList();
  }

  Future<void> addReview(Review review, String userId) async {
    final data = review.toMap()..['user_id'] = userId;
    await _client.from('reviews').insert(data);
    data.remove('user_id');
    await _client.from('general_reviews').insert(data);
  }

  Future<void> updateReview(Review review) async {
    final data = review.toMap()..remove('id');
    await _client.from('reviews').update(data).eq('id', review.id);
    await _client.from('general_reviews').update(data).eq('id', review.id);
  }

  Future<void> deleteReview(String id) async {
    await _client.from('reviews').delete().eq('id', id);
    await _client.from('general_reviews').delete().eq('id', id);
  }
}
