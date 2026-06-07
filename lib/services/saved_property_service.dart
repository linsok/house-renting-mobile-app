import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/property.dart';
import 'api_config.dart';
import 'auth_service.dart';

class SavedPropertyItem {
  final int savedId;
  final Property property;
  final String createdAt;

  SavedPropertyItem({
    required this.savedId,
    required this.property,
    required this.createdAt,
  });

  factory SavedPropertyItem.fromJson(Map<String, dynamic> json) {
    final propertyData = json['property_detail'] ?? json['property'] ?? {};

    return SavedPropertyItem(
      savedId: json['id'] ?? 0,
      property: Property.fromJson(propertyData),
      createdAt: (json['created_at'] ?? '').toString(),
    );
  }
}

class SavedPropertyService {
  static Future<List<SavedPropertyItem>> getSavedProperties() async {
    final token = await AuthService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No login token found.');
    }

    final url = Uri.parse('${ApiConfig.baseUrl}/saved-properties/');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data is List) {
        return data
            .map((item) => SavedPropertyItem.fromJson(item))
            .toList();
      }

      if (data is Map && data['results'] is List) {
        return (data['results'] as List)
            .map((item) => SavedPropertyItem.fromJson(item))
            .toList();
      }

      return [];
    }

    throw Exception(data.toString());
  }

  static Future<void> saveProperty(int propertyId) async {
    final token = await AuthService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No login token found.');
    }

    final url = Uri.parse('${ApiConfig.baseUrl}/saved-properties/');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'property': propertyId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    }

    try {
      final data = jsonDecode(response.body);
      throw Exception(data.toString());
    } catch (_) {
      throw Exception(
        'Server returned HTML instead of JSON. Check API URL: $url',
      );
    }
  }

  static Future<void> removeSavedProperty(int savedPropertyId) async {
    final token = await AuthService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No login token found.');
    }

    final url = Uri.parse(
      '${ApiConfig.baseUrl}/saved-properties/$savedPropertyId/',
    );

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200 ||
        response.statusCode == 204 ||
        response.statusCode == 404) {
      return;
    }

    final data = jsonDecode(response.body);
    throw Exception(data.toString());
  }
}