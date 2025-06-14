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

  /// Sends an [Order] details to the configured Telegram chat.
  static Future<void> sendOrderToTelegram(Order order) async {
    if (!kEnableTelegramOrderForwarding) return;
    if (_token.isEmpty || _chatId.isEmpty) {
      debugPrint('Telegram token or chat id is not set');
      return;
    }

    final addressText = [
      'г. ${order.city}',
      'ул. ${order.street}',
      'д. ${order.house}',
      if (order.flat.isNotEmpty) 'кв. ${order.flat}',
      if (order.floor.isNotEmpty) 'этаж ${order.floor}',
      if (order.intercom.isNotEmpty) 'домофон ${order.intercom}',
    ].join(', ');

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
            '• ${e.dish.name} ${e.variant.title} x${e.quantity} — ${e.variant.price} ₽')
        .join('\n');

    final message = '''📦 *Новый заказ!* 
🧍 Клиент: ${order.name}
📞 Телефон: ${order.phone}
🏠 Адрес: $addressText
💳 Оплата: $paymentText
🚚 Доставка: ${order.pickup ? 'Самовывоз' : 'Доставка'}
📝 Комментарий: ${order.comment}
🍽️ Заказ:
$itemsText
💰 Сумма: ${order.total} ₽
⏰ Время: ${DateFormat('dd.MM.yyyy HH:mm').format(order.date)}''';

    debugPrint('Telegram order message: $message');

    await sendOrder(message);
  }
}
