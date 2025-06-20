import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:excel/excel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Utility that loads the full menu from an Excel file and uploads it to Supabase.
class MenuLoader {
  MenuLoader._();

  /// Loads menu data from the bundled Excel file into Supabase when running
  /// in debug mode and when the categories table is empty.
  static Future<void> loadIfNeeded() async {
    if (!kDebugMode) return;
    final client = Supabase.instance.client;
    try {
      final existing = await client.from('categories').select('id').limit(1);
      if (existing.isNotEmpty) return;
    } catch (_) {
      // ignore errors
    }
    await _importExcel(client);
  }

  static Future<void> _importExcel(SupabaseClient client) async {
    final bytes = await rootBundle.load(
      'assets/data/pangedza_menu_full_template (3).xlsx',
    );
    final excel = Excel.decodeBytes(bytes.buffer.asUint8List());
    if (excel.tables.isEmpty) return;
    final sheet = excel.tables.values.first;

    final Map<String, String> categories = {};
    int sortOrder = 0;

    // preload existing categories
    try {
      final data = await client.from('categories').select('id, name');
      for (final row in data) {
        categories[row['name'] as String] = row['id'].toString();
      }
      sortOrder = categories.length;
    } catch (_) {}

    // preload existing dishes to avoid duplicates
    final Set<String> dishNames = {};
    try {
      final list = await client.from('dishes').select('name');
      for (final r in list) {
        dishNames.add(r['name'] as String);
      }
    } catch (_) {}

    for (var i = 1; i < sheet.maxRows; i++) {
      final row = sheet.row(i);
      if (row.isEmpty) continue;
      final category = row[0]?.value.toString().trim();
      final title = row[1]?.value.toString().trim();
      final weight = row[2]?.value.toString().trim();
      final price = int.tryParse(row[3]?.value.toString() ?? '') ?? 0;
      final description =
          row.length > 4 ? row[4]?.value.toString().trim() : null;
      if (category == null ||
          category.isEmpty ||
          title == null ||
          title.isEmpty) {
        continue;
      }
      var categoryId = categories[category];
      if (categoryId == null) {
        final inserted = await client
            .from('categories')
            .insert({'name': category, 'sort_order': sortOrder})
            .select('id')
            .single();
        categoryId = inserted['id'].toString();
        categories[category] = categoryId;
        sortOrder++;
      }
      if (dishNames.contains(title)) continue;
      await client.from('dishes').insert({
        'name': title,
        'weight': weight,
        'price': price,
        'description': description,
        'category_id': categoryId,
      });
      dishNames.add(title);
    }
  }
}
