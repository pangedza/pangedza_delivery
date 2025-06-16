import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/cart_model.dart';
import '../models/profile_model.dart';

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

  Future<bool> createOrder(CartModel cart, ProfileModel profile) async {
    final orderData = {
      'user_id': profile.id,
      'total': cart.total,
      'items': cart.items
          .map((e) => {
                'dish': e.dish.name,
                'variant': e.variant.title,
                'price': e.variant.price,
                'quantity': e.quantity,
              })
          .toList(),
      'created_at': DateTime.now().toIso8601String(),
    };

    final response =
        await _client.from('orders').insert(orderData).execute();

    if (response.error != null) {
      print('Supabase error: ${response.error!.message}');
      return false;
    }

    // Отправка в Telegram (пример: через webhook)
    await http.post(
      Uri.parse('https://your-server.com/telegram-webhook'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'text': 'Новый заказ: ${jsonEncode(orderData)}'
      }),
    );

    return true;
  }
}
