import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  ApiService._();

  static const String baseUrl = 'https://example.com/api';

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final uri = Uri.parse('\$baseUrl/login');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw ApiException(
      'Login failed. Please check your credentials and try again.',
      statusCode: response.statusCode,
      responseBody: response.body,
    );
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  final String responseBody;

  ApiException(this.message,
      {this.statusCode = -1, this.responseBody = ''});

  @override
  String toString() => 'ApiException(\$statusCode): \$message';
}
