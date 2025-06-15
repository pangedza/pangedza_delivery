class LegacyReview {
  final String id;
  final String userId;
  final String dishId;
  final int stars;
  final String? text;
  final String? emoji;
  final String? gifUrl;
  final DateTime createdAt;
  bool hidden;

  LegacyReview({
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

  factory LegacyReview.fromJson(Map<String, dynamic> json) => LegacyReview(
        id: json['id'] as String,
        userId: json['userId'] as String,
        dishId: json['dishId'] as String,
        stars: json['stars'] as int,
        text: json['text'] as String?,
        emoji: json['emoji'] as String?,
        gifUrl: json['gifUrl'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        hidden: json['hidden'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'dishId': dishId,
        'stars': stars,
        'text': text,
        'emoji': emoji,
        'gifUrl': gifUrl,
        'createdAt': createdAt.toIso8601String(),
        'hidden': hidden,
      };
}
