import 'package:flutter/foundation.dart';

class Review {
  String id;
  String userId;
  String dishId;
  int stars;
  String? text;
  String? emoji;
  String? gifUrl;
  DateTime createdAt;
  bool hidden;

  Review({
    required this.id,
    required this.userId,
    required this.dishId,
    required this.stars,
    this.text,
    this.emoji,
    this.gifUrl,
    required this.createdAt,
    this.hidden = false,
  });
}
