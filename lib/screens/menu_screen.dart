import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../models/menu_loader.dart';
import '../models/cart_model.dart';
import '../models/category.dart';
import '../screens/cart_screen.dart';
import '../widgets/dish_card.dart';
import '../widgets/noodle_builder_bottom_sheet.dart';
import '../widgets/app_drawer.dart';

/// Menu screen with category navigation and a 2x2 grid of dishes.
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final ScrollController _listController = ScrollController();
  final ScrollController _categoryController = ScrollController();
  late final TextEditingController _searchController;
  final CartModel cart = CartModel.instance;
  Future<List<Category>>? _menuFuture;

  static const double _categoryBarHeight = 56;
  static const double _searchBarHeight = 56;
  static const double _headerHeight =
      _categoryBarHeight + _searchBarHeight + kToolbarHeight;

  int _activeCategory = 0;
  List<GlobalKey> _categoryKeys = [];
  List<GlobalKey> _buttonKeys = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() => setState(() {}));
    cart.addListener(_cartUpdate);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _menuFuture ??= loadMenu(context);
  }

  @override
  void dispose() {
    _listController.dispose();
    _categoryController.dispose();
    _searchController.dispose();
    cart.removeListener(_cartUpdate);
    super.dispose();
  }

  void _cartUpdate() => setState(() {});

  void _openBuilder(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const NoodleBuilderBottomSheet(),
    );
  }

  void _scrollToCategory(int index) {
    final ctx = _categoryKeys[index].currentContext;
    if (ctx == null || !_listController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderObject = ctx.findRenderObject();
      if (renderObject != null) {
        final viewport = RenderAbstractViewport.of(renderObject);
        final offset =
            viewport.getOffsetToReveal(renderObject, 0).offset - _headerHeight;
        _listController.animateTo(
          offset.clamp(
            _listController.position.minScrollExtent,
            _listController.position.maxScrollExtent,
          ),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
      _centerCategoryButton(index);
    });
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
        final pos = box.localToGlobal(Offset.zero).dy - _headerHeight;
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
    return Scaffold(
      drawer: const MyAppDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('Меню'),
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: _menuFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Меню пусто'));
              }
              final categories = snapshot.data!;
              if (_categoryKeys.length != categories.length) {
                _categoryKeys = List.generate(
                  categories.length,
                  (_) => GlobalKey(),
                );
                _buttonKeys = List.generate(
                  categories.length,
                  (_) => GlobalKey(),
                );
              }
              _listController.removeListener(_onScroll);
              _listController.addListener(_onScroll);
              return Stack(
                children: [
                  ListView(
                    controller: _listController,
                    padding: EdgeInsets.fromLTRB(
                      16,
                      _headerHeight + 16,
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
                              Builder(
                                builder: (_) {
                                  final filtered = categories[i].dishes
                                      .where(
                                        (d) => d.name.toLowerCase().contains(
                                          _searchController.text.toLowerCase(),
                                        ),
                                      )
                                      .toList();
                                  if (filtered.isEmpty) {
                                    return const Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text('Блюда не найдены'),
                                    );
                                  }
                                  return GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 8,
                                          crossAxisSpacing: 8,
                                          childAspectRatio: 0.8,
                                        ),
                                    itemCount: filtered.length,
                                    itemBuilder: (_, index) =>
                                        DishCard(dish: filtered[index]),
                                  );
                                },
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(32),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Найди то, что хочешь съесть',
                                  prefixIcon: const Icon(Icons.search),
                                  suffixIcon: _searchController.text.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: () {
                                            _searchController.clear();
                                          },
                                        )
                                      : null,
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: _categoryBarHeight,
                            child: SingleChildScrollView(
                              controller: _categoryController,
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  for (var i = 0; i < categories.length; i++)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
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
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                        ),
                                        child: Text(categories[i].name),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          if (cart.items.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartScreen()),
                    );
                  },
                  child: Container(
                    height: 60,
                    color: Colors.redAccent,
                    alignment: Alignment.center,
                    child: Text(
                      'В КОРЗИНЕ ${cart.itemCount} ТОВАР(ОВ) НА ${cart.totalPrice} ₽',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
