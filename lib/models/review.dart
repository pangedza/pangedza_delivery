class Review {
  final String id;
  final String userName;
  final String text;
  final int rating;
  final DateTime createdAt;
  final String? photoUrl;

  Review({
    required this.id,
    required this.userName,
    required this.text,
    required this.rating,
    required this.createdAt,
    this.photoUrl,
  });

  factory Review.fromMap(Map<String, dynamic> map) => Review(
        id: map['id'].toString(),
        userName: map['user_name'] as String? ?? '',
        text: map['text'] as String? ?? '',
        rating: (map['rating'] as int?) ?? 5,
        createdAt:
            DateTime.tryParse(map['created_at']?.toString() ?? '') ?? DateTime.now(),
        photoUrl: map['photo_url'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'text': text,
        'rating': rating,
        'created_at': createdAt.toIso8601String(),
      };
}
