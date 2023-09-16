import 'package:flutter/material.dart';

import '../services/user_details_service.dart';

class OnboardingStatusChecker extends StatelessWidget {
  final Function(bool) handleDone;

  const OnboardingStatusChecker({super.key, required this.handleDone});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: UserDetailsService().isOnboarded(),
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
            handleDone(snapshot.data ?? false);
          });
          return const SizedBox.shrink();
        }
      },
    );
  }
}
