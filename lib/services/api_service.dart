import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';

  static Future<List<dynamic>> fetchStopList() async {
    final response = await http.get(Uri.parse('$baseUrl/stoplist'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load stop list');
    }
  }
}
