import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/review.dart';
import '../../services/reviews_service.dart';
import '../../widgets/reviews/review_card.dart';
import '../../widgets/reviews/review_form_modal.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen>
    with SingleTickerProviderStateMixin {
  final _service = ReviewsService();
  late TabController _controller;
  List<Review> _all = [];
  List<Review> _mine = [];
  bool _loadingAll = true;
  bool _loadingMine = true;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    _loadAll();
    _loadMine();
  }

  Future<void> _loadAll() async {
    final list = await _service.fetchReviews();
    if (mounted) {
      setState(() {
        _all = list;
        _loadingAll = false;
      });
    }
  }

  Future<void> _loadMine() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      setState(() => _loadingMine = false);
      return;
    }
    final list = await _service.fetchReviews(userId: userId);
    if (mounted) {
      setState(() {
        _mine = list;
        _loadingMine = false;
      });
    }
  }

  void _openForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ReviewFormModal(
        onSubmitted: () {
          _loadAll();
          _loadMine();
        },
      ),
    );
  }

  void _showReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Пожаловаться'),
        content: const Text('Вы действительно хотите пожаловаться на этот отзыв?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('Пожаловаться'),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<Review> items, bool loading, bool authorized) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!authorized && items.isEmpty) {
      return const Center(child: Text('Вы не вошли в аккаунт'));
    }
    if (items.isEmpty) {
      return const Center(child: Text('Нет отзывов'));
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (_, i) {
        final r = items[i];
        return ReviewCard(
          review: r,
          onReport: () {
            Navigator.popUntil(context, (route) => route.isFirst);
            _showReport();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authorized = Supabase.instance.client.auth.currentUser != null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Отзывы'),
        bottom: TabBar(
          controller: _controller,
          tabs: const [Tab(text: 'Все отзывы'), Tab(text: 'Мои отзывы')],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _openForm,
                  child: const Text(
                    'Написать отзыв',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(child: _buildList(_all, _loadingAll, true)),
            ],
          ),
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _openForm,
                  child: const Text(
                    'Написать отзыв',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(child: _buildList(_mine, _loadingMine, authorized)),
            ],
          ),
        ],
      ),
    );
  }
}
