import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/property.dart';
import 'api_config.dart';

class PropertyService {
  static Future<List<Property>> getProperties() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/properties/');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data is List) {
        return data.map((item) => Property.fromJson(item)).toList();
      }

      if (data is Map && data['results'] is List) {
        return (data['results'] as List)
            .map((item) => Property.fromJson(item))
            .toList();
      }

      return [];
    }

    throw Exception(data.toString());
  }
}