import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'api_service.dart';

class UserDetailsService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> read() async {
    try {
      final response =
          await _apiService.get('http://localhost:3000/user/read');

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

  Future<void> upsert(Map<String, dynamic> data) async {
    try {
      final response =
          await _apiService.post('http://localhost:3000/user/upsert', data);

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to upsert user');
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }
}
