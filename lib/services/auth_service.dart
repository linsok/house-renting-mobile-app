import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'api_config.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _fullNameKey = 'full_name';
  static const String _emailKey = 'email';

  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/register/');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      await _saveAuthData(data);
      return data;
    }

    throw Exception(data.toString());
  }

  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/login/');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': username,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      await _saveAuthData(data);
      return data;
    }

    throw Exception(data.toString());
  }

  static Future<Map<String, dynamic>> me() async {
    final token = await getToken();

    if (token == null) {
      throw Exception('No token found.');
    }

    final url = Uri.parse('${ApiConfig.baseUrl}/me/');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Token $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data.toString());
  }

  static Future<void> _saveAuthData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_tokenKey, data['token'] ?? '');
    await prefs.setInt(_userIdKey, data['user_id'] ?? data['id'] ?? 0);
    await prefs.setString(_fullNameKey, data['full_name'] ?? '');
    await prefs.setString(_emailKey, data['email'] ?? '');
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_fullNameKey);
    await prefs.remove(_emailKey);
  }
}