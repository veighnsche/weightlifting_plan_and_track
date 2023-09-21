import 'package:flutter/material.dart';
import '../widgets/app_logo.dart';

class SplashScreen extends StatelessWidget {
  final String splashText;

  const SplashScreen({required this.splashText, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color of splash screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppLogo(),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the row content
              children: [
                Text(
                  splashText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(width: 10.0), // Some spacing between text and loader
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                  // Setting the color to match the text color
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
