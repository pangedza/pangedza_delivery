import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for working with dishes.
class DishService {
  final _client = Supabase.instance.client;

  /// Checks if dish with [dishId] has any modifiers linked via `dish_modifiers` table.
  Future<bool> hasModifiers(String dishId) async {
    try {
      final response = await _client
          .from('dish_modifiers')
          .select('modifier_id')
          .eq('dish_id', dishId)
          .limit(1);
      if (response is List && response.isNotEmpty) {
        return true;
      }
    } catch (_) {
      // ignore errors and assume there are no modifiers
    }
    return false;
  }
}
