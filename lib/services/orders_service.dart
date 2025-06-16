import 'package:supabase_flutter/supabase_flutter.dart';

class OrdersService {
  final _client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getOrders(String userId) async {
    final response = await _client
        .from('orders')
        .select()
        .eq('user_id', userId)
        .order('date', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<bool> createOrder(Map<String, dynamic> orderData) async {
    final response =
        await _client.from('orders').insert(orderData);
    if (response == null || (response is List && response.isEmpty)) {
      print('Ошибка: ответ пустой');
      return false;
    }
    print('Заказ успешно создан: $response');
    return true;
  }
}
