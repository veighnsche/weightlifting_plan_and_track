import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'api_service.dart';

class UserSettingService {
  final ApiService _apiService = ApiService();

  Future<bool> sendInstructions(Map<String, dynamic> settings) async {
    try {
      final response = await _apiService
          .post('http://localhost:3000/user/settings', {'settings': settings});

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to send instructions');
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return false;
  }

  Future<Map<String, dynamic>> getSettings() async {
    try {
      final response = await _apiService.get('http://localhost:3000/user/settings');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get settings');
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return {};
  }
}
