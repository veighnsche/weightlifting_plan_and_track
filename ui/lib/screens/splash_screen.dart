import 'package:flutter/material.dart';

import '../widgets/onboarding_status_checker.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void handleOnboardingStatusCheckerDone(bool onboarded) {
    if (onboarded) {
      Navigator.pushReplacementNamed(context, '/chat');
    } else {
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Weightlifting Plan and Track',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            OnboardingStatusChecker(
                handleDone: handleOnboardingStatusCheckerDone),
          ],
        ),
      ),
    );
  }
}
