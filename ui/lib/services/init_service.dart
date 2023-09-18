import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'api_service.dart';

class InitService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> init() async {
    try {
      final response = await _apiService.get('http://localhost:3000/init');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        return data;
      } else {
        throw Exception('Failed to read user');
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return {};
    }
  }
}
