import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../models/review.dart';

class ReviewsService {
  final _client = Supabase.instance.client;

  Future<List<Review>> fetchReviews({String? userId}) async {
    var query = _client.from('reviews');
    if (userId != null) {
      query = query.eq('user_id', userId);
    }
    final data = await query
        .select('*, users(name)')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(data)
        .map(Review.fromMap)
        .toList();
  }

  Future<void> addReview({
    String? userId,
    required String text,
    required int rating,
    File? photo,
  }) async {
    String? photoUrl;
    if (photo != null) {
      final bytes = await photo.readAsBytes();
      final ext = photo.path.split('.').last;
      final fileName = '${const Uuid().v4()}.$ext';
      await _client.storage.from('review-photos').uploadBinary(fileName, bytes);
      photoUrl = _client.storage.from('review-photos').getPublicUrl(fileName);
    }
    await _client.from('reviews').insert({
      'user_id': userId,
      'text': text,
      'rating': rating,
      if (photoUrl != null) 'photo_url': photoUrl,
    });
  }
}
