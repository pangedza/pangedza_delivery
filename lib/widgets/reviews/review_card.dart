import 'package:flutter/material.dart';
import '../../models/review.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  final VoidCallback? onReport;
  const ReviewCard({super.key, required this.review, this.onReport});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  _formatDate(review.createdAt),
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
                const Spacer(),
                PopupMenuButton<int>(
                  onSelected: (v) {
                    if (v == 1 && onReport != null) onReport!();
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem<int>(value: 1, child: Text('Пожаловаться')),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  review.isPositive ? Icons.thumb_up : Icons.thumb_down,
                  color: review.isPositive ? Colors.green : Colors.red,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  review.userName,
                  style: const TextStyle(color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(review.text),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
