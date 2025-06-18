import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';
import '../../models/review.dart';
import '../../widgets/reviews/review_card.dart';
import '../../widgets/reviews/review_form_modal.dart';
import '../../widgets/reviews/review_form.dart';
import '../../widgets/reviews/report_review_dialog.dart';
import '../../services/reviews_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen>
    with SingleTickerProviderStateMixin {
  final List<Review> _allReviews = [];
  final List<Review> _myReviews = [];
  bool _loadingAll = true;
  bool _loadingMy = false;
  bool _myLoaded = false;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(_onTabChanged);
    _loadAll();
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.index == 1 && !_myLoaded) {
      _loadMy();
    }
  }

  Future<void> _loadAll() async {
    final res = await ReviewsService().getAllReviews();
    if (!mounted) return;
    setState(() {
      _allReviews
        ..clear()
        ..addAll(res);
      _loadingAll = false;
    });
  }

  Future<void> _loadMy() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      setState(() {
        _loadingMy = false;
        _myLoaded = true;
      });
      return;
    }
    setState(() => _loadingMy = true);
    final res = await ReviewsService().getUserReviews(userId);
    if (!mounted) return;
    setState(() {
      _myReviews
        ..clear()
        ..addAll(res);
      _loadingMy = false;
      _myLoaded = true;
    });
  }

  Future<void> _addReview(Review review, Uint8List? image) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      // debug print before saving review
      print('Отправляем отзыв: ${review.toMap()}');
      await ReviewsService().addReview(review, userId, photo: image);
      await _loadAll();
      if (_myLoaded) await _loadMy();
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Спасибо! Отзыв добавлен')));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Сначала нужно авторизоваться')));
      }
    }
  }

  Future<void> _editReview(Review review) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ReviewFormModal(
        review: review,
        onSubmit: (r) async {
          final user = Supabase.instance.client.auth.currentUser;
          if (user != null) {
            print('Отправляем отзыв: ${r.toMap()}');
            await ReviewsService().addReview(r, user.id, photo: null);
            if (context.mounted) Navigator.pop(context, r);
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Сначала нужно авторизоваться')));
            }
          }
        },
      ),
    );
    await _loadAll();
    if (_myLoaded) await _loadMy();
  }

  Future<void> _deleteReview(Review review) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Удалить отзыв?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
    if (res == true) {
      await ReviewsService().deleteReview(review.id);
      await _loadAll();
      if (_myLoaded) await _loadMy();
    }
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildMyCard(Review review) {
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
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editReview(review),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteReview(review),
                ),
              ],
            ),
            Row(
              children: [
                Row(
                  children: List.generate(
                    review.rating,
                    (i) => const Icon(
                      Icons.star,
                      color: Colors.orange,
                      size: 16,
                    ),
                  ),
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
    final sortedAll = List<Review>.from(_allReviews)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final sortedMy = List<Review>.from(_myReviews)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: const MyAppDrawer(),
        appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: const Text('Отзывы'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Все отзывы'),
              Tab(text: 'Мои отзывы'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _loadingAll
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: sortedAll.length + 1,
                    itemBuilder: (context, i) {
                      if (i == 0) {
                        return ReviewForm(onSubmit: _addReview);
                      }
                      final review = sortedAll[i - 1];
                      return ReviewCard(
                        review: review,
                        onReport: () => _report(review),
                      );
                    },
                  ),
            _loadingMy
                ? const Center(child: CircularProgressIndicator())
                : sortedMy.isEmpty
                    ? const Center(child: Text('Вы пока не оставили отзывов'))
                    : ListView.builder(
                        itemCount: sortedMy.length,
                        itemBuilder: (context, i) => _buildMyCard(sortedMy[i]),
                      ),
          ],
        ),
      ),
    );
  }
}
