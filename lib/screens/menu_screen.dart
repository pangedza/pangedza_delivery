import 'package:flutter/material.dart';

import '../models/menu_loader.dart';
import '../widgets/dish_card.dart';
import '../widgets/noodle_builder_bottom_sheet.dart';

/// Menu screen with category navigation and a 2x2 grid of dishes.
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final ScrollController _listController = ScrollController();
  final ScrollController _categoryController = ScrollController();

  static const double _categoryBarHeight = 56;

  int _activeCategory = 0;
  late List<GlobalKey> _categoryKeys;
  late List<GlobalKey> _buttonKeys;

  @override
  void dispose() {
    _listController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _openBuilder(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const NoodleBuilderBottomSheet(),
    );
  }

  void _scrollToCategory(int index) {
    final ctx = _categoryKeys[index].currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 300),
        alignment: 0.1,
        curve: Curves.easeInOut,
      );
      _centerCategoryButton(index);
    }
  }

  void _centerCategoryButton(int index) {
    final ctx = _buttonKeys[index].currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 300),
        alignment: 0.5,
        curve: Curves.easeInOut,
      );
    }
  }

  void _onScroll() {
    int newIndex = _activeCategory;
    double minDiff = double.infinity;
    for (var i = 0; i < _categoryKeys.length; i++) {
      final ctx = _categoryKeys[i].currentContext;
      if (ctx != null) {
        final box = ctx.findRenderObject() as RenderBox;
        final pos = box.localToGlobal(Offset.zero).dy;
        final diff = pos.abs();
        if (diff < minDiff) {
          minDiff = diff;
          newIndex = i;
        }
      }
    }
    if (newIndex != _activeCategory) {
      setState(() => _activeCategory = newIndex);
      _centerCategoryButton(newIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadMenu(context),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final categories = snapshot.data!;
        _categoryKeys = List.generate(categories.length, (_) => GlobalKey());
        _buttonKeys = List.generate(categories.length, (_) => GlobalKey());
        _listController.removeListener(_onScroll);
        _listController.addListener(_onScroll);
        return Stack(
          children: [
            ListView(
              controller: _listController,
              padding: EdgeInsets.fromLTRB(
                16,
                _categoryBarHeight + 16,
                16,
                16,
              ),
              children: [
                Card(
                  child: ListTile(
                    title: const Text('Собери лапшу сам'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _openBuilder(context),
                  ),
                ),
                const SizedBox(height: 16),
                for (var i = 0; i < categories.length; i++)
                  Container(
                    key: _categoryKeys[i],
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          categories[i].name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 2.4,
                          ),
                          itemCount: categories[i].dishes.length,
                          itemBuilder: (_, index) =>
                              DishCard(dish: categories[i].dishes[index]),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                height: _categoryBarHeight,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SingleChildScrollView(
                  controller: _categoryController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var i = 0; i < categories.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: TextButton(
                            key: _buttonKeys[i],
                            onPressed: () {
                              setState(() => _activeCategory = i);
                              _scrollToCategory(i);
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: _activeCategory == i
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade200,
                              foregroundColor: _activeCategory == i
                                  ? Colors.white
                                  : Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(categories[i].name),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
