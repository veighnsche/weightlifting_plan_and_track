import 'dart:convert';

import 'package:http/http.dart' as http;

import 'auth_service.dart';

class ApiService {
  final AuthService _authService = AuthService();

  Future<http.Response> get(String url) async {
    final token = await _authService.token;

    if (token == null) {
      throw Exception('Token not found');
    }

    return http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> post(String url, Map<String, dynamic> body) async {
    final token = await _authService.token;

    if (token == null) {
      throw Exception('Token not found');
    }

    return http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );
  }
}
