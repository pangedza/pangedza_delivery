import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../config.dart';
import '../models/order.dart';

class TelegramService {
  static String get _token => dotenv.env['TELEGRAM_BOT_TOKEN'] ?? '';
  static String get _chatId => dotenv.env['TELEGRAM_CHAT_ID'] ?? '';

  static Future<void> sendOrder(String message) async {
    if (!kEnableTelegramOrderForwarding) return;
    if (_token.isEmpty || _chatId.isEmpty) {
      debugPrint('Telegram token or chat id is not set');
      return;
    }
    final url = Uri.parse('https://api.telegram.org/bot$_token/sendMessage');
    debugPrint('Sending order to Telegram: $message');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'chat_id': _chatId,
          'text': message,
          'parse_mode': 'Markdown',
        }),
      );
      debugPrint(
          'Telegram response: ${response.statusCode} ${response.body}');
      if (response.statusCode != 200) {
        debugPrint('Telegram error: ${response.body}');
      }
    } catch (e) {
      debugPrint('Ошибка отправки в Telegram: $e');
    }
  }

  /// Builds a full address string for Telegram from non-empty [order] fields.
  static String buildFullAddress(Order order) {
    final parts = <String>[];
    if (order.city.isNotEmpty) parts.add('г. ${order.city}');
    if (order.street.isNotEmpty) parts.add('ул. ${order.street}');
    if (order.house.isNotEmpty) parts.add('д. ${order.house}');
    if (order.flat.isNotEmpty) parts.add('кв. ${order.flat}');
    if (order.intercom.isNotEmpty) parts.add('подъезд ${order.intercom}');
    if (order.floor.isNotEmpty) parts.add('этаж ${order.floor}');
    return parts.join(', ');
  }

  static String buildTelegramMessage(Order order) {
    final addressText = buildFullAddress(order);

    String paymentText;
    switch (order.payment) {
      case 'cash':
        paymentText = 'Наличные';
        break;
      case 'terminal':
        paymentText = order.pickup ? 'Карта' : 'Карта курьеру';
        break;
      case 'online':
        paymentText = 'Онлайн-оплата';
        break;
      default:
        paymentText = order.payment;
    }

    final itemsText = order.items
        .map((e) =>
            '• ${e.dish.name} ${e.variant.title} ×${e.quantity} — ${e.variant.price} ₽')
        .join('\n');

    final buffer = StringBuffer()
      ..writeln('📦 Новый заказ!')
      ..writeln('📄 Номер заказа: ${order.id}')
      ..writeln('👤 Клиент: ${order.name}')
      ..writeln('📞 Телефон: ${order.phone}');

    if (order.pickup) {
      buffer
        ..writeln('💰 Оплата: $paymentText')
        ..writeln('🚶 Доставка: Самовывоз');
    } else {
      buffer
        ..writeln('🏠 Адрес: $addressText')
        ..writeln('💰 Оплата: $paymentText')
        ..writeln('🚚 Доставка: Курьер');
    }

    buffer
      ..writeln('🧾 Заказ:')
      ..writeln(itemsText)
      ..writeln('💵 Сумма: ${order.total} ₽');

    if (order.comment.isNotEmpty) {
      buffer.writeln('📝 Комментарий: ${order.comment}');
    }

    buffer.writeln('⏰ Время: ${DateFormat('yyyy-MM-dd HH:mm').format(order.date)}');
    return buffer.toString();
  }

  /// Sends an [Order] details to the configured Telegram chat.
  static Future<void> sendOrderToTelegram(Order order) async {
    if (!kEnableTelegramOrderForwarding) return;
    if (_token.isEmpty || _chatId.isEmpty) {
      debugPrint('Telegram token or chat id is not set');
      return;
    }

    final message = buildTelegramMessage(order);
    debugPrint('Telegram order message: $message');
    await sendOrder(message);
  }
}
