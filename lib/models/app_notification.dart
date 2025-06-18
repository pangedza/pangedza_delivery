class AppNotification {
  final String id;
  final String title;
  final String text;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.title,
    required this.text,
    required this.createdAt,
  });

  factory AppNotification.fromMap(Map<String, dynamic> map) => AppNotification(
        id: map['id'].toString(),
        title: map['title'] as String? ?? '',
        text: map['text'] as String? ?? '',
        createdAt:
            DateTime.tryParse(map['created_at']?.toString() ?? '') ?? DateTime.now(),
      );
}
