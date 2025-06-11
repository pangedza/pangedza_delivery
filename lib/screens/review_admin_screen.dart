import 'package:flutter/material.dart';
import '../models/review_model.dart';
import '../models/profile_model.dart';
import '../widgets/app_drawer.dart';

class ReviewAdminScreen extends StatefulWidget {
  ReviewAdminScreen({super.key});

  final ReviewModel model = ReviewModel.instance;

  @override
  State<ReviewAdminScreen> createState() => _ReviewAdminScreenState();
}

class _ReviewAdminScreenState extends State<ReviewAdminScreen> {
  final profile = ProfileModel.instance;

  @override
  void initState() {
    super.initState();
    profile.addListener(_onProfileChange);
    profile.load();
  }

  @override
  void dispose() {
    profile.removeListener(_onProfileChange);
    super.dispose();
  }

  void _onProfileChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    if (profile.role != 'admin') {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Нет доступа'),
        ),
        body: const Center(child: Text('У вас нет прав доступа.')),
      );
    }

    final model = widget.model;

    return Scaffold(
      drawer: const MyAppDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('Админ: отзывы'),
      ),
      body: AnimatedBuilder(
        animation: model,
        builder: (_, __) {
          if (model.reviews.isEmpty) {
            return const Center(child: Text('Нет отзывов'));
          }
          return ListView.builder(
            itemCount: model.reviews.length,
            itemBuilder: (_, index) {
              final review = model.reviews[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text('${review.dishId} (${review.stars}★)'),
                  subtitle: review.text != null ? Text(review.text!) : null,
                  trailing: Switch(
                    value: !review.hidden,
                    onChanged: (_) => model.toggleHidden(review),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
