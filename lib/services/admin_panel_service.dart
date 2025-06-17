import 'dart:convert';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/order.dart';

class AdminPanelService {
  static const _url = 'http://localhost:8000/api/orders/';

  /// Sends order details to local admin panel.
  static Future<void> sendOrderToAdmin(Order order) async {
    final payload = {
      'order_id': const Uuid().v4(),
      'guest_name': order.name,
      'items': order.items
          .map((e) => {
                'name': e.dish.name,
                'quantity': e.quantity,
              })
          .toList(),
      'total_price': order.total,
      'status': 'active',
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    };
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Content-Type': 'application/json',
          // Use a simplified User-Agent on Windows to prevent header parsing
          // errors caused by non-ASCII characters.
          'User-Agent': 'flutter-${Platform.operatingSystem}',
        },
        body: jsonEncode(payload),
      );
      debugPrint('Admin panel response: ${response.statusCode}');
    } catch (e) {
      debugPrint('Error sending to admin panel: $e');
    }
  }
}
