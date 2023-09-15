import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'api_service.dart';

class UserService {
  final ApiService _apiService = ApiService();

  Future<bool> isOnboarded() async {
    try {
      final response =
          await _apiService.get('http://localhost:3000/user/check-onboarding');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['onboarded'] as bool;
      } else {
        throw Exception('Failed to check onboarding status');
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return false;
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
