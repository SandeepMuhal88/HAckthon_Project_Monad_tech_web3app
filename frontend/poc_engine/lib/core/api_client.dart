import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

class ApiClient {
  static Future<Map<String, dynamic>> get(String path) async {
    final res = await http.get(Uri.parse('${AppConfig.apiBaseUrl}$path'));
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final res = await http.post(
      Uri.parse('${AppConfig.apiBaseUrl}$path'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return jsonDecode(res.body);
  }
}
