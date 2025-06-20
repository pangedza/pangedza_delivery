import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/review.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  final VoidCallback onReport;

  const ReviewCard({
    super.key,
    required this.review,
    required this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd.MM.yyyy HH:mm').format(review.createdAt);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName,
                        style:
                            const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                      Text(date, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                Icon(
                  review.rating == 1 ? Icons.thumb_up : Icons.thumb_down,
                  color: review.rating == 1 ? Colors.green : Colors.red,
                ),
                PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'report') onReport();
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'report',
                      child: Text('Пожаловаться'),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(review.text),
            if (review.photoUrl != null && review.photoUrl!.isNotEmpty) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  review.photoUrl!,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
