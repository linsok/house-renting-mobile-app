import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'api_config.dart';
import 'auth_service.dart';

class ProfileService {
  static Future<Map<String, dynamic>> getMyProfile() async {
    final token = await AuthService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No login token found.');
    }

    final url = Uri.parse('${ApiConfig.baseUrl}/profile/');

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

  static Future<Map<String, dynamic>> updateMyProfile({
    required String phone,
    required String address,
  }) async {
    final token = await AuthService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No login token found.');
    }

    final url = Uri.parse('${ApiConfig.baseUrl}/profile/');

    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'phone': phone,
        'address': address,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data.toString());
  }

  static Future<Map<String, dynamic>> updateProfileWithImage({
    required String phone,
    required String address,
    XFile? imageFile,
  }) async {
    final token = await AuthService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No login token found.');
    }

    final url = Uri.parse('${ApiConfig.baseUrl}/profile/');
    final request = http.MultipartRequest('PATCH', url);

    request.headers['Authorization'] = 'Token $token';

    request.fields['phone'] = phone;
    request.fields['address'] = address;

    if (imageFile != null) {
      final bytes = await imageFile.readAsBytes();

      request.files.add(
        http.MultipartFile.fromBytes(
          'profile_image',
          bytes,
          filename: imageFile.name,
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data.toString());
  }
}