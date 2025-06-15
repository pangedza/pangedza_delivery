import 'package:flutter/material.dart';
import '../models/review_model.dart';
import '../models/legacy_review.dart';
import '../widgets/app_drawer.dart';

class LegacyReviewsScreen extends StatefulWidget {
  const LegacyReviewsScreen({super.key});

  @override
  State<LegacyReviewsScreen> createState() => _LegacyReviewsScreenState();
}

class _LegacyReviewsScreenState extends State<LegacyReviewsScreen>
    with SingleTickerProviderStateMixin {
  final ReviewModel model = ReviewModel.instance;
  final TextEditingController _textController = TextEditingController();
  final List<String> dishes = [
    'Жареный рай',
    'Острые ощущения',
    'Том Ям с морепродуктами и рисом'
  ];
  String? _selectedDish;
  int _stars = 5;
  String? _emoji;
  final List<String> emojis = ['🔥', '😍', '🤤', '🤮', '😐'];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_selectedDish == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Выберите блюдо')));
      return;
    }
    final review = LegacyReview(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: currentUserId,
      dishId: _selectedDish!,
      stars: _stars,
      text: _textController.text.isEmpty ? null : _textController.text,
      emoji: _emoji,
      createdAt: DateTime.now(),
    );
    model.addReview(review);
    setState(() {
      _selectedDish = null;
      _stars = 5;
      _textController.clear();
      _emoji = null;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Отзыв отправлен')));
  }

  Widget _buildStarPicker() {
    return Row(
      children: List.generate(5, (index) {
        final filled = index < _stars;
        return IconButton(
          icon: Icon(
            filled ? Icons.star : Icons.star_border,
            color: Colors.orange,
          ),
          onPressed: () => setState(() => _stars = index + 1),
        );
      }),
    );
  }

  Widget _buildLeaveTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          DropdownButtonFormField<String>(
            value: _selectedDish,
            decoration: const InputDecoration(labelText: 'Блюдо'),
            items: dishes
                .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                .toList(),
            onChanged: (v) => setState(() => _selectedDish = v),
          ),
          const SizedBox(height: 16),
          _buildStarPicker(),
          TextField(
            controller: _textController,
            maxLength: 200,
            decoration: const InputDecoration(labelText: 'Комментарий'),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: emojis
                .map((e) => ChoiceChip(
                      label: Text(e, style: const TextStyle(fontSize: 20)),
                      selected: _emoji == e,
                      onSelected: (_) => setState(() => _emoji = e),
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.gif_box),
            label: const Text('GIF'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Отправить'),
          ),
        ],
      ),
    );
  }

  Widget _buildMyReviews() {
    final reviews = model.reviews
        .where((r) => r.userId == currentUserId)
        .toList();
    if (reviews.isEmpty) {
      return const Center(child: Text('Нет отзывов'));
    }
    return ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (_, index) {
        final review = reviews[index];
        return _buildReviewCard(review, canEdit: true);
      },
    );
  }

  Widget _buildDishReviews() {
    final reviews = model.reviews.where((r) => !r.hidden).toList();
    if (reviews.isEmpty) {
      return const Center(child: Text('Отзывы отсутствуют'));
    }
    return ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (_, index) => _buildReviewCard(reviews[index]),
    );
  }

  Widget _buildReviewCard(LegacyReview review, {bool canEdit = false}) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(review.dishId, style: const TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: List.generate(
                review.stars,
                (i) => const Icon(Icons.star, color: Colors.orange, size: 16),
              ),
            ),
            if (review.text != null) Text(review.text!),
            if (review.emoji != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(review.emoji!, style: const TextStyle(fontSize: 20)),
              ),
            if (canEdit)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => model.deleteReview(review),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Оставить'),
              Tab(text: 'Мои'),
              Tab(text: 'О блюдах'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildLeaveTab(),
            AnimatedBuilder(
              animation: model,
              builder: (_, __) => _buildMyReviews(),
            ),
            AnimatedBuilder(
              animation: model,
              builder: (_, __) => _buildDishReviews(),
            ),
          ],
        ),
      ),
    );
  }
}
