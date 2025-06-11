import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../config.dart';

class TelegramService {
  static String get _token => dotenv.env['TELEGRAM_BOT_TOKEN'] ?? '';
  static String get _chatId => dotenv.env['TELEGRAM_CHAT_ID'] ?? '';

  static Future<void> sendOrder(String message) async {
    if (!kEnableTelegramOrderForwarding) return;
    final url = Uri.parse('https://api.telegram.org/bot$_token/sendMessage');
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
      if (response.statusCode != 200) {
        print('Telegram error: ${response.body}');
      }
    } catch (e) {
      print('Ошибка отправки в Telegram: $e');
    }
  }
}
