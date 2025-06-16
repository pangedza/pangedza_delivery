import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/cart_model.dart';
import '../models/profile_model.dart';
import 'telegram_service.dart';

class OrdersService {
  final _client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getOrders(String userId) async {
    final response = await _client
        .from('orders')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<bool> createOrder(CartModel cart, ProfileModel profile) async {
    final userId = profile.id;
    if (userId == null) {
      debugPrint('User ID is null – unable to create order');
      return false;
    }

    final orderData = {
      'user_id': userId,
      'user_name': profile.name,
      'user_phone': profile.phone,
      'total': cart.total,
      'items': cart.items.map((e) => e.toMap()).toList(),
      'created_at': DateTime.now().toIso8601String(),
      'status': 'active'
    };

    debugPrint('Creating order payload: ${jsonEncode(orderData)}');

    try {
      final response = await _client
          .from('orders')
          .insert(orderData)
          .select()
          .single();

      if (response == null || response['id'] == null) {
        debugPrint('Ошибка создания заказа: пустой ответ от сервера');
        return false;
      }

      final orderNumber = response['order_number'] ?? response['id'];
      await TelegramService.sendOrder(
        '🆕 Новый заказ №$orderNumber\n${jsonEncode(orderData)}',
      );
      return true;
    } catch (e) {
      debugPrint('Ошибка создания заказа: $e');
      return false;
    }
  }
}
