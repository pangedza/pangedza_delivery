import 'dart:convert';
import 'package:http/http.dart' as http;

class TelegramService {
  static const _token = '7595933366:AAHoRHTUz0-q-PqUvhBcp2kHYJjU9JMsjN8';
  static const _chatId = '765808288';

  static Future<void> sendOrder(String message) async {
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
