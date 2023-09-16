import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weightlifting_plan_and_track/screens/splash_screen.dart';

import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  bool error = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text('Sign in with Google'),
          onPressed: () {
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            _signIn(scaffoldMessenger);
          },
        ),
      ),
    );
  }

  Future<void> _signIn(ScaffoldMessengerState scaffoldMessenger) async {
    User? user = await _authService.signInWithGoogle();
    if (user == null) {
      setState(() {
        error = true;
      });
      // Display the error message using a SnackBar
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Something went wrong, please try again'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const SplashScreen()),
            (Route<dynamic> route) => false,
          );
        }
      });
    }
  }
}
