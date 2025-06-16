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
      'user_id': profile.isGuest ? null : profile.id,
      'total': cart.total,
      'items': cart.toJson(),
      'created_at': DateTime.now().toIso8601String(),
      'status': 'active'
    };

    final response = await _client
        .from('orders')
        .insert(orderData)
        .select()
        .single();

    if (response == null || response['id'] == null) {
      // print("Ошибка создания заказа: ${response.toString()}"); // [removed for production]
      return false;
    }

    final orderNumber = response['order_number'];

    if (!profile.isGuest) {
      await http.post(
        Uri.parse('https://your-server.com/telegram-webhook'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'text': '🆕 Новый заказ №$orderNumber\n${jsonEncode(orderData)}'
        }),
      );
    }

    return true;
  }
}
