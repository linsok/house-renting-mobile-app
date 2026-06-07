import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'auth_service.dart';

class RequestService {
  static Future<Map<String, dynamic>> createVisitRequest({
    required int propertyId,
    required String fullName,
    required String phone,
    required String email,
    required String preferredDate,
    required String preferredTime,
    required String message,
  }) async {
    final token = await AuthService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No login token found.');
    }

    final url = Uri.parse('${ApiConfig.baseUrl}/visit-requests/');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'property': propertyId,
        'full_name': fullName,
        'phone': phone,
        'email': email,
        'preferred_date': preferredDate,
        'preferred_time': preferredTime,
        'message': message,
      }),
    );

    print('VISIT STATUS: ${response.statusCode}');
    print('VISIT BODY: ${response.body}');

    final data = _decodeResponse(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    }

    throw Exception(data.toString());
  }

  static Future<Map<String, dynamic>> createRentRequest({
    required int propertyId,
    required String fullName,
    required String phone,
    required String email,
    required String moveInDate,
    required int rentalDurationMonths,
    required String message,
  }) async {
    final token = await AuthService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No login token found.');
    }

    final url = Uri.parse('${ApiConfig.baseUrl}/rent-requests/');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'property': propertyId,
        'full_name': fullName,
        'phone': phone,
        'email': email,
        'move_in_date': moveInDate,
        'rental_duration_months': rentalDurationMonths,
        'message': message,
      }),
    );

    print('RENT STATUS: ${response.statusCode}');
    print('RENT BODY: ${response.body}');

    final data = _decodeResponse(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    }

    throw Exception(data.toString());
  }

  static Map<String, dynamic> _decodeResponse(String body) {
    try {
      final decoded = jsonDecode(body);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      return {
        'detail': decoded.toString(),
      };
    } catch (_) {
      return {
        'detail': 'Server returned non-JSON response.',
        'body': body,
      };
    }
  }
}