import 'package:supabase_flutter/supabase_flutter.dart';

class OrdersService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getOrders() async {
    final response = await supabase.from('orders').select().execute();
    if (response.error != null) {
      throw Exception('Ошибка при получении заказов: ${response.error!.message}');
    }
    return List<Map<String, dynamic>>.from(response.data);
  }
}
