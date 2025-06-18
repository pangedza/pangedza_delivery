import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/review.dart';
import 'dart:typed_data';

class ReviewsService {
  final _client = Supabase.instance.client;

  Future<List<Review>> getAllReviews() async {
    final res = await _client
        .from('reviews')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(res).map(Review.fromMap).toList();
  }

  Future<List<Review>> getUserReviews(String userId) async {
    final res = await _client
        .from('reviews')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(res).map(Review.fromMap).toList();
  }

  Future<void> addReview(
    Review review,
    String userId, {
    Uint8List? photo,
  }) async {
    final data = review.toMap()
      ..remove('id')
      ..remove('user_name');
    data['user_id'] = userId;

    if (photo != null) {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      await _client.storage.from('reviews').uploadBinary(fileName, photo);
      data['photo_url'] = _client.storage
          .from('reviews')
          .getPublicUrl(fileName);
    }

    final response = await _client.from('reviews').insert(data).select();
    print('Ответ Supabase: $response');
  }

  Future<void> updateReview(Review review, {Uint8List? photo}) async {
    final data = review.toMap()
      ..remove('id')
      ..remove('user_name');

    if (photo != null) {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      await _client.storage.from('reviews').uploadBinary(fileName, photo);
      data['photo_url'] = _client.storage
          .from('reviews')
          .getPublicUrl(fileName);
    }

    await _client.from('reviews').update(data).eq('id', review.id);
  }

  Future<void> deleteReview(String id) async {
    await _client.from('reviews').delete().eq('id', id);
  }
}
