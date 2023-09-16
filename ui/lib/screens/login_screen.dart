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
  bool loading = false; // New state variable for loading

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: loading
            ? const CircularProgressIndicator() // Show loading indicator when loading is true
            : ElevatedButton(
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
    setState(() {
      loading = true; // Set loading to true when sign-in starts
    });

    User? user = await _authService.signInWithGoogle();

    setState(() {
      loading = false; // Set loading to false when sign-in completes
    });

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
