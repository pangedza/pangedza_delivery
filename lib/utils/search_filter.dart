import '../models/category.dart';

/// Filters categories by dish name query.
List<Category> filterCategories(List<Category> categories, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return categories;
  final result = <Category>[];
  for (final c in categories) {
    final dishes =
        c.dishes.where((d) => d.name.toLowerCase().contains(q)).toList();
    if (dishes.isNotEmpty) {
      result.add(Category(name: c.name, dishes: dishes, sortOrder: c.sortOrder));
    }
  }
  return result;
}
