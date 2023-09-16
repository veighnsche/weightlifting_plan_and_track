import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weightlifting_plan_and_track/services/auth_service.dart';

import '../services/user_service.dart';
import '../widgets/user_details_form.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final UserService _userService = UserService();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void _handleUpsert(Map<String, dynamic> userData) async {
    try {
      await _userService.upsert(userData);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/chat');
      });
    } catch (error) {
      _scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text("Error during upsert: $error"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final User user = authService.currentUser;
    final String name = user.displayName ?? "User";
    final String? photoUrl = user.photoURL;

    return Scaffold(
      key: _scaffoldMessengerKey,
      appBar: AppBar(
        title: const Text("Onboarding"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (photoUrl != null)
              CircleAvatar(
                backgroundImage: NetworkImage(photoUrl),
                radius: 40,
              ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: UserDetailsForm(onSubmit: (userData) {
              _scaffoldMessengerKey.currentState?.showSnackBar(
                const SnackBar(
                  content: Text("Updating your details..."),
                  duration: Duration(seconds: 2),
                ),
              );
              _handleUpsert(userData);
            })),
          ],
        ),
      ),
    );
  }
}
