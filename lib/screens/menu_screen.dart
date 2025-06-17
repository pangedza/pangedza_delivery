import 'dart:async';
import 'package:flutter/material.dart';

import '../models/cart_model.dart';
import '../models/category.dart';
import '../models/dish.dart';
import '../screens/cart_screen.dart';
import '../widgets/dish_add_modal.dart';
import '../services/api_service.dart';
import '../services/dish_service.dart';
import '../widgets/dish_card.dart';
import '../widgets/app_drawer.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final CartModel cart = CartModel.instance;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _categoryController = ScrollController();

  List<Category> _categories = [];
  final Map<String, List<Dish>> _dishesByCategory = {};
  int _activeCategory = 0;
  bool _loadingCategories = true;
  bool _loadingDishes = false;
  Timer? _debounce;
  List<String> stopList = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    cart.addListener(_cartUpdate);
    _loadInitial();
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _debounce?.cancel();
    _searchController.dispose();
    cart.removeListener(_cartUpdate);
    super.dispose();
  }

  void _cartUpdate() => setState(() {});

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () => setState(() {}));
  }

  Future<void> _loadInitial() async {
    await loadStopList();
    final cats = await DishService().fetchCategories();
    final categories = cats.where((c) => c.name.trim().isNotEmpty).toList();
    if (!mounted) return;
    setState(() {
      _categories = categories;
      _loadingCategories = false;
    });
    if (categories.isNotEmpty) {
      await _loadDishes(categories.first.id);
    }
  }

  Future<void> _loadDishes(String categoryId) async {
    setState(() => _loadingDishes = true);
    final dishes = await DishService().fetchDishes(categoryId);
    if (!mounted) return;
    setState(() {
      _dishesByCategory[categoryId] = dishes;
      _loadingDishes = false;
    });
  }

  Future<void> loadStopList() async {
    try {
      final data = await ApiService.fetchStopList();
      if (!mounted) return;
      setState(() {
        stopList = data.map<String>((item) => item['name'] as String).toList();
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();

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
      body: _loadingCategories
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Найти',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () => _searchController.clear(),
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
                  height: 56,
                  child: ListView.builder(
                    controller: _categoryController,
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (_, index) {
                      final c = _categories[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: TextButton(
                          onPressed: () async {
                            setState(() => _activeCategory = index);
                            if (!_dishesByCategory.containsKey(c.id)) {
                              await _loadDishes(c.id);
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: _activeCategory == index
                                ? Theme.of(context).primaryColor
                                : Colors.grey.shade200,
                            foregroundColor: _activeCategory == index
                                ? Colors.white
                                : Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(c.name),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: _loadingDishes
                      ? const Center(child: CircularProgressIndicator())
                      : _buildDishGrid(query),
                ),
              ],
            ),
      bottomNavigationBar: cart.items.isNotEmpty
          ? Padding(
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
            )
          : null,
    );
  }

  Widget _buildDishGrid(String query) {
    if (_categories.isEmpty) return const SizedBox.shrink();
    final current = _categories[_activeCategory];
    final dishes = _dishesByCategory[current.id] ?? [];
    final filtered = dishes
        .where((d) => !stopList.contains(d.name))
        .where((d) => query.isEmpty
            ? true
            : d.name.toLowerCase().contains(query))
        .toList();

    if (filtered.isEmpty) {
      return const Center(child: Text('Блюдо не найдено'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.8,
      ),
      itemCount: filtered.length,
      itemBuilder: (_, index) {
        final dish = filtered[index];
        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => DishAddModal(dish: dish),
            );
          },
          child: DishCard(dish: dish),
        );
      },
    );
  }
}
