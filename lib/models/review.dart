class Review {
  final String id;
  final String? userId;
  final String userName;
  final String text;
  final int rating;
  final String? photoUrl;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.text,
    required this.rating,
    required this.photoUrl,
    required this.createdAt,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    final user = map['users'];
    return Review(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString(),
      userName: user?['name']?.toString() ?? 'Аноним',
      text: map['text']?.toString() ?? '',
      rating: map['rating'] is int
          ? map['rating'] as int
          : int.tryParse(map['rating']?.toString() ?? '') ?? 1,
      photoUrl: map['photo_url']?.toString(),
      createdAt:
          DateTime.tryParse(map['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
