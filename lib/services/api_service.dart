<<<<<<< HEAD

=======
>>>>>>> 9261addadbfce796ef6cb1536727ddf096153b90
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = 'http://localhost:3000/api';

  static Future<List<dynamic>> fetchStopList() async {
    final response = await http.get(Uri.parse('$baseUrl/stoplist'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load stop list');
    }
  }
<<<<<<< HEAD

  static Future<void> addStopItem(String name) async {
    await http.post(
      Uri.parse('$baseUrl/stoplist'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"id": DateTime.now().millisecondsSinceEpoch, "name": name}),
    );
  }

  static Future<void> removeStopItem(int id) async {
    await http.delete(Uri.parse('$baseUrl/stoplist/$id'));
  }
=======
>>>>>>> 9261addadbfce796ef6cb1536727ddf096153b90
}
