import 'package:flutter/material.dart';
import 'package:weightlifting_plan_and_track/widgets/onboarding_status_checker.dart';
import 'package:weightlifting_plan_and_track/widgets/socket_connection_stream.dart';

import '../widgets/auth_state_stream.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Weightlifting Plan and Track',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            AuthStateStream(
              child: SocketConnectionStream(
                child: OnboardingStatusChecker(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
