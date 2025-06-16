import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/cart_model.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/profile_model.dart';
import '../models/address_model.dart';
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

  Future<bool> createOrder(
      CartModel cart,
      ProfileModel profile,
      String deliveryType, {
      AddressModel? address,
      String payment = '',
    }) async {
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
      'status': 'active',
      'delivery_type': deliveryType,
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

      final pickup = deliveryType == 'pickup';

      final order = Order(
        id: orderNumber.toString(),
        orderNumber: orderNumber is int ? orderNumber : int.tryParse(orderNumber.toString()) ?? 0,
        date: DateTime.tryParse(response['created_at']?.toString() ?? '') ?? DateTime.now(),
        items: cart.items
            .map((e) => CartItem(dish: e.dish, variant: e.variant, quantity: e.quantity))
            .toList(),
        total: cart.total,
        name: profile.name,
        phone: profile.phone,
        city: 'Новороссийск',
        district: '',
        street: pickup ? 'Коммунистическая' : (address?.street ?? ''),
        house: pickup ? '51' : (address?.house ?? ''),
        flat: pickup ? '' : (address?.flat ?? ''),
        floor: pickup ? '' : (address?.floor ?? ''),
        intercom: pickup ? '' : (address?.code ?? ''),
        comment: '',
        payment: payment,
        leaveAtDoor: false,
        pickup: pickup,
      );

      await TelegramService.sendOrderToTelegram(order);
      return true;
    } catch (e) {
      debugPrint('Ошибка создания заказа: $e');
      return false;
    }
  }

  /// Cancels the given [order] and notifies Telegram.
  Future<bool> cancelOrder(Order order) async {
    try {
      await _client
          .from('orders')
          .update({'status': 'cancelled'})
          .eq('id', order.id);
      await TelegramService.sendOrder(
          '🚫 Заказ №${order.id} был отменён пользователем.');
      return true;
    } catch (e) {
      debugPrint('Ошибка отмены заказа: $e');
      return false;
    }
  }
}
