class Review {
  final String id;
  final String userName;
  final String text;
  final bool isPositive;
  final DateTime createdAt;
  final String? photoUrl;

  Review({
    required this.id,
    required this.userName,
    required this.text,
    required this.isPositive,
    required this.createdAt,
    this.photoUrl,
  });

  factory Review.fromMap(Map<String, dynamic> map) => Review(
        id: map['id'].toString(),
        userName: map['user_name'] as String? ?? '',
        text: map['text'] as String? ?? '',
        isPositive: map['is_positive'] == true,
        createdAt:
            DateTime.tryParse(map['created_at']?.toString() ?? '') ?? DateTime.now(),
        photoUrl: map['photo_url'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_name': userName,
        'text': text,
        'is_positive': isPositive,
        'created_at': createdAt.toIso8601String(),
        'photo_url': photoUrl,
      };
}
