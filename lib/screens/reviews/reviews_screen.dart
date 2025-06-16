import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';
import '../../models/review.dart';
import '../../widgets/reviews/review_card.dart';
import '../../widgets/reviews/review_form_modal.dart';
import '../../widgets/reviews/report_review_dialog.dart';
import 'my_reviews_screen.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final List<Review> _reviews = [
    Review(
      id: '1',
      userName: 'Ирина',
      text: 'Очень вкусно и быстро!',
      isPositive: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    Review(
      id: '2',
      userName: 'Дмитрий',
      text: 'Доставка задержалась на 30 минут.',
      isPositive: false,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  void _openForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ReviewFormModal(onSubmit: _addReview),
    );
  }

  void _addReview(Review review) {
    setState(() {
      _reviews.insert(0, review);
    });
    Navigator.pop(context);
  }

  void _report(Review review) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (_) => const ReportReviewDialog(),
    );
    if (!context.mounted) return;
    if (res == true) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Жалоба отправлена')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final sorted = List<Review>.from(_reviews)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Scaffold(
      drawer: const MyAppDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('Все отзывы'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MyReviewsScreen(reviews: _reviews),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: sorted.length,
        itemBuilder: (context, i) => ReviewCard(
          review: sorted[i],
          onReport: () => _report(sorted[i]),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE30613),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: _openForm,
            child: const Text('Написать отзыв'),
          ),
        ),
      ),
    );
  }
}
