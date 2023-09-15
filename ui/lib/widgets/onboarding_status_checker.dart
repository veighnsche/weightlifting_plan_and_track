import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services/auth_service.dart';

class OnboardingStatusChecker extends StatefulWidget {
  const OnboardingStatusChecker({Key? key}) : super(key: key);

  @override
  _OnboardingStatusCheckerState createState() => _OnboardingStatusCheckerState();
}

class _OnboardingStatusCheckerState extends State<OnboardingStatusChecker> {
  Future<bool> _isUserOnboarded() async {
    try {
      final token = await AuthService().token; // Retrieve the Firebase auth token

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
        // Handle non-200 status codes appropriately
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
          // While waiting for the future to complete, display a loading indicator
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16), // Add some spacing
                Text(
                  "Checking onboarding status...",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          // Handle error state
          return Text("Error: ${snapshot.error}");
        } else {
          // Future has completed
          if (snapshot.data == true) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/chat');
            });
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/onboarding');
            });
          }
          // Placeholder, this won't be displayed
          return Container();
        }
      },
    );
  }
}
