import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services/auth_service.dart';

class OnboardingStatusChecker extends StatefulWidget {
  final Function(bool) handleDone;

  const OnboardingStatusChecker({super.key, required this.handleDone});

  @override
  _OnboardingStatusCheckerState createState() =>
      _OnboardingStatusCheckerState();
}

class _OnboardingStatusCheckerState extends State<OnboardingStatusChecker> {
  Future<bool> _isUserOnboarded() async {
    try {
      final token = await AuthService().token;

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('http://localhost:3000/user/check-onboarding'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isUserOnboarded(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  "Checking onboarding status...",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.handleDone(snapshot.data ?? false);
          });
          return const SizedBox.shrink();
        }
      },
    );
  }
}
