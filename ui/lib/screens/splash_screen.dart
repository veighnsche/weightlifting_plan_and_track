import 'package:flutter/material.dart';

import '../widgets/auth_state_stream.dart';
import '../widgets/onboarding_status_checker.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool authStreamStateDone = false;

  void handleAuthStateStreamDone() {
    setState(() {
      authStreamStateDone = true;
    });
  }

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
            if (!authStreamStateDone)
              AuthStateStream(handleDone: handleAuthStateStreamDone),

            if (authStreamStateDone)
              OnboardingStatusChecker(
                  handleDone: handleOnboardingStatusCheckerDone),

          ],
        ),
      ),
    );
  }
}
