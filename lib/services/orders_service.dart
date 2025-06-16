import 'package:supabase_flutter/supabase_flutter.dart';

class OrdersService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getOrders() async {
    final response = await supabase
        .from('orders')
        .select()
        .order('date', ascending: false);

    if (response == null) {
      throw Exception('Не удалось получить заказы');
    }

    return List<Map<String, dynamic>>.from(response);
  }
}
