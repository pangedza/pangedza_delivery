import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/review.dart';

class ReviewsService {
  final _client = Supabase.instance.client;

  Future<List<Review>> getAllReviews() async {
    final res = await _client
        .from('reviews')
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
    final data = review.toMap()
      ..remove('id')
      ..remove('user_name')
      ..remove('photo_url')
      ..['user_id'] = userId;
    // debug print before sending review to Supabase
    print('Добавляем отзыв: $data');
    final response = await _client.from('reviews').insert(data).select();
    // debug print with Supabase response
    print('Ответ Supabase: $response');
  }

  Future<void> updateReview(Review review) async {
    final data = review.toMap()
      ..remove('id')
      ..remove('user_name')
      ..remove('photo_url');
    await _client.from('reviews').update(data).eq('id', review.id);
  }

  Future<void> deleteReview(String id) async {
    await _client.from('reviews').delete().eq('id', id);
  }
}
