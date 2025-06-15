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
}
