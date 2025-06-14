import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

import '../config.dart';

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
}
