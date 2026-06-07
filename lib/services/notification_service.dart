import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'auth_service.dart';

class NotificationService {
  static Future<List<dynamic>> getNotifications() async {
    final token = await AuthService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No login token found.');
    }

    final url = Uri.parse('${ApiConfig.baseUrl}/notifications/');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data.toString());
  }
}